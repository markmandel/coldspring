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

<cfcomponent hint="abstract base class for Namespace handling" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getBeanDefinitionParser" hint="get the bean definition parser for a given element" access="public" returntype="AbstractBeanDefinitionParser" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element for which you need a parser" type="any" required="Yes">
	<cfscript>
		if(structKeyExists(getDefinitionParsers(), arguments.element.getLocalName()))
		{
			return structFind(getDefinitionParsers(), arguments.element.getLocalName());
		}

		//if not found, throw an exception
		createObject("component", "coldspring.beans.xml.exception.BeanDefinitionParserNotFoundException").init(arguments.element.getNamespaceURI(), arguments.element.getLocalName());
    </cfscript>
</cffunction>

<cffunction name="hasBeanDefinitionParser" hint="do we have a DefintiionParser for this element?" access="public" returntype="boolean" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element for which you need a parser" type="any" required="Yes">
	<cfscript>
		return structKeyExists(getDefinitionParsers(), arguments.element.getLocalName());
    </cfscript>
</cffunction>

<cffunction name="getSchemaLocations" hint="abstract function: overwite this function to give ColdSpring a map of remote Schemas to their local absolute paths"
			access="public" returntype="struct" output="false"
			colddoc:generic="string,string">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("getSchemaLocations", this)>
</cffunction>

<cffunction name="getNameSpaces" hint="abstract function: overwrite to return a single, list or array of string values that are the namespaces this handler manages the parsing for" access="public" returntype="any" output="false">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("getNameSpaces", this)>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfscript>
		setDefinitionParsers(StructNew());
	</cfscript>
</cffunction>

<cffunction name="registerBeanDefinitionParser" hint="registers a Definition parser for given XML element name" access="private" returntype="void" output="false">
	<cfargument name="elementName" hint="the name of the element to parse" type="string" required="Yes">
	<cfargument name="definitionParser" hint="The Definition parser" type="AbstractBeanDefinitionParser" required="Yes">
	<cfscript>
		structInsert(getDefinitionParsers(), arguments.elementName, arguments.definitionParser, true);
    </cfscript>
</cffunction>

<cffunction name="getDefinitionParsers" access="private" returntype="struct" output="false"
			colddoc:generic="string,AbstractBeanDefinitionParser">
	<cfreturn instance.DefinitionParsers />
</cffunction>

<cffunction name="setDefinitionParsers" access="private" returntype="void" output="false">
	<cfargument name="DefinitionParsers" type="struct" required="true" colddoc:generic="string,AbstractBeanDefinitionParser">
	<cfset instance.DefinitionParsers = arguments.DefinitionParsers />
</cffunction>

</cfcomponent>