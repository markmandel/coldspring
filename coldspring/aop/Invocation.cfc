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

<cfcomponent extends="Joinpoint" hint="This interface represents an invocation in the program.<br/>
	An invocation is a joinpoint and can be intercepted by an interceptor." output="false"
	colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getArguments" hint="Get the arguments as a struct. It is possible to change element values within this struct to change the arguments." access="public" returntype="struct" output="false">
	<cfreturn instance.arguments />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setArguments" access="private" returntype="void" output="false">
	<cfargument name="args" type="struct" required="true">
	<cfset instance.arguments = arguments.args />
</cffunction>

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfargument name="target" hint="the original object" type="any" required="Yes">
	<cfargument name="proxy" hint="the AOP proxy for the target" type="any" required="Yes">
	<cfargument name="args" hint="the arguments to go through to the function" type="struct" required="Yes">
	<cfscript>
		super.init(arguments.target, arguments.proxy);
		setArguments(arguments.args);
    </cfscript>
</cffunction>

</cfcomponent>