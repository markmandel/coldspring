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

<cfcomponent hint="handler that just passes out what comes in" implements="coldspring.util.InvocationHandler" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Handler" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="Processes a method invocation one a proxy instance and returns the result.
	This method will be invoked on an invocation handler when a method is invoked on a proxy instance that it is assosciated with." access="public" returntype="any" output="false">
	<cfargument name="proxy" type="any" required="yes" />
	<cfargument name="method" type="string" required="yes" />
	<cfargument name="args" type="struct" required="yes" />
	<cfreturn arguments />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>