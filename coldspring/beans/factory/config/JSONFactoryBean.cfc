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

<cfcomponent hint="Simple factory for creating data via a JSON string, and sharing it." implements="coldspring.beans.factory.FactoryBean" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="JSONFactoryBean" output="false">
	<cfscript>
		setSourceJSON("");
		return this;
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="Returns the deserialised JSON" access="public" returntype="any" output="false">
	<cfreturn deserializeJSON(getSourceJSON()) />
</cffunction>

<cffunction name="isSingleton" access="public" returntype="boolean" output="false" hint="returns true">
	<cfreturn true />
</cffunction>

<cffunction name="getObjectType" access="public" returntype="string" output="false" hint="returns ''">
	<cfreturn "" />
</cffunction>

<cffunction name="setSourceJSON" hint="The JSON to be deserialised" access="public" returntype="void" output="false">
	<cfargument name="sourceJSON" type="string" required="true">
	<cfset instance.sourceJSON = arguments.sourceJSON />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSourceJSON" access="private" returntype="string" output="false">
	<cfreturn instance.sourceJSON />
</cffunction>

</cfcomponent>