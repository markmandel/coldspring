<cfcomponent hint="tests for generating aop proxies" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup, create a proxy factory" access="public" returntype="void" output="false">
	<cfscript>
		proxyFactory = createObject("component", "coldspring.aop.framework.ProxyFactory").init();
		hello = createObject("component", "unittests.aop.com.Hello").init();
		goodbye = createObject("component", "unittests.aop.com.Goodbye").init();
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

		pointcut.setExpression("@annotation(dostuff='true') AND @target(dothings='true')");

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

<cffunction name="testTripleAndExpression" hint="test a 3 deep and and then ! expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("@annotation(dostuff='true') AND @target(dothings='true') AND !@target(notdothings)");

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

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
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

		assertEquals("hello", local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));

		local.proxy = proxyFactory.getProxy(goodbye);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

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

<cffunction name="testTargetExpression" hint="test a target expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("target(unittests.aop.com.Hello)");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		//hello
		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));

		//goodbye
		local.proxy = proxyFactory.getProxy(goodbye);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testSubPackageExpression" hint="test a target expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("within(unittests.aop..*)");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		//hello
		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testSubPackageExpressionSamePackage" hint="test a target expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("within(unittests.aop.com..*)");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		//hello
		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));

		//sub package
		var hello = createObject("component", "unittests.aop.com.sub.Hello").init();

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testNotSubPackage" hint="test a target expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("within(unittests.NNN.com..*)");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		//hello
		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testPackageExpression" hint="test a target expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("within(unittests.aop.com.*)");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		//hello
		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));

		//sub package
		var hello = createObject("component", "unittests.aop.com.sub.Hello").init();

		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testNotPackage" hint="test a target expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("within(unittests.NNN.com.*)");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		//hello
		local.proxy = proxyFactory.getProxy(hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testBadWithin" hint="Test a within expression that doesn't end in ..*/.*" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.aop.expression.exception.InvalidExpressionException">
	<cfscript>
		var local = {};

		pointcut.setExpression("within(unittests.NNN.com)");

		//force the expressiont to be built.
		makePublic(pointcut, "buildExpressionPointcut");
		pointcut.buildExpressionPointcut();
    </cfscript>
</cffunction>

<cffunction name="testNegateTargetExpression" hint="test a target expression" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		pointcut.setExpression("!target(unittests.aop.com.Hello)");

		local.advisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(pointcut, interceptor);

		proxyFactory.addAdvisor(local.advisor);

		local.proxy = proxyFactory.getProxy(hello);

		//hello
		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		assertEquals("Goodbye", local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));

		//goodbye
		local.proxy = proxyFactory.getProxy(goodbye);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		assertEquals(reverse("Goodbye"), local.proxy.sayGoodbye());

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testBadExpression" hint="test an errornous message" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		//we will do this as a check exception, as we want to make sure the right message comes out.
		local.check = false;

		try
		{
			pointcut.setExpression("!@annotation(dostuff=true') AND !@annotation(dothings='true')");
			makePublic(pointcut, "buildExpressionPointcut");
			pointcut.buildExpressionPointcut();
		}
		catch(coldspring.aop.expression.exception.InvalidExpressionException exc)
		{
			local.check = true;

			assertEquals("Invalid expression syntax found near 'true')'", exc.message);
			assertEquals("At line 1, 21 an error occured: mismatched input 'true' expecting set null", exc.detail);
		}

		if(!local.check)
		{
			fail("This bad expression did not throw an error!");
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>