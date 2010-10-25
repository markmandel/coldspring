<cfcomponent hint="tests for generating aop proxies" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup, create a proxy factory" access="public" returntype="void" output="false">
	<cfscript>
		proxyFactory = createObject("component", "coldspring.aop.framework.ProxyFactory").init();
		hello = createObject("component", "unittests.aop.com.Hello").init();
		interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		pointcut = createObject("component", "coldspring.aop.expression.ExpressionPointcut").init();
    </cfscript>
</cffunction>

<cffunction name="testSimpleAnnotation" hint="test simple reverse advice" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("@annotation(dostuff='true')");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<cffunction name="testNotSimpleAnnotation" hint="test simple reverse advice, negated" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("!@annotation(dostuff='true')");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));

		assertEquals("Goodbye", local.proxy.sayGoodbye());
	</cfscript>
</cffunction>

<cffunction name="testAndExpression" hint="test a simple AND expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("@annotation(dostuff='true') AND @annotation(dothings='true')");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<cffunction name="testORExpression" hint="test a simple AND expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("@annotation(dostuff='true') OR @annotation(dothings='true')");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<cffunction name="testDoubleNotANDExpression" hint="test a double not AND expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("!@annotation(dostuff='true') AND !@annotation(dothings='true')");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<cffunction name="testDoubleNotORExpression" hint="test a double not OR expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("!@annotation(dostuff='true') OR !@annotation(dothings='true')");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>