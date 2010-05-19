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

<cfcomponent hint="The definition parser for util:list element" extends="AbstractUtilBeanDefinitionParser" output="false">

<cfscript>
	instance.static.LIST_FACTORY_BEAN_CLASS = "coldspring.beans.factory.config.ListFactoryBean";
	instaince.static.LIST_CLASS_ATTRIBUTE = "list-class";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ListBeanDefinitionParser" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="parse" hint="return a CFCBeanDefinition for <list>" access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var beanDef = super.parse(argumentCollection=arguments);
		var value = arguments.parserContext.getDelegate().parseListElement(arguments.element, beanDef);
		var property = createObject("component", "coldspring.beans.support.Property").init("sourceList", value);

		beanDef.setClassName(instance.static.LIST_FACTORY_BEAN_CLASS);
		beanDef.addProperty(property);

		//manage the target class
		if(arguments.element.hasAttribute(instaince.static.LIST_CLASS_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(instaince.static.LIST_CLASS_ATTRIBUTE));
			property = createObject("component", "coldspring.beans.support.Property").init("targetListClass", value);
			beanDef.addProperty(property);
		}

		return beanDef;
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>