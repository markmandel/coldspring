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

<cfcomponent hint="test for class data" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		reflectionService = createObject("component", "coldspring.core.reflect.ReflectionService").init();
		reflectionService.clearCache();
    </cfscript>
</cffunction>

<cffunction name="testSimpleProperties" hint="tests some simple properties on a class and interface" access="public" returntype="void" output="false">
	<cfscript>
		var class = reflectionService.loadClass("coldspring.aop.MethodInterceptor");

		assertTrue(class.isInterface());
		assertEquals("coldspring.aop.MethodInterceptor", class.getName());
		assertEquals("coldspring.aop", class.getPackage());

		class = reflectionService.loadClass("coldspring.aop.framework.adapter.AfterReturningAdviceInterceptor");

		assertFalse(class.isInterface());
		assertEquals("coldspring.aop.framework.adapter.AfterReturningAdviceInterceptor", class.getName());
		assertEquals("coldspring.aop.framework.adapter", class.getPackage());
    </cfscript>
</cffunction>

<cffunction name="testSubclass" hint="testing of subclasses" access="public" returntype="void" output="false">
	<cfscript>
		var class = reflectionService.loadClass("coldspring.aop.Invocation");

		assertTrue(class.hasSuperClass());
		assertEquals("coldspring.aop.Joinpoint", class.getSuperClass().getName());

		class = class.getSuperClass();

		assertTrue(class.hasSuperClass());
		assertEquals("WEB-INF.cftags.component", class.getSuperClass().getName());

		class = class.getSuperClass();
		assertFalse(class.hasSuperClass());

		//interface
		class = reflectionService.loadClass("coldspring.aop.AfterAdvice");

		assertFalse(class.hasSuperClass());
    </cfscript>
</cffunction>

<cffunction name="testInterfaces" hint="test out interface implementations" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		//start with a class
		local.class = reflectionService.loadClass("coldspring.aop.PointcutAdvisor");

		local.interfaces = local.class.getInterfaces();
		assertEquals(2, Arraylen(local.interfaces));

		local.interfaceNames = [local.interfaces[1].getName(), local.interfaces[2].getName()];

		assertTrue(local.interfaceNames.contains("coldspring.aop.Advisor"));
		assertTrue(local.interfaceNames.contains("coldspring.core.Ordered"));

		//move on to interfaces
		local.class = reflectionService.loadClass("coldspring.aop.MethodBeforeAdvice");

		local.interfaces = local.class.getInterfaces();
		assertEquals(1, Arraylen(local.interfaces));

		assertEquals("coldspring.aop.BeforeAdvice", local.interfaces[1].getName());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>