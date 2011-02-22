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

<cfcomponent hint="tests for scope bean factory locator" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		props = {};
		props.uuid = createUUID();
		factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/scopeBeanFactoryLocator.xml"), props);
		key = "cs_" & props.uuid;
    </cfscript>
</cffunction>

<cffunction name="testPostProcessorPutsInScope" hint="test to make sure the post processor is putting the right thing in the right scope"
			access="public" returntype="void" output="false">
	<cfscript>
		assertTrue(structKeyExists(application, key));
		assertTrue(structKeyExists(request, key));
		assertTrue(structKeyExists(session, key));
		assertTrue(structKeyExists(server, key));

		assertSame(factory, application[key]);
		assertSame(factory, session[key]);
		assertSame(factory, request[key]);
		assertSame(factory, server[key]);
    </cfscript>
</cffunction>

<cffunction name="testGetInstance" hint="test the get instance" access="public" returntype="void" output="false">
	<cfscript>
		assertSame(factory, factory.getBean("applicationBeanFactoryLocator").getInstance());
		assertSame(factory, factory.getBean("requestBeanFactoryLocator").getInstance());
		assertSame(factory, factory.getBean("sessionBeanFactoryLocator").getInstance());
		assertSame(factory, factory.getBean("serverBeanFactoryLocator").getInstance());
    </cfscript>
</cffunction>

<cffunction name="testBadScope" hint="testing a bad scope" access="public" returntype="void" output="false"
			mxunit:expectedException="coldspring.beans.factory.access.exception.InvalidScopeException">
	<cfscript>
		var locator = createObject("component","coldspring.beans.factory.access.ScopeBeanFactoryLocator").init();

		locator.setBeanFactoryScope("foobar");

		locator.getInstance();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>