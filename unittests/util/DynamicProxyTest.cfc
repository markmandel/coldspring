<cfcomponent hint="Tests for dynamic proxies" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="unit test setup" access="public" returntype="void" output="false">
	<cfscript>
		instance.handler = createObject("component", "unittests.util.com.Handler").init();
		instance.proxyFactory = createObject("component", "coldspring.util.DynamicProxyFactory").init();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="testSameType" hint="test that they are the same type" access="public" returntype="void" output="false">
	<cfscript>
		var proxy = instance.proxyFactory.createProxy(getMetaData(this).name, instance.handler);
		var class = getMetadata(this).name;

		assertTrue(isInstanceOf(proxy, class), "Should be the same as myself [1]");

		//do it again to test the prototype cache
		proxy = instance.proxyFactory.createProxy(getMetaData(this).name, instance.handler);

		assertTrue(isInstanceOf(proxy, class), "Should be the same as myself [2]");
    </cfscript>
</cffunction>

<cffunction name="testisProxy" hint="test to see of the proxy testing facilities are working" access="public" returntype="void" output="false">
	<cfscript>
		var proxy = instance.proxyFactory.createProxy(getMetaData(this).name, instance.handler);

		assertFalse(instance.proxyFactory.isProxy(this), "this is not a proxy");
		assertTrue(instance.proxyFactory.isProxy(proxy), "this is my created proxy");
    </cfscript>
</cffunction>

<cffunction name="testMethodInvocation" hint="test to see if the method invocation is working" access="public" returntype="void" output="false">
	<cfscript>
		var proxy = instance.proxyFactory.createProxy(getMetaData(this).name, instance.handler);
		var args = {foo="bar", bar="foo"};
		var result = proxy.doMethod(argumentCollection=args);

		assertSame(proxy, result.proxy);
		assertEquals("doMethod", result.method);

		assertEquals(args.bar, result.args.bar);
		assertEquals(args.foo, result.args.foo);
    </cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>