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

<cfcomponent implements="coldspring.beans.factory.FactoryBean" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ListFactoryBean" output="false">
	<cfscript>
		return this;

		setSourceList(ArrayNew(1));
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="Return an instance (possibly shared or independent) of the object managed by this factory." access="public" returntype="any" output="false">
	<cfscript>
		return getSourceList();
    </cfscript>
</cffunction>

<cffunction name="isSingleton" access="public" returntype="boolean" output="false" hint="Returns true">
	<cfreturn true />
</cffunction>

<cffunction name="getObjectType" access="public" returntype="string" output="false" hint="returns 'array'">
	<cfreturn "Array" />
</cffunction>

<cffunction name="setSourceList" hint="Set the source List, typically populated via XML 'list' elements." access="public" returntype="void" output="false">
	<cfargument name="sourceList" type="array" required="true">
	<cfset instance.sourceList = arguments.sourceList />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSourceList" access="private" returntype="array" output="false">
	<cfreturn instance.sourceList />
</cffunction>

</cfcomponent>