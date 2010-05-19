<cfcomponent hint="Util schema test" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="test setup" access="public" returntype="void" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/util.xml"));
    </cfscript>
</cffunction>

<cffunction name="testListFactory" hint="tests list factories" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.array = instance.factory.getBean("list");

		assertTrue(isArray(local.array), "Should be an array");

		local.testArray = ["first value", "second value", "third value"];

		assertEquals(local.testArray, local.array);

		local.reget = instance.factory.getBean("list");
    </cfscript>
</cffunction>

<cffunction name="testMapFactory" hint="tests map factories" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.map = instance.factory.getBean("map");

		assertTrue(isStruct(local.map), "Should be an struct");

		local.testMap = { foo = 1, bar = 2 };

		assertEquals(local.testMap, local.map);

		local.reget = instance.factory.getBean("map");

		assertSame(local.map, local.reget);

		local.reget = instance.factory.getBean("map2");

		assertNotSame(local.map, local.reget);
		assertEquals(local.map, local.reget);

		local.reget2 = instance.factory.getBean("map2");

		assertEquals(local.reget2, local.reget);
		assertNotSame(local.reget2, local.reget, "this should be prototype");
    </cfscript>
</cffunction>

<cffunction name="testJSONFactory" hint="tests JSON factories" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.map = instance.factory.getBean("json");

		local.array = [1.0,2.0,3.0,4.0]; //weird json conversion
		local.struct = {foo = "bar"};

		assertEquals(local.array, local.map.array);
		assertEquals(local.struct, local.map.struct);
		assertEquals("Frodo Baggins", local.map.string);

		local.reget = instance.factory.getBean("json");

		assertNotSame(local.map, local.reget);
	</cfscript>
</cffunction>

<cffunction name="listTargetClassTest" hint="test to see if the target class works" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.array = instance.factory.getBean("arrayList");

		local.testArray = ["first value", "second value", "third value"];

		assertEquals(local.testArray, local.array);

		AssertEquals("java.util.ArrayList", local.array.getClass().getName());
    </cfscript>
</cffunction>

<cffunction name="mapTargetClassTest" hint="tests to see if target class workds" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.map = instance.factory.getBean("hashMap");

		assertTrue(isStruct(local.map), "Should be an struct");
		AssertEquals("java.util.HashMap", local.map.getClass().getName());

		local.testMap = createObject("java", "java.util.HashMap");
		local.testMap.put("foo", 1);
		local.testMap.put("bar", 2);

		assertEquals(local.testMap, local.map);

	</cfscript>
</cffunction>

<cffunction name="testFactoryInnerBean" hint="test using util:map as an inner bean" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("carWithMap");

		local.wheels = local.car.getWheels();

		assertTrue(isStruct(local.wheels), "Should be a struct");
		assertEquals(4, structCount(local.wheels));

		local.array = [1,2,3,4];
		assertArrayEqualsNonOrdered(local.array, structKeyArray(local.wheels));

		assertEquals("unittests.testBeans.wheel", getMetadata(local.wheels["1"]).name);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>