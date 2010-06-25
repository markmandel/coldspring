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

<cffunction name="testMethod" hint="test an individual method object" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.hello = createObject("component", "unittests.reflect.com.Hello").init();

		local.meta = getMetadata(local.hello);
		local.func = getMetadata(local.hello.sayHello);

		local.method = createObject("component", "coldspring.reflect.Method").init(local.func, local.meta);

		AssertEquals("sayHello", local.method.getMethodName());

		local.value = local.method.invokeMethod(local.hello);

		AssertEquals("hello", local.value);

		local.args = {str="123"};
		local.value = local.method.invokeMethod(local.hello, local.args);

		AssertEquals("123", local.value);
    </cfscript>
</cffunction>

<cffunction name="testMethodFactorycreateMethod" hint="testing of the method factory creating a method" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.methodFactory = createObject("component", "coldspring.reflect.MethodFactory").init();

		local.method = local.methodFactory.createMethod("unittests.reflect.com.Hello", "sayHello");

		AssertEquals("sayHello", local.method.getMethodName());

		local.hello = createObject("component", "unittests.reflect.com.Hello").init();

		local.value = local.method.invokeMethod(local.hello);

		AssertEquals("hello", local.value);

		local.args = {str="123"};
		local.value = local.method.invokeMethod(local.hello, local.args);

		AssertEquals("123", local.value);

		local.method2 = local.methodFactory.createMethod("unittests.reflect.com.Hello", "sayHello");

		assertSame(local.method, local.method2);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>