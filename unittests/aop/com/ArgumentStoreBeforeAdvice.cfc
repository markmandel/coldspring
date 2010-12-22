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

<cfcomponent hint="stores the arguments that it used" implements="coldspring.aop.MethodBeforeAdvice" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ArgumentStoreBeforeAdvice" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="before" hint="Callback before a given method is invoked." access="public" returntype="void" output="false">
	<cfargument name="method" type="coldspring.core.reflect.Method" required="yes" />
	<cfargument name="args" type="struct" required="yes" />
	<cfargument name="target" type="any" required="yes" />
	<cfscript>
		setArgs(arguments.args);
    </cfscript>
</cffunction>

<cffunction name="getArgs" access="public" returntype="any" output="false">
	<cfreturn instance.Args />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->
<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setArgs" access="private" returntype="void" output="false">
	<cfargument name="Args" type="any" required="true">
	<cfset instance.Args = arguments.Args />
</cffunction>

</cfcomponent>