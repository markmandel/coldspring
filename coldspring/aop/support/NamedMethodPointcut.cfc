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

<cfcomponent implements="coldspring.aop.Pointcut" output="false">

<cfscript>
	meta = getMetadata(this);

	if(!structKeyExists(meta, "const"))
	{
		meta.const.WILDCARD = "*";
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="NamedMethodPointcut" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Does given method, for the given class, match for this pointcut" access="public" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		var methodName = 0;
    </cfscript>
	<cfloop array="#getMappedNames()#" index="methodName">
		<cfscript>
			if(arguments.method.getName() == methodname || methodName == meta.const.WILDCARD)
			{
				return true;
			}
        </cfscript>
	</cfloop>
	<cfreturn false />
</cffunction>

<cffunction name="setMappedName" hint="Convenience method when we have only a single method name to match. Use either this method or setMappedNames, not both." access="public" returntype="void" output="false">
	<cfargument name="name" hint="the mapping name" type="string" required="Yes">
	<cfscript>
		var names = [arguments.name];
		setMappedNames(names);
    </cfscript>
</cffunction>

<cffunction name="setMappedNames" hint="List, or array of mapped names" access="public" returntype="void" output="false">
	<cfargument name="mappedNames" type="any" required="true">
	<cfscript>
		if(isSimpleValue(arguments.mappedNames))
		{
			arguments.mappedNames = listToArray(arguments.mappedNames);
		}
    </cfscript>

	<cfset instance.mappedNames = arguments.mappedNames />
</cffunction>

<cffunction name="getMappedNames" access="public" returntype="array" output="false"
	colddoc:generic="string">
	<cfreturn instance.mappedNames />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>