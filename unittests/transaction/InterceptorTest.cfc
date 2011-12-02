<!---
   Copyright 2011 Mark Mandel
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and<cfset >
   limitations under the License.
 --->

<cfcomponent extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		engine = createObject("component", "coldspring.util.Engine").init();
		super.setup();
		interceptor = createObject("component", "coldspring.transaction.interceptor.TransactionInterceptor").init();
		proxyFactory = createObject("component", "coldspring.aop.framework.ProxyFactory").init();
    </cfscript>
    <cfif engine.ormEnabled()>
    	<cfset ormReload()>
	</cfif>
	<cftry>
		<cfquery datasource="#request.datasource#">
			drop table Bar
		</cfquery>
		<cfcatch>
			<!--- do nothing --->
		</cfcatch>
	</cftry>
	<cfquery datasource="#request.datasource#">
		create table Bar
		(
			id VARCHAR(36) PRIMARY KEY,
			name VARCHAR(255)
		)
		<!--- Stupid mysql MyISAM default :P --->
		<cfif request.dbtype eq "mysql">
			Engine = InnoDB
		</cfif>
	</cfquery>
</cffunction>

<cffunction name="testSessionWrapper" hint="test applying the transaction interceptor to the session wrapper" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		debug("ORM ON: #engine.ormEnabled()#");

		if(engine.ormEnabled())
		{
			local.sessionWrapper = createObject("component", "coldspring.orm.hibernate.SessionWrapper").init(strictTransactions=true);
			local.pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();

			local.methodAnnotation = {};
			local.methodAnnotation["orm:persist"] = true;

			local.pointcut.setMethodAnnotations(local.methodAnnotation);

			local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, interceptor);
			proxyFactory.addAdvisor(local.pointcutAdvisor);

			local.proxy = proxyFactory.getProxy(local.sessionWrapper);

			local.filter = {name= "Darth Vader"};
			local.result = local.proxy.get("Foo", local.filter);

			local.result.setName("Mark Mandel");

			local.proxy.save(local.result);

			local.proxy.clear();

			local.filter = {name= "Mark Mandel"};
			local.result = local.proxy.get("Foo", local.filter);

			assertEquals("Mark Mandel", local.result.getName());
		}
    </cfscript>
</cffunction>

<cffunction name="testManualGateway" hint="tests a manual gateway" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.gateway = createObject("component", "unittests.transaction.com.Gateway").init();

		local.advisor = createObject("component", "coldspring.aop.support.NamedMethodPointcutAdvisor").init();

		local.advisor.setMappedName("$insert");
		local.advisor.setAdvice(interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(local.gateway);

		//gate - value should inserted
		local.value = "Foo";

		try
        {
			local.gateway.$insert(local.value);
        }
        catch(Any e)
        {
        	//do nothing
        	debug(e);
        }

		local.result = local.gateway.get(local.value);

		assertEquals(local.value, local.result.name);
		assertEquals(1, local.result.recordCount);

		//test with transaction, it should not be there.

		local.value = "Bar";

		try
        {
			local.proxy.$insert(local.value);
        }
        catch(Any e)
        {
        	//do nothing
        	debug(e);
        }

		local.result = local.proxy.get(local.value);

		assertEquals("", local.result.name);
		assertEquals(0, local.result.recordCount);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>