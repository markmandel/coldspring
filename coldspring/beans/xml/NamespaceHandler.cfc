<!---
   Copyright 2011 Mark Mandel
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

<cfinterface hint="Interface for xml namespace handling">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getBeanDefinitionParser" hint="get the bean definition parser for a given element" access="public" returntype="BeanDefinitionParser" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element for which you need a parser" type="any" required="Yes">
</cffunction>

<cffunction name="hasBeanDefinitionParser" hint="do we have a DefintiionParser for this element?" access="public" returntype="boolean" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element for which you need a parser" type="any" required="Yes">
</cffunction>

<cffunction name="getSchemaLocations" hint="Overwite this function to give ColdSpring a map of remote Schemas to their local absolute paths"
			access="public" returntype="struct" output="false"
			colddoc:generic="string,string">
</cffunction>

<cffunction name="getNameSpaces" hint="abstract function: overwrite to return a single, list or array of string values that are the namespaces this handler manages the parsing for" access="public" returntype="any" output="false">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>