<cfcomponent hint="Tests for xml config of AOP" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="any" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-simple.xml"));
    </cfscript>
</cffunction>

<cffunction name="testReverseAdvisor" hint="test simple reverse advice with advisor" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.proxy = instance.factory.getBean("hello");

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testReverseAdvice" hint="test simple reverse advice, without an advisor" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.proxy = instance.factory.getBean("helloWithAdvice");

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testDoubleReverseAdvice" hint="test two reverse advice applied" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.proxy = instance.factory.getBean("helloWithTwoAdvice");

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>


<cffunction name="testInvalidInterceptor" hint="tests the error for an invalid interceptor" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.beans.exception.BeanCreationException">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/errorXML/aop-invalid-interceptor.xml"));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>