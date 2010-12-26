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

<cfcomponent hint="ordered object" implements="coldspring.core.Ordered" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Ordered" output="false">
	<cfargument name="order" hint="the order of this object" type="numeric" required="Yes">
	<cfscript>
		instance.order = arguments.order;
		setIdent(createUUID());
		return this;
	</cfscript>
</cffunction>

<cffunction name="getOrder" hint="Return the order value of this object, with a higher value meaning greater in terms of sorting.<br/>
		Higher values can be interpreted as lower priority. As a consequence, the object with the lowest value has highest priority.<br/>
		" access="public" returntype="numeric" output="false">
	<cfreturn instance.order />
</cffunction>

<cffunction name="getIdent" access="public" returntype="string" output="false">
	<cfreturn instance.ident />
</cffunction>

<cffunction name="setIdent" access="public" returntype="void" output="false">
	<cfargument name="ident" type="string" required="true">
	<cfset instance.ident = arguments.ident />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>