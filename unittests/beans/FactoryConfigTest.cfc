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

<cfcomponent hint="Tests for things like beanNameAway, FactoryBean etc" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="the setup for the tests" access="public" returntype="void" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/factory.config.xml"));
    </cfscript>
</cffunction>

<cffunction name="testListFactory" hint="tests list factories" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.array = instance.factory.getBean("myListFactoryBean");

		assertTrue(isArray(local.array), "Should be an array");

		local.testArray = ["first value", "second value", "third value"];

		assertEquals(local.testArray, local.array);

		local.factoryBean = instance.factory.getBean("&myListFactoryBean");

		assertEquals("coldspring.beans.factory.config.ListFactoryBean", getMetadata(local.factoryBean).name);
    </cfscript>
</cffunction>

<cffunction name="testMapFactory" hint="tests map factories" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.map = instance.factory.getBean("myMapFactoryBean");

		assertTrue(isStruct(local.map), "Should be an struct");

		local.testMap = { foo = 1, bar = 2 };

		assertEquals(local.testMap, local.map);

		local.factoryBean = instance.factory.getBean("&myMapFactoryBean");

		assertEquals("coldspring.beans.factory.config.MapFactoryBean", getMetadata(local.factoryBean).name);
    </cfscript>
</cffunction>

<cffunction name="testJSONFactory" hint="tests JSON factories" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.map = instance.factory.getBean("myJSONFactoryBean");

		local.array = [1.0,2.0,3.0,4.0]; //weird json conversion
		local.struct = {foo = "bar"};

		assertEquals(local.array, local.map.array);
		assertEquals(local.struct, local.map.struct);
		assertEquals("Frodo Baggins", local.map.string);
	</cfscript>
</cffunction>

<cffunction name="beanPostProcessorTest" hint="testing post processing" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.factoryBean = instance.factory.getBean("&myMapFactoryBean");
		local.map = instance.factory.getBean("myMapFactoryBean");

		assertEquals("&myMapFactoryBean", local.factoryBean.beforeName);
		assertEquals("&myMapFactoryBean", local.factoryBean.afterName);
    </cfscript>
</cffunction>

<cffunction name="registryAndBeanFactoryPostProcessorTest" hint="testing post processing" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.counter = instance.factory.getBean("beanCounter");

		assertEquals(16, local.counter.getRegistryCount());
		assertEquals(local.counter.getFactoryCount(), local.counter.getRegistryCount());
    </cfscript>
</cffunction>

<cffunction name="beanNameAwareTest" hint="testing of whether or not a bean is name aware" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.bean = instance.factory.getBean("nameAware");

		assertEquals("nameAware", local.bean.getBeanName());
    </cfscript>
</cffunction>

<cffunction name="beanFactoryAwareTest" hint="testing of whether or not a bean is factory aware" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.bean = instance.factory.getBean("factoryAware");

		assertSame(instance.factory, local.bean.getBeanFactory());
    </cfscript>
</cffunction>

<cffunction name="listTargetClassTest" hint="test to see if the target class works" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.array = instance.factory.getBean("myArrayListBean");

		local.testArray = ["first value", "second value", "third value"];

		assertEquals(local.testArray, local.array);

		AssertEquals("java.util.ArrayList", local.array.getClass().getName());
    </cfscript>
</cffunction>

<cffunction name="mapTargetClassTest" hint="tests to see if target class workds" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.map = instance.factory.getBean("myHashMapBean");

		assertTrue(isStruct(local.map), "Should be an struct");

		local.testMap = createObject("java", "java.util.HashMap");
		local.testMap.put("foo", 1);
		local.testMap.put("bar", 2);

		assertEquals(local.testMap, local.map);

		AssertEquals("java.util.HashMap", local.map.getClass().getName());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>