<!---
   Copyright 2010 Mark Mandel
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 --->

<cfcomponent hint="Tests for dynamic proxies" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="unit test setup" access="public" returntype="void" output="false">
	<cfscript>
		instance.handler = createObject("component", "unittests.core.com.Handler").init();
		instance.proxyFactory = createObject("component", "coldspring.core.proxy.DynamicProxyFactory").init();
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

		result = proxy.testMethodInvocation(argumentCollection=args);
		assertEquals(args.bar, result.args.bar);
		assertEquals(args.foo, result.args.foo);
    </cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>