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

<cfcomponent hint="String resolver for Dynamic Properties" implements="coldspring.util.StringValueResolver" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="PropertyStringResolver" output="false">
	<cfargument name="dynamicProperties" hint="A struct of key value pairs, for which the keys will be used to translate '${key}' string values in BeanDefinitions properties into their corresponding values."
				type="struct" required="yes">
	<cfscript>
		//build a regex for checking on property values.
		var regex = "\$\{(";
		regex &= structKeyList(arguments.dynamicProperties, "|");
		regex &= ")}";

		setPropertyRegex(regex);

		setDynamicProperties(arguments.dynamicProperties);

		resolveRecursiveProperties();

		return this;
	</cfscript>
</cffunction>

<cffunction name="resolveStringValue" hint="Resolves ${key} into it's given property. Supports recursive ${key} translation" access="public" returntype="any" output="false">
	<cfargument name="string" type="string" required="yes" />
	<cfscript>
		var results = reMatchNoCase(getPropertyRegex(), arguments.string);

		return replacePropertyValues(results, arguments.string);
    </cfscript>
</cffunction>

<cffunction name="getDynamicProperties" access="public" returntype="struct" output="false">
	<cfreturn instance.dynamicProperties />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setDynamicProperties" access="private" returntype="void" output="false">
	<cfargument name="dynamicProperties" type="struct" required="true">
	<cfset instance.dynamicProperties = arguments.dynamicProperties />
</cffunction>

<cffunction name="resolveRecursiveProperties" hint="goes through the current dynamic properties, and resolves any recursiveness" access="private" returntype="void" output="false">
	<cfscript>
		var matchFound = true;
		var key = 0;
		var value = 0;
		var results = 0;
		var properties = getDynamicProperties();

		while(matchFound)
		{
			matchFound = false;
			for(key in properties)
			{
				value = properties[key];

				//make sure it's only for simple values, in case we get extra stuff from frameworks
				if(isSimpleValue(value))
				{
					results = reMatchNoCase(getPropertyRegex(), value);

					if(!arrayIsEmpty(results))
					{
						matchFound = true;
						properties[key] = replacePropertyValues(results, value);
					}
				}
			}
		}
    </cfscript>
</cffunction>

<cffunction name="replacePropertyValues" hint="Given the set of properties being passed through, the value string has it's ${key}'s' replaced"
	access="private" returntype="string" output="false">
	<cfargument name="propertyStrings" hint="an array of property strings as ${key}" type="array" required="Yes">
	<cfargument name="value" hint="the string value to replace the values in" type="string" required="Yes">
	<cfscript>
		var property = 0;
		var properties = getDynamicProperties();
		var key = 0;
    </cfscript>
	<cfloop array="#arguments.propertyStrings#" index="property">
		<cfscript>
			//strip ${}
			key = mid(property, 3, Len(property) - 3);

			if(structKeyExists(properties, key))
			{
				arguments.value = replaceNoCase(arguments.value, property, properties[key], "all");
			}
        </cfscript>
	</cfloop>
	<cfreturn arguments.value />
</cffunction>

<cffunction name="getPropertyRegex" access="private" returntype="string" output="false">
	<cfreturn instance.propertyRegex />
</cffunction>

<cffunction name="setPropertyRegex" access="private" returntype="void" output="false">
	<cfargument name="propertyRegex" type="string" required="true">
	<cfset instance.propertyRegex = arguments.propertyRegex />
</cffunction>

</cfcomponent>