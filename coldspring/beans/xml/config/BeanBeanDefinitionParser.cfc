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

<cfcomponent hint="The definition parser for the <bean> element" extends="coldspring.beans.xml.AbstractBeanDefinitionParser" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	instance.static.FACTORY_BEAN_REGISTRY_POST_PROCESSOR_CLASS = "coldspring.beans.xml.config.FactoryBeanRegistryPostProcessor";
</cfscript>


<cffunction name="init" hint="Constructor" access="public" returntype="BeanBeanDefinitionParser" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="parse" hint="return a CFCBeanDefinition for <bean>" access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var beanDef = arguments.parserContext.getDelegate().parseBeanDefinitionElement(arguments.element);

		registerFactoryBeanRegsitryPostProcessor(arguments.parserContext.getBeanDefinitionRegistry());

		return beanDef;
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="registerFactoryBeanRegsitryPostProcessor" hint="ensure the factory bean post processor is registered" access="private" returntype="void" output="false">
	<cfargument name="registry" type="coldspring.beans.BeanDefinitionRegistry" required="yes" />
	<cfscript>
		var beanDef = 0;

		if(NOT arguments.registry.containsBeanDefinition(instance.static.FACTORY_BEAN_REGISTRY_POST_PROCESSOR_CLASS))
		{
			beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(instance.static.FACTORY_BEAN_REGISTRY_POST_PROCESSOR_CLASS, arguments.registry);

			beanDef.setClassName(instance.static.FACTORY_BEAN_REGISTRY_POST_PROCESSOR_CLASS);

			arguments.registry.registerBeanDefinition(beanDef);
		}
    </cfscript>
</cffunction>

</cfcomponent>