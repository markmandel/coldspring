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
				,root = "unittests.testBeans"
				,wheelClass = "${root}.Wheel"

				,parentCar = "abstractCar"
				,metakey = "myKey"
				,metaValue = "myMetaValue"
				,spareKey = "mySpareKey"
				,gearValue = "17"
			};

		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/dynamic-properties.xml"), props);
    </cfscript>
</cffunction>

<cffunction name="testSimpleValue" hint="test that a simple value has been switched" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car1");

		assertEquals("red", local.car.getColor().getName());

		assertEquals("${ignored}", local.car.getMake());
    </cfscript>
</cffunction>

<cffunction name="testRecursiveProperties" hint="test recursive properties" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car1");

		local.wheels = local.car.getWheels();

		assertEquals("unittests.testBeans.Wheel", getMetadata(local.wheels[1]).name);
    </cfscript>
</cffunction>

<cffunction name="testParentProperty" hint="parent dynamic property" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car2");

		assertEquals("unittests.testBeans.Car", getMetadata(local.car).name);
    </cfscript>
</cffunction>

<cffunction name="testMetaProperties" hint="test taht dynamic properties work for meta" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.beanDef = instance.factory.getBeanDefinition("car2");

		local.meta = StructFind(local.beanDef.getConstructorArgs(), "engine").getMeta();

		assertTrue(structKeyExists(local.meta, "myKey"), "myKey should exist");

		assertEquals(local.meta.engineMeta2, "myMetaValue-foo");
    </cfscript>
</cffunction>

<cffunction name="testPropertyKey" hint="test dynmaic properrty as key in map" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car2");

		local.wheels = local.car.getWheels();

		AssertTrue(structKeyExists(local.wheels, "mySpareKey"), "mySpareKey should exist");
    </cfscript>
</cffunction>

<cffunction name="testListProperty" hint="dynamic property in a list" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car1");
		local.gears = local.car.getEngine().getGears();

		assertEquals(17, local.gears[3]);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>