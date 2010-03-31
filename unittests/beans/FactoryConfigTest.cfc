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
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>