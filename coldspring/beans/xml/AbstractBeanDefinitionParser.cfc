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

<cfcomponent hint="Abstract class for bean definition parsing" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="parse" hint="virtual function: overwrite this function to add BeanDefinitions to the BeanFactory.
							   Returning a single BeanDefinition, an array of BeanDefinitions or none at all, will add whatever you return to the BeanFactory.
							   When a single BeanDefintion is returned, it is defined as the containing BeanDefintion for the next set of BeanDefinitions in the ParserContext.
							   <br/>It should be noted that ONLY parsers that return a single bean definition can be used as a inner bean in an XML schema.
							   Returning nothing, or an array when parsing will result in an error being thrown if it is used as an inner bean."
			access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
			<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("parse", this)>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
</cffunction>

</cfcomponent>