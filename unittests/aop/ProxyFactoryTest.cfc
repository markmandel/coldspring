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

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>