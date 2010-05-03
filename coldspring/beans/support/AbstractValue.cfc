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

<cfcomponent hint="An abstract value for an Abstract Property" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getValue" hint="The value this obejct is" access="public" returntype="any" output="false">
	<cfreturn instance.value />
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="AbstractValue" output="false">
	<cfscript>
		var cloneable = createObject("component", "coldspring.util.Cloneable").init();

		return cloneable.clone(this);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
</cffunction>

<cffunction name="setValue" access="private" returntype="void" output="false">
	<cfargument name="value" type="any" required="true">
	<cfset instance.value = arguments.value />
</cffunction>

</cfcomponent>