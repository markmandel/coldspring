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

<cfcomponent hint="abstract class to help doing util bean parsing" extends="coldspring.beans.xml.AbstractBeanDefinitionParser" output="false" colddoc:abstract="true">

<cfscript>
	instance.static.ID_ATTRIBUTE = "id";
	instance.static.SCOPE_ATTRIBUTE = "scope";
	instance.static.SINGLETON_SCOPE = "singleton";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfscript>
		super.init();
	</cfscript>
</cffunction>

<cffunction name="parse" hint="Do generic parsing, and return the basic BeanDefinition to be used for the util collections" access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var id = arguments.element.getAttribute(instance.static.ID_ATTRIBUTE);
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id);

		//set the singleton to true, if it's a singleton
		if(NOT arguments.element.hasAttribute(instance.static.SCOPE_ATTRIBUTE)
			OR arguments.element.getAttribute(instance.static.SCOPE_ATTRIBUTE) eq instance.static.SINGLETON_SCOPE)
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(true);
			property = createObject("component", "coldspring.beans.support.Property").init("singleton", value);
			beanDef.addProperty(property);
		}

		return beanDef;
    </cfscript>
</cffunction>

</cfcomponent>