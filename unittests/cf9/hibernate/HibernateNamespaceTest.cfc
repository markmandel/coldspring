<!---
	Copyright 2012 Mark Mandel

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
<cfcomponent hint="Tests for the hibernate namespace." extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		//for convenience
		coldspring = application.coldspring;
	</cfscript>
</cffunction>

<cffunction name="testSessionWrapper" hint="test to make sure it's a session wrapper" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.sessionWrapper = coldspring.getBean("sessionWrapper");

		assertEquals("coldspring.orm.hibernate.SessionWrapper", getMetadata(local.sessionWrapper).name);
	</cfscript>
</cffunction>

<cffunction name="testSessionWrapperHasBeanInjector" hint="test that the session wrapper has a bean injector" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.sessionWrapper = coldspring.getBean("sessionWrapper");

		local.beanInjector = local.sessionWrapper.getBeanInjector();

		assertEquals("coldspring.beans.wiring.AutowireByNameBeanInjector", getMetadata(local.beanInjector).name);

		local.foo = local.sessionWrapper.new("Foo");
		assertEquals("Gandalf", local.foo.getInject());
	</cfscript>
</cffunction>
	
<cffunction name="testGetDefaultFlushMode" hint="make sure the default flush mode is set" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.sessionWrapper = coldspring.getBean("sessionWrapper");

		assertEquals("COMMIT", local.sessionWrapper.getDefaultFlushMode());
	</cfscript>
</cffunction>

<cffunction name="testFactoryNameSet" hint="make sure that coldspring ends up in the application scope" access="public" returntype="void" output="false">
	<cfscript>
		assertTrue(structKeyExists(application, "coldspring2"));

		assertTrue(isInstanceOf(application.coldspring2, "coldspring.beans.BeanFactory"));
	</cfscript>
</cffunction>

<cffunction name="testStringTransaction" hint="testing out if the strict transactions where set" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.sessionWrapper = coldspring.getBean("sessionWrapper");

		assertTrue(local.sessionWrapper.getStrictTransactions());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>