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

<cfcomponent hint="stores the arguments that it used" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Storage" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="storeArgs" hint="store arguments in me." access="public" returntype="void" output="false">
	<cfscript>
		setArgs(arguments);
    </cfscript>
</cffunction>

<cffunction name="storeReturn" hint="Callback after a given method successfully returned. " access="public" returntype="void" output="false">
	<cfargument name="value" type="any" required="no" />
	<cfscript>
		println("Storing return: #arguments.value#");
		setReturn(arguments.value);
    </cfscript>
</cffunction>

<cffunction name="storeException" hint="Callback after a method throws an exception." access="public" returntype="void" output="false">
	<cfargument name="exception" type="struct" required="yes" />
	<cfscript>
		setException(arguments.exception);
    </cfscript>
</cffunction>

<cffunction name="getArgs" access="public" returntype="any" output="false">
	<cfreturn instance.Args />
</cffunction>

<cffunction name="getReturn" access="public" returntype="any" output="false">
	<cfreturn instance.return />
</cffunction>

<cffunction name="$getException" access="public" returntype="any" output="false">
	<cfreturn instance.Exception />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setException" access="private" returntype="void" output="false">
	<cfargument name="Exception" type="any" required="true">
	<cfset instance.Exception = arguments.Exception />
</cffunction>

<cffunction name="setArgs" access="private" returntype="void" output="false">
	<cfargument name="Args" type="any" required="true">
	<cfset instance.Args = arguments.Args />
</cffunction>

<cffunction name="setReturn" access="private" returntype="void" output="false">
	<cfargument name="return" type="any" required="true">
	<cfset instance.return = arguments.return />
</cffunction>

<cffunction name="println" hint="" access="private" returntype="void" output="false">
	<cfargument name="str" hint="" type="string" required="Yes">
	<cfscript>
		createObject("Java", "java.lang.System").out.println(arguments.str);
	</cfscript>
</cffunction>


</cfcomponent>