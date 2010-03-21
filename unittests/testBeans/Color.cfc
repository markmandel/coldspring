
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

<cfcomponent hint="Simple Color Bean">

<cfset this.id = CreateUUId() />

<cffunction name="init" hint="Constructor" access="public" returntype="Color" output="false">
	<cfargument name="name" hint="the name of the colour" type="string" required="no" default="red">
	<cfscript>
		setName(arguments.name);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getName" access="public" returntype="string" output="false">
	<cfreturn instance.name />
</cffunction>

<cffunction name="setName" access="public" returntype="void" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset instance.name = arguments.name />
</cffunction>

</cfcomponent>