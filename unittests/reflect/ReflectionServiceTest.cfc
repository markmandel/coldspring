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

<cfcomponent hint="test util methods on the reflection service" extends="unittests.AbstractTestCase">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		reflectionService = createObject("component", "coldspring.core.reflect.ReflectionService").init();
    </cfscript>
</cffunction>

<cffunction name="testClassToPath" hint="testing converstion of a class to a path" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		local.class = "coldspring.beans.factory.BeanCache";
		local.path = expandPath("/coldspring/beans/factory/BeanCache.cfc");

		assertEquals(local.path, reflectionService.classToFile(local.class));
    </cfscript>
</cffunction>

<cffunction name="testClassExists" hint="testing converstion of a class to a path" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		local.class = "coldspring.beans.xml.config.AliasBeanDefinitionParser";

		assertTrue(reflectionService.classExists(local.class), "Class should exist: #local.class#");

		local.class = "coldspring.beans.foo.what.Thing";

		assertFalse(reflectionService.classExists(local.class), "Class should NOT exist: #local.class#");
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>