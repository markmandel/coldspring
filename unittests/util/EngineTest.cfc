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
<cfcomponent hint="Simple integration test for the engine, make sure nothing breaks" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		engine = createObject("component", "coldspring.util.Engine").init();
	</cfscript>
</cffunction>

<cffunction name="testGetName" hint="test getting the name" access="public" returntype="void" output="false">
	<cfscript>
		debug(engine.getName());
	</cfscript>
</cffunction>

<cffunction name="testGetMajorVersion" hint="test getting the major version" access="public" returntype="void" output="false">
	<cfscript>
		debug(engine.getMajorVersion());
	</cfscript>
</cffunction>

<cffunction name="testGetVersion" hint="test getting the full verison" access="public" returntype="void" output="false">
	<cfscript>
		debug(engine.getVersion());
	</cfscript>
</cffunction>

<cffunction name="testHasJavaClass" hint="Testing if a java class exists" access="public" returntype="void" output="false">
	<cfscript>
		assertTrue(engine.hasJavaClass("java.lang.String"));
		//check cache
		assertTrue(engine.hasJavaClass("java.lang.String"));

		assertFalse(engine.hasJavaClass("java.lang.Goats"));

		//check cache
		assertFalse(engine.hasJavaClass("java.lang.Goats"));
	</cfscript>
</cffunction>

<cffunction name="testORMEnabled" hint="testing orm enabled" access="public" returntype="void" output="false">
	<cfscript>
		debug(engine.ormEnabled());

		//cached
		engine.ormEnabled();
	</cfscript>
</cffunction>

<cffunction name="testgetFunctionCalledNameEnabled" hint="test getFunctionCalledNameEnabled" access="public" returntype="void" output="false">
	<cfscript>
		debug(engine.getFunctionCalledNameEnabled());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>