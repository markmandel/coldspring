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

<cfcomponent hint="Unit tests for the method injectior" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="void" output="false">
	<cfscript>
		injector = createObject("component", "coldspring.util.MethodInjector").init();
		object = createObject("component", "unittests.util.com.Observer").init();
	</cfscript>
</cffunction>

<cffunction name="testIncludeFile" hint="test including a file" access="public" returntype="void" output="false">
	<cfscript>
		injector.start(object);

		injector.includeFile(object, "/unittests/util/mixin/udfs.cfm");
		injector.changeMethodScope(object, "sayHello", "public");

		injector.stop(object);

		assertEquals("Hello!", object.sayHello());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>