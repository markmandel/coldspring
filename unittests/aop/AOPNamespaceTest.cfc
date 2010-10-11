<cfcomponent hint="Tests for aop namespace xml config of AOP" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="any" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace.xml"));
    </cfscript>
</cffunction>

<cffunction name="testReverseAnnotationAdvisor" hint="test simple reverse advice with a annotation based advisor" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.proxy = instance.factory.getBean("hello");

		local.value = local.proxy.sayHello();

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		assertEquals("hello", local.value);

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>