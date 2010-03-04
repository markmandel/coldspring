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

<cfcomponent output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="CircularReference1" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="getCircularReference2" access="public" returntype="CircularReference2" output="false">
	<cfreturn instance.CircularReference2 />
</cffunction>

<cffunction name="setCircularReference2" access="public" returntype="CircularReference2" output="false">
	<cfargument name="CircularReference2" type="any" required="true">
	<cfset instance.CircularReference2 = arguments.CircularReference2 />
</cffunction>

</cfcomponent>