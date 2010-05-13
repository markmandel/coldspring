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

<cfcomponent hint="Simple factory for shared Map instances. Allows for central setup of Maps via the 'map' element in XML bean definitions." implements="coldspring.beans.factory.FactoryBean" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MapFactoryBean" output="false">
	<cfscript>
		variables.instance = StructNew();

		setSourceMap(structNew());
		setSingleton(false);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="Returns the set up map/struct" access="public" returntype="any" output="false">
	<cfscript>
		var result = 0;

		//set up the initial value - does not need to be locked as CS does the locking for us.
		if(NOT hasResultMap())
		{
			if(NOT hasTargetMapClass())
			{
				setResultMap(getSourceMap());
			}
			else
			{
				setResultMap(createObject("java", getTargetMapClass()).init());
				getResultMap().putAll(getSourceMap());
			}
		}

		if(isSingleton())
		{
			result = getResultMap();
		}
		else
		{
			if(NOT hasTargetMapClass())
			{
				result = structCopy(getResultMap());
			}
			else
			{
				result = createObject("java", getTargetMapClass()).init();
				result.putAll(getResultMap());
			}
		}

		return result;
    </cfscript>
</cffunction>

<cffunction name="getObjectType" access="public" returntype="string" output="false" hint="returns ''">
	<cfreturn "" />
</cffunction>

<cffunction name="isSingleton" access="public" hint="Is this map a singleton? Defaults to false" returntype="boolean" output="false">
	<cfreturn instance.isSingleton />
</cffunction>

<cffunction name="setSingleton" access="public" returntype="void" output="false">
	<cfargument name="isSingleton" type="boolean" required="true">
	<cfset instance.isSingleton = arguments.isSingleton />
</cffunction>

<cffunction name="setSourceMap" access="public" returntype="void" output="false">
	<cfargument name="sourceMap" type="struct" required="true">
	<cfset instance.sourceMap = arguments.sourceMap>
</cffunction>

<cffunction name="setTargetMapClass" hint="The Java Map class to use for the Array. If not set, the default ColdFusion struct is used." access="public" returntype="void" output="false">
	<cfargument name="targetMapClass" type="string" required="true">
	<cfset instance.targetMapClass = arguments.targetMapClass />
</cffunction>

<cffunction name="getTargetMapClass" access="public" returntype="string" output="false">
	<cfreturn instance.targetMapClass />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSourceMap" access="private" returntype="struct" output="false">
	<cfreturn instance.sourceMap />
</cffunction>

<cffunction name="hasTargetMapClass" hint="whether this object has a targetMapClass" access="private" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "targetMapClass") />
</cffunction>

<cffunction name="getResultMap" access="private" returntype="struct" output="false">
	<cfreturn instance.resultMap />
</cffunction>

<cffunction name="setResultMap" access="private" returntype="void" output="false">
	<cfargument name="resultMap" type="struct" required="true">
	<cfset instance.resultMap = arguments.resultMap />
</cffunction>

<cffunction name="hasResultMap" hint="whether this object has a resultMap" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "resultMap") />
</cffunction>

</cfcomponent>