
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

<cfcomponent hint="Simple Engine Bean">

<cfset this.id = CreateUUId() />

<cffunction name="init" hint="Constructor" access="public" returntype="Engine" output="false">
	<cfscript>
		setType("Default engine");

		return this;
	</cfscript>
</cffunction>

<cffunction name="getType" access="public" returntype="string" output="false">
	<cfreturn instance.type />
</cffunction>

<cffunction name="setType" access="private" returntype="void" output="false">
	<cfargument name="type" type="string" required="true">
	<cfset instance.type = arguments.type />
</cffunction>

<cffunction name="getGears" access="public" returntype="array" output="false">
	<cfreturn instance.Gears />
</cffunction>

<cffunction name="setGears" access="public" returntype="void" output="false">
	<cfargument name="Gears" type="array" required="true">
	<cfset instance.Gears = arguments.Gears />
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="Engine" output="false">
	<cfscript>
		var cloneable = createObject("component", "coldspring.util.Cloneable").init();

		return cloneable.clone(this);
    </cfscript>
</cffunction>

</cfcomponent>