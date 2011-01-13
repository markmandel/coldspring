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

<cfcomponent hint="unit tests for pointcuts" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="" access="public" returntype="void" output="false">
	<cfscript>
		var reflectionService = getComponentMetadata("coldspring.core.reflect.ReflectionService").singleton.instance;

		instance.class = reflectionService.loadClass(getMetaData(this).name);
		instance.method = instance.class.getMethod("setup");
    </cfscript>
</cffunction>

<cffunction name="testNamedMethodPointcutWildCard" hint="tests to see if a named method pointcut wildcard works " access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();

		local.pointcut.setMappedName("*");

		assertTrue(local.pointcut.matches(instance.method, instance.class));
    </cfscript>
</cffunction>

<cffunction name="testNamedMethodPointcutWithName" hint="tests to see if a named method pointcut with a name " access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.pointcut = createObject("component", "coldspring.aop.support.NamedMethodPointcut").init();

		local.pointcut.setMappedNames("setup");

		assertTrue(local.pointcut.matches(instance.method, instance.class));

		local.pointcut.setMappedNames("foo,setup");

		assertTrue(local.pointcut.matches(instance.method, instance.class));

		local.pointcut.setMappedNames("barrio");

		assertFalse(local.pointcut.matches(instance.method, instance.class));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>