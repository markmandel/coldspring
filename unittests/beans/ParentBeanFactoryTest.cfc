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

<cfcomponent hint="Unit Tests for parent bean bean factories" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="the setup for the tests" access="public" returntype="void" output="false">
	<cfscript>
		instance.parent = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/car-beans.xml"));

		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init();
		instance.factory.setParentBeanFactory(instance.parent);
		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/child-factory.xml"));

		instance.factory.refresh();
    </cfscript>
</cffunction>

<cffunction name="testGettingParentBean" hint="simple get of a parent bean" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.wheel1 = instance.factory.getBean("wheel");
		local.wheel2 = instance.factory.getBean("wheel");

		assertTrue(isInstanceOf(local.wheel1, "unittests.testBeans.Wheel"));
		assertTrue(isInstanceOf(local.wheel2, "unittests.testBeans.Wheel"));

		assertNotSame(local.wheel1, local.wheel2);
    </cfscript>
</cffunction>

<cffunction name="testGettingAlias" hint="test going up the alias tree" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("alsoCar1");

		assertEquals("Mustang", local.car.getMake());
    </cfscript>
</cffunction>

<cffunction name="testAutowireByName" hint="testing autowire by name through a a parent factory" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car3");

		assertEquals("Celica", local.car.getMake());

		assertEquals("blue", local.car.getColor().getName());
    </cfscript>
</cffunction>

<cffunction name="testParentBean" hint="tests parent bean across parent factories" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car2");

		assertEquals("Celica", local.car.getMake());

		assertEquals("red", local.car.getColor().getName());
	</cfscript>
</cffunction>

<cffunction name="testChildFactoryMentod" hint="Call to a factory method from a parent factory bean" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.engine = instance.factory.getBean("child-factory-engine");
		local.expected = [4,5,6];
		assertEquals(local.expected, local.engine.getGearS());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>