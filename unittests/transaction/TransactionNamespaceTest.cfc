<!---
	Copyright 2011 Mark Mandel

	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	   http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--->

<cfcomponent hint="Tests for the Transaction namespace" output="false" extends="unittests.AbstractTestCase">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		coldspring = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/tx-namespace-advise.xml"));
	</cfscript>
</cffunction>

<cffunction name="testNoIsolation" hint="make sure no order or isolation has been set" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.transaction = coldspring.getBean("transaction");

		assertFalse(local.transaction.hasIsolation());
	</cfscript>
</cffunction>

<cffunction name="testHighestOrder" hint="test to make sure the interceptor should have the highest precedence" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.transaction = coldspring.getBean("transaction");
		local.orderComparator = getComponentMetadata("coldspring.core.OrderComparator").singleton.instance;

		assertEquals(local.orderComparator.getHighestPrecedence(), local.transaction.getOrder());
	</cfscript>
</cffunction>


<cffunction name="testSetOrder" hint="test to make sure the interceptor should have the set order" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.transaction = coldspring.getBean("transactionOrder");

		assertEquals(1, local.transaction.getOrder());
	</cfscript>
</cffunction>

<cffunction name="testIsolation" hint="test the set isolation level" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.transaction = coldspring.getBean("transactionIsolation");

		assertEquals("repeatable_read", local.transaction.getIsolation());
	</cfscript>
</cffunction>


<cffunction name="testGateway" hint="tests a manual gateway" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
	</cfscript>
	<!--- cleanup --->
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
	<cfscript>
		local.proxy = coldspring.getBean("gateway");

		debug(local.proxy);

		//gate that it is a proxy
		local.proxyFactory = createObject("component", "coldspring.core.proxy.DynamicProxyFactory").init();

		assertTrue(local.proxyFactory.isProxy(local.proxy));

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