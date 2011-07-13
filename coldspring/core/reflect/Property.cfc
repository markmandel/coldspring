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
<cfcomponent hint="Represents a cfproperty implementation" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Property" output="false">
	<cfargument name="meta" hint="the meta data for this particular property" type="struct" required="Yes">
	<cfscript>
		if(!structKeyExists(arguments.meta, "setter"))
		{
			arguments.meta.setter = true;
		}

		if(!structKeyExists(arguments.meta, "getter"))
		{
			arguments.meta.getter = true;
		}


		setMeta(arguments.meta);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getName" hint="The name of the property" access="public" returntype="string" output="false">
	<cfreturn getMeta().name />
</cffunction>

<cffunction name="getMeta" hint="Returns the meta data for a this particular property"
	access="public" returntype="struct" output="false">
	<cfreturn instance.meta />
</cffunction>

<cffunction name="hasGetter" hint="whether or not an generated getter has been requested on this property" access="public" returntype="boolean" output="false">
	<cfreturn getMeta().getter />
</cffunction>

<cffunction name="hasSetter" hint="whether or not an generated setter has been requested on this property" access="public" returntype="boolean" output="false">
	<cfreturn getMeta().setter />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setMeta" access="private" returntype="void" output="false">
	<cfargument name="meta" type="struct" required="true">
	<cfset instance.meta = arguments.meta />
</cffunction>

</cfcomponent>