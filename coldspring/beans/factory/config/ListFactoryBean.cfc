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

<cfcomponent implements="coldspring.beans.factory.FactoryBean" hint="Simple factory for shared List instances. Allows for central setup of Lists via the 'list' element in XML bean definitions. " output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ListFactoryBean" output="false">
	<cfscript>
		variables.instance = {};

		setSourceList(ArrayNew(1));
		setSingleton(false);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="Returns the set up array" access="public" returntype="any" output="false">
	<cfscript>
		var result = 0;

		//set up the initial value - does not need to be locked as CS does the locking for us.
		if(NOT hasResultList())
		{
			if(NOT hasTargetListClass())
			{
				setResultList(getSourceList());
			}
			else
			{
				setResultList(createObject("java", getTargetListClass()).init());
				getResultList().addAll(getSourceList());
			}
		}

		if(isSingleton())
		{
			/*
			return here in an attempt to keep the same reference
			if it's a native CF array
			*/
			return getResultList();
		}
		else
		{
			if(NOT hasTargetListClass())
			{
				result = [];
			}
			else
			{
				result = createObject("java", getTargetListClass()).init();
			}

			result.addAll(getSourceList());
		}

		return result;
    </cfscript>
</cffunction>

<cffunction name="getObjectType" access="public" returntype="string" output="false" hint="returns ''">
	<cfreturn "" />
</cffunction>

<cffunction name="isSingleton" access="public" hint="Is this list a singleton? Defaults to false" returntype="boolean" output="false">
	<cfreturn instance.isSingleton />
</cffunction>

<cffunction name="setSingleton" access="public" returntype="void" output="false">
	<cfargument name="isSingleton" type="boolean" required="true">
	<cfset instance.isSingleton = arguments.isSingleton />
</cffunction>

<cffunction name="setSourceList" hint="Set the source List, typically populated via XML 'list' elements." access="public" returntype="void" output="false">
	<cfargument name="sourceList" type="array" required="true">
	<cfscript>
		instance.sourceList = arguments.sourceList;
    </cfscript>
</cffunction>

<cffunction name="setTargetListClass" hint="The Java List class to use for the Array. If not set, the default ColdFusion array is used." access="public" returntype="void" output="false">
	<cfargument name="targetListClass" type="string" required="true">
	<cfset instance.targetListClass = arguments.targetListClass />
</cffunction>

<cffunction name="getTargetListClass" access="public" returntype="string" output="false">
	<cfreturn instance.targetListClass />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getSourceList" access="private" returntype="array" output="false">
	<cfreturn instance.sourceList />
</cffunction>

<cffunction name="hasTargetListClass" hint="whether this object has a targetListClass" access="private" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "targetListClass") />
</cffunction>

<cffunction name="getResultList" access="private" returntype="array" output="false">
	<cfreturn instance.resultList />
</cffunction>

<cffunction name="setResultList" access="private" returntype="void" output="false">
	<cfargument name="resultList" type="array" required="true">
	<cfset instance.resultList = arguments.resultList />
</cffunction>

<cffunction name="hasResultList" hint="whether this object has a resultList" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "resultList") />
</cffunction>

</cfcomponent>