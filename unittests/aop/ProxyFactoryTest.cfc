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

		assertEquals(local.exc.type, local.advice.$getException().type);
		assertEquals(local.exc.message, local.advice.$getException().message);
    </cfscript>
</cffunction>

<cffunction name="testMultipleTypesOfAdvice" hint="apply around, before, after and throws advice all at once" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();
		local.pointcut.setMappedName("sayHello");

		local.after = createObject("component", "unittests.aop.com.ReturnStoreAfterAdvice").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.after);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);


		local.around = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.around);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.before = createObject("component", "unittests.aop.com.ArgumentStoreBeforeAdvice").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.before);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.throws = createObject("component", "unittests.aop.com.ExceptionStoreThrowsAdvice").init();
		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.throws);
		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);
		assertTrue(structIsEmpty(local.before.getArgs()));
		//reversed, asit gets fired after the around advice
		assertEquals(reverse("hello"), local.after.getReturn());

		local.string = "Gargamel";

		local.value = local.proxy.sayHello(local.string);

		assertEquals(reverse(local.string), local.value);
		assertEquals(local.string, StructFind(local.before.getArgs(), "1"));
		assertEquals(reverse(local.string), local.after.getReturn());

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

		//should be reversed, as it fired first
		assertEquals(reverse("Gargamel"), local.after.getReturn());

		assertEquals(local.exc.type, local.throws.$getException().type);
		assertEquals(local.exc.message, local.throws.$getException().message);
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

<cffunction name="testReverseRegexAdvice" hint="test simple reverse advice, using a regex pointcut" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.RegexMethodPointcut").init();

		local.pointcut.setPattern("say.*");

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));
	</cfscript>
</cffunction>

<cffunction name="testClassAnnotationPointcutAny" hint="tests a * on a class based pointcut" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();

		local.classAnnotation =
		{
			dostuff = "*"
		};

		local.pointcut.setClassAnnotations(local.classAnnotation);

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));

		local.value = local.proxy.sayGoodbye();

		assertEquals(reverse("goodbye"), local.value);
    </cfscript>
</cffunction>

<cffunction name="testClassAnnotationPointcutNone" hint="tests a value on on a class based pointcut (therefore reverse should not apply)" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();

		local.classAnnotation =
		{
			dostuff = "false"
		};

		local.pointcut.setClassAnnotations(local.classAnnotation);

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));

		local.value = local.proxy.sayGoodbye();

		assertEquals("goodbye", local.value);
    </cfscript>
</cffunction>

<cffunction name="testMethodAnnotationPointcutAny" hint="tests a * on a method based pointcut" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();

		local.methodAnnotation =
		{
			dostuff = "*"
		};

		local.pointcut.setMethodAnnotations(local.methodAnnotation);

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		local.value = local.proxy.sayGoodbye();

		assertEquals(reverse("goodbye"), local.value);
    </cfscript>
</cffunction>

<cffunction name="testMethodAnnotationPointcutNone" hint="tests a value on a method based pointcut" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();

		local.methodAnnotation =
		{
			dostuff = "false"
		};

		local.pointcut.setMethodAnnotations(local.methodAnnotation);

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.proxy = instance.proxyFactory.getProxy(instance.hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));

		local.value = local.proxy.sayGoodbye();

		assertEquals("goodbye", local.value);
    </cfscript>
</cffunction>

<cffunction name="testOnMissingMethodClassAnnotation" hint="tests a * on a class based pointcut" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();

		local.classAnnotation =
		{
			dostuff = "*"
		};

		local.pointcut.setClassAnnotations(local.classAnnotation);

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.hello = createObject("component", "unittests.aop.com.sub.HelloOnMM").init();

		local.proxy = instance.proxyFactory.getProxy(local.hello);

		local.value = local.proxy.sayHello();

		assertEquals(reverse("hello"), local.value);

		local.string = "Gobble, Gobble";

		assertEquals(reverse(local.string), local.proxy.sayHello(local.string));

		//there is no goodbye, so calls onMissingMethod
		local.value = local.proxy.sayGoodbye();

		assertEquals(reverse("Missing!"), local.value);
    </cfscript>
</cffunction>

<cffunction name="testOnMissingMethodMethodAnnotation" hint="tests a * on a class based pointcut" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.interceptor = createObject("component", "unittests.aop.com.ReverseMethodInterceptor").init();
		local.pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();

		local.methodAnnotation =
		{
			dostuff = "true"
		};

		local.pointcut.setMethodAnnotations(local.methodAnnotation);

		local.pointcutAdvisor = createObject("component", "coldspring.aop.PointcutAdvisor").init(local.pointcut, local.interceptor);

		instance.proxyFactory.addAdvisor(local.pointcutAdvisor);

		local.hello = createObject("component", "unittests.aop.com.sub.HelloOnMM").init();

		local.proxy = instance.proxyFactory.getProxy(local.hello);

		local.value = local.proxy.sayHello();

		assertEquals("hello", local.value);

		local.string = "Gobble, Gobble";

		assertEquals(local.string, local.proxy.sayHello(local.string));

		//there is no goodbye, so calls onMissingMethod
		local.value = local.proxy.sayGoodbye();

		assertEquals(reverse("Missing!"), local.value);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>