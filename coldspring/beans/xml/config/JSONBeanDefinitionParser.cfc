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

<cfcomponent hint="The definition parser for util:json element" extends="coldspring.beans.xml.AbstractBeanDefinitionParser" output="false">

<cfscript>
	instance.static = {};

	instance.static.ID_ATTRIBUTE = "id";
	instance.static.SCOPE_ATTRIBUTE = "scope";

	instance.static.JSON_FACTORY_BEAN_CLASS = "coldspring.beans.factory.config.JSONFactoryBean";
</cfscript>


<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="JSONBeanDefinitionParser" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="parse" hint="return a CFCBeanDefinition for <json>" access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var id = arguments.element.getAttribute(instance.static.ID_ATTRIBUTE);
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id);
		var value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getTextContent());
		var property = createObject("component", "coldspring.beans.support.Property").init("sourceJSON", value);

		beanDef.setClassName(instance.static.JSON_FACTORY_BEAN_CLASS);
		beanDef.addProperty(property);

		if(arguments.element.hasAttribute(instance.static.SCOPE_ATTRIBUTE))
		{
			beanDef.setScope(arguments.element.getAttribute(instance.static.SCOPE_ATTRIBUTE));
		}

		return beanDef;
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>