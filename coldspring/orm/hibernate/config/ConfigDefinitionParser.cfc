<!---
	Copyright 2012 Mark Mandel

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
<cfcomponent hint="Definition parser for the hibernate:config> element" implements="coldspring.beans.xml.BeanDefinitionParser" output="false">

<cfscript>
	meta = getMetadata(this);

	if(!structKeyExists(meta, "const"))
	{
		const = {};

		const.SESSION_WRAPPER_CLASS = "coldspring.orm.hibernate.SessionWrapper";
		const.AUTOWIRE_BEANINJECTOR_CLASS = "coldspring.beans.wiring.AutowireByNameBeanInjector";
		const.SCOPE_BEAN_FACTORY_LOCATOR_CLASS = "coldspring.beans.factory.access.ScopeBeanFactoryLocator";

		const.ID_ATTRIBUTE = "id";
		const.STRICT_TRANSACTION_ATTRIBUTE = "strictTransaction";
		const.FLUSH_MODE_ATTRIBUTE = "flushmode";
		const.AUTOWIRE_ATTRIBUTE = "autowire";
		const.FACTORY_NAME_ATTRIBUTE = "factory-name";

		const.BEAN_INJECTOR_ID = "hibernate-beanInjector";

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ConfigDefinitionParser" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="parse" hint="Set up configuration of the <hibernate:config> item" access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var beanDefs = [];

		var sessionWrapperDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(arguments.element.getAttribute(meta.const.ID_ATTRIBUTE));
		var injectorDef = 0;
		var constructorArg = 0;
		var value = 0;
		var autowire = "none";
		var list = 0;
		var registry = arguments.parserContext.getBeanDefinitionRegistry();
		var locatorDef = 0;
		var prop = 0;

		sessionWrapperDef.setClassName(meta.const.SESSION_WRAPPER_CLASS);
		arrayAppend(beanDefs, sessionWrapperDef);

		if(arguments.element.hasAttribute(meta.const.STRICT_TRANSACTION_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.STRICT_TRANSACTION_ATTRIBUTE));
			constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("strictTransactions", value);
			sessionWrapperDef.addConstructorArg(constructorArg);
		}

		if(arguments.element.hasAttribute(meta.const.FLUSH_MODE_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.FLUSH_MODE_ATTRIBUTE));
			constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("defaultFlushMode", value);
			sessionWrapperDef.addConstructorArg(constructorArg);
		}
		
		if(arguments.element.hasAttribute(meta.const.AUTOWIRE_ATTRIBUTE))
		{
			autowire = arguments.element.getAttribute(meta.const.AUTOWIRE_ATTRIBUTE);
		}

		if(autowire != "none")
		{
			//right now, by name is the only other option.
			injectorDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(meta.const.BEAN_INJECTOR_ID);
			injectorDef.setClassName(meta.const.AUTOWIRE_BEANINJECTOR_CLASS);

			arrayAppend(beanDefs, injectorDef);

			//we only care about this bean factory.
			list = registry.getBeanNamesForType(meta.const.AUTOWIRE_BEANINJECTOR_CLASS);

			//only do it if there isn't one already.
			if(arrayIsEmpty(list))
			{
				locatorDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("scopeBeanFactoryLocator-" & createUUID());
				locatorDef.setClassName(meta.const.SCOPE_BEAN_FACTORY_LOCATOR_CLASS);
				arrayAppend(beanDefs, locatorDef);

				if(arguments.element.hasAttribute(meta.const.FACTORY_NAME_ATTRIBUTE))
				{
					value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.FACTORY_NAME_ATTRIBUTE));
					prop = createObject("component", "coldspring.beans.support.Property").init("beanFactoryName", value);
					locatorDef.addProperty(prop);
				}
			}
		}

		if(autowire != "none" || registry.containsBeanDefinition(meta.const.BEAN_INJECTOR_ID));
		{
			//add in bean injector.
			value = createObject("component", "coldspring.beans.support.RefValue").init(meta.const.BEAN_INJECTOR_ID, arguments.parserContext.getBeanFactory());
			constructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("beanInjector", value);
			sessionWrapperDef.addConstructorArg(constructorArg);
		}

		return beanDefs;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>