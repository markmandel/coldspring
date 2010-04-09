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

		assertSame(local.array, local.reget);
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

		assertSame(local.map, local.reget);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>