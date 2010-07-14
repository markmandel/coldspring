<cfcomponent hint="Tests for xml config of AOP" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="any" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-simple.xml"));
    </cfscript>
</cffunction>

<cffunction name="testReverseAdvice" hint="test simple reverse advice" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.proxy = instance.factory.getBean("hello");

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>