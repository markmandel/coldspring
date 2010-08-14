<cfcomponent hint="tests for generating aop proxies" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup, create a proxy factory" access="public" returntype="void" output="false">
	<cfscript>
		instance.proxyFactory = createObject("component", "coldspring.aop.framework.ProxyFactory").init();
		instance.hello = createObject("component", "unittests.aop.com.Hello").init();
    </cfscript>
</cffunction>

<cffunction name="testNoAdvice" hint="test if no advice is applied, does the object still function as normal" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		assertEquals("hello", local.proxy.sayHello());

		assertEquals("Gobble, Gobble", local.proxy.sayHello("Gobble, Gobble"));
    </cfscript>
</cffunction>

<cffunction name="testReverseAdvice" hint="test simple reverse advice" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();

		local.pointcut.setMappedName("sayHello");

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<cffunction name="testMultipleAroundAdvice" hint="test reverse and argument change advice" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();
		local.pointcut.setMappedName("sayHello");

		local.interceptor = createObject("component", "unittests.aop.com.ArgumentChangeMethodInterceptor").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string) & "_", local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<cffunction name="testMethodBeforeAdvice" hint="testing method before advice" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.advice = createObject("component", "unittests.aop.com.ArgumentStoreBeforeAdvice").init();
		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();

		local.pointcut.setMappedName("sayHello");

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.advice);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		AssertTrue(structIsEmpty(local.advice.getArgs()));

		local.string = "Gobble, Gobble";

		local.proxy.sayHello(local.string);

		assertEquals(local.string, StructFind(local.advice.getArgs(), "1"));
    </cfscript>
</cffunction>

<cffunction name="testAfterReturningAdvice" hint="testing after returning advice" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.advice = createObject("component", "unittests.aop.com.ReturnStoreAfterAdvice").init();
		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();

		local.pointcut.setMappedName("sayHello");

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.advice);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(local.value, local.advice.getReturn());
		assertSame(instance.hello, local.advice.getTarget());

		local.string = "Gobble, Gobble";

		local.proxy.sayHello(local.string);

		assertEquals(local.string, local.advice.getReturn());
		assertSame(instance.hello, local.advice.getTarget());
    </cfscript>
</cffunction>

<cffunction name="testThrowsAdvice" hint="testing of throws advice" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		var check = false;

		try
		{

			local.advice = createObject("component", "unittests.aop.com.ExceptionStoreThrowsAdvice").init();
			local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();

			local.pointcut.setMappedName("sayHello");

			local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.advice);

			instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

			local.proxy = instance.proxyFactory.getProxy(instance.hello);

			local.value = local.proxy.sayHello("exceptionFoo");
		}
		catch(exceptionFoo exc)
		{
			check = true;
			local.exc = exc;
		}

		assertTrue(check, "ExceptionFoo should have been thrown");

		assertEquals(local.exc.type, local.advice.getExxception().type);
		assertEquals(local.exc.message, local.advice.getExxception().message);
    </cfscript>
</cffunction>

<cffunction name="testMultipleTypesOfAdvice" hint="apply around, before, after and throws advice all at once" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();
		local.pointcut.setMappedName("sayHello");

		local.around = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.around);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.before = createObject("component", "unittests.aop.com.ArgumentStoreBeforeAdvice").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.before);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.after = createObject("component", "unittests.aop.com.ReturnStoreAfterAdvice").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.after);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.throws = createObject("component", "unittests.aop.com.ExceptionStoreThrowsAdvice").init(); 
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.throws);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);
		assertTrue(structIsEmpty(local.before.getArgs()));
		//not reversed, asit gets fired before the around advice
		assertEquals("hello", local.after.getReturn());

		local.string = "Gargamel";

		local.value = local.proxy.sayHello(local.string);

		assertEquals(reverse(local.string), local.value);
		assertEquals(local.string, StructFind(local.before.getArgs(), "1"));
		assertEquals(local.string, local.after.getReturn());

		try
		{
			local.string = "exceptionFoo";
			local.check = false;

			local.proxy.sayHello(local.string);
		}
		catch(ExceptionFoo exc)
		{
			local.check = true;
			local.exc = exc;
		}

		assertTrue(local.check);
		assertEquals(local.string, StructFind(local.before.getArgs(), "1"));

		//this should be the same as before, as it never fired.
		assertEquals("Gargamel", local.after.getReturn());

		assertEquals(local.exc.type, local.throws.getExxception().type);
		assertEquals(local.exc.message, local.throws.getExxception().message);
    </cfscript>
</cffunction>

<cffunction name="testAddAdvice" hint="testing adding just some advice, it should go to the DefaultPoincutAdvisor" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();

		instance.proxyFactory.addAdvice(local.interceptor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>