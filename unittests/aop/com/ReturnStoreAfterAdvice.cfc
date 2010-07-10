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

<cfcomponent hint="After advice that stores the returned object" implements="coldspring.aop.AfterReturningAdvice" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ReturnStoreAfterAdvice" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="afterReturning" hint="Callback after a given method successfully returned. " access="public" returntype="void" output="false">
	<cfargument name="returnValue" type="any" required="no" />
	<cfargument name="method" type="coldspring.reflect.Method" required="yes" />
	<cfargument name="args" type="struct" required="yes" />
	<cfargument name="target" type="any" required="yes" />
	<cfscript>
		setReturn(arguments.returnValue);
		setTarget(arguments.target);
    </cfscript>
</cffunction>

<cffunction name="getReturn" access="public" returntype="any" output="false">
	<cfreturn instance.return />
</cffunction>

<cffunction name="getTarget" access="public" returntype="any" output="false">
	<cfreturn instance.target />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setReturn" access="private" returntype="void" output="false">
	<cfargument name="return" type="any" required="true">
	<cfset instance.return = arguments.return />
</cffunction>

<cffunction name="setTarget" access="private" returntype="void" output="false">
	<cfargument name="target" type="any" required="true">
	<cfset instance.target = arguments.target />
</cffunction>

</cfcomponent>