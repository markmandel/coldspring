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
		setSingleton(false);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="Returns the deserialised JSON" access="public" returntype="any" output="false">
	<cfscript>
		if(isSingleton())
		{
			return getSourceJSON();
		}

		return duplicate(getSourceJSON());
    </cfscript>
</cffunction>

<cffunction name="isSingleton" access="public" hint="Is this data structure is singleton? Defaults to false" returntype="boolean" output="false">
	<cfreturn instance.isSingleton />
</cffunction>

<cffunction name="setSingleton" access="public" returntype="void" output="false">
	<cfargument name="isSingleton" type="boolean" required="true">
	<cfset instance.isSingleton = arguments.isSingleton />
</cffunction>

<cffunction name="getObjectType" access="public" returntype="string" output="false" hint="returns ''">
	<cfreturn "" />
</cffunction>

<cffunction name="setSourceJSON" hint="The JSON to be deserialised" access="public" returntype="void" output="false">
	<cfargument name="sourceJSON" type="string" required="true">
	<cfset instance.sourceJSON = deserializeJSON(arguments.sourceJSON) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSourceJSON" access="private" hint="The deserialised JSON" returntype="any" output="false">
	<cfreturn instance.sourceJSON />
</cffunction>

</cfcomponent>