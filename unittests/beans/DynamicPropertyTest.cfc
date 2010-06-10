<!---
   Copyright 2010 Mark Mandel
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

<cfcomponent hint="Tests dynmic properties" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup the factory" access="public" returntype="void" output="false">
	<cfscript>
		var props =
			{
				colour = "red"
			};

		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/dynamic-properties.xml"), props);
    </cfscript>
</cffunction>

<cffunction name="testSimpleValue" hint="test that a simple value has been switched" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car1");

		assertEquals("red", local.car.getColor().getName());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>