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

<cfcomponent hint="Unit tests for Methods" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		reflectionService = createObject("component", "coldspring.core.reflect.ReflectionService").init();
		reflectionService.clearCache();
    </cfscript>
</cffunction>

<cffunction name="testDeclaredMethod" hint="test an individual method object" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.hello = createObject("component", "unittests.reflect.com.Hello").init();

		local.class = reflectionService.loadClass("unittests.reflect.com.Hello");

		assertTrue(local.class.hasDeclaredMethod("sayHello"));
		assertTrue(local.class.hasDeclaredMethod("privateMethod"));
		assertFalse(local.class.hasDeclaredMethod("sayHelloXXX"));
		assertFalse(local.class.hasDeclaredMethod("sayGoodbye"));

		local.method = local.class.getDeclaredMethod("sayHello");

		AssertEquals("sayHello", local.method.getName());

		local.value = local.method.invokeMethod(local.hello);

		AssertEquals("hello", local.value);

		local.args = {str="123"};
		local.value = local.method.invokeMethod(local.hello, local.args);

		AssertEquals("123", local.value);
    </cfscript>
</cffunction>

<cffunction name="testMethod" hint="testing of some more details of the method" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.class = reflectionService.loadClass("unittests.reflect.com.Hello");

		debug(local.class.getName());
    	debug(structKeyArray(local.class.getMethods()));

		assertTrue(local.class.hasMethod("sayHello"));
		assertTrue(local.class.hasMethod("sayGoodbye"));
		assertFalse(local.class.hasMethod("sayHelloXXX"));

		local.method = local.class.getMethod("sayHello");

		AssertEquals("sayHello", local.method.getName());
		assertTrue(local.method.isConcrete());

		local.hello = createObject("component", "unittests.reflect.com.Hello").init();

		local.value = local.method.invokeMethod(local.hello);

		AssertEquals("hello", local.value);

		local.args = {str="123"};
		local.value = local.method.invokeMethod(local.hello, local.args);

		AssertEquals("123", local.value);

		local.method2 = local.class.getMethod("sayHello");

		assertSame(local.method, local.method2);
    </cfscript>
</cffunction>

<cffunction name="testPrivateMethods" hint="test private methods" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.core.reflect.exception.MethodNotFoundException">
	<cfscript>
		var local = {};

		local.class = reflectionService.loadClass("unittests.reflect.com.Hello");

		assertTrue(local.class.hasDeclaredMethod("sayHello"));
		assertTrue(local.class.hasDeclaredMethod("privateMethod"));

		assertTrue(local.class.hasMethod("sayHello"));
		assertFalse(local.class.hasMethod("privateMethod"));

		local.method = local.class.getDeclaredMethod("privateMethod");

		assertEquals("privateMethod", local.method.getName());
		assertEquals("private", local.method.getAccess());
		assertTrue(local.method.isConcrete());

		assertEquals("void", local.method.getReturnType());

		local.params = local.method.getParameters();

		debug(local.params);

		assertEquals(1, ArrayLen(local.params));

		assertEquals("param1", local.params[1].getName());
		assertEquals("array", local.method.getParameter(1).getType());
		assertTrue(local.params[1].isRequired());
		assertFalse(local.params[1].hasDefault());

		local.class.getMethod("privateMethod");
	</cfscript>
</cffunction>

<cffunction name="testMethodNotFound" hint="test when a method does not exist" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.core.reflect.exception.MethodNotFoundException">
	<cfscript>
		var local = {};

		local.class = reflectionService.loadClass("unittests.reflect.com.Hello");
		local.method = local.class.getMethod("sayHelloXXX");
    </cfscript>
</cffunction>

<cffunction name="testDeclaredMethodNotFound" hint="test when a method does not exist" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.core.reflect.exception.MethodNotFoundException">
	<cfscript>
		var local = {};

		local.class = reflectionService.loadClass("unittests.reflect.com.Hello");
		local.method = local.class.getDeclaredMethod("sayHelloXXX");
    </cfscript>
</cffunction>

<cffunction name="testOnMissingMethod" hint="test whether you can get a method for on missing method" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		local.methodName = "sayHelloXXXX";

		local.class = reflectionService.loadClass("unittests.reflect.com.Hello");

		assertFalse(local.class.hasMethod(local.methodName));
		assertFalse(local.class.hasOnMissingMethod());

		local.class = reflectionService.loadClass("unittests.reflect.com.HelloOnMM");


		assertTrue(local.class.hasOnMissingMethod());

		assertTrue(local.class.hasMethod(local.methodName));

		local.method = local.class.getMethod(local.methodName);

		assertFalse(local.method.isConcrete());

		assertEquals(local.methodName, local.method.getName());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>