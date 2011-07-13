<!---
   Copyright 2011 Mark Mandel
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

<cfcomponent hint="Tests for dynamic proxies, when methods are created with cfproperty" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="unit test setup" access="public" returntype="void" output="false">
	<cfscript>
		instance.handler = createObject("component", "unittests.core.com.Handler").init();
		instance.proxyFactory = createObject("component", "coldspring.core.proxy.DynamicProxyFactory").init();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="testMethodInvocation" hint="test to see if the method invocation is working on property based methods" access="public" returntype="void" output="false">
	<cfscript>
		var proxy = instance.proxyFactory.createProxy("unittests.cf9.core.com.Foo", instance.handler);
		var args = {foo="bar", bar="foo"};

		var result = proxy.getBar(argumentCollection=args);

		debug(isNull(result) ? "NULL" : result);

		assertSame(proxy, result.proxy);
		assertEquals("getBar", result.method);

		assertEquals(args.bar, result.args.bar);
		assertEquals(args.foo, result.args.foo);

		result = proxy.setBar(argumentCollection=args);
		assertEquals("setBar", result.method);
		assertEquals(args.bar, result.args.bar);
		assertEquals(args.foo, result.args.foo);
    </cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>