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

<cfcomponent hint="The definition parser for the <aop:remote> element" extends="coldspring.beans.xml.AbstractBeanDefinitionParser" output="false">

<cfscript>
	meta = getMetadata(this);

	if(!structKeyExists(meta, "const"))
	{
		const = {};

		const.REMOTE_FACTORY_BEAN_CLASS = "coldspring.aop.framework.RemoteFactoryBean";

		const.ID_ATTRIBUTE = "id";
		const.REF_ATTRIBUTE = "ref";
		const.NAME_ATTRIBUTE = "name";
		const.TARGET_REF_ATTRIBUTE = "target-ref";
		const.SERVICE_NAME_ATTRIBUTE = "service-name";
		const.RELATIVE_PATH_ATTRIBUTE = "relative-path";
		const.BEAN_FACTORY_NAME_ATTRIBUTE = "bean-factory-name";
		const.REMOTE_METHODS_ATTRIBUTE = "remote-methods";
		const.TRUSTED_SOURCE_ATTRIBUTE = "trusted-source";
		const.MISSING_METHODS_ATTRIBUTE = "missing-methods";
		const.INTERCEPTOR_REFS_ATTRIBUTE = "interceptor-refs";

		const.REMOTE_METHODS_ELEMENT  = "remote-methods";
		const.MISSING_METHODS_ELEMENT  = "missing-methods";
		const.METHOD_ELEMENT = "method";

		const.INTERCEPTORS_ELEMENT = "interceptors";
		const.INTERCEPTOR_ELEMENT = "interceptor";

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RemoteDefinitionParser" output="false">
	<cfscript>
		super.init();

		return this;
	</cfscript>
</cffunction>

<cffunction name="parse" hint="Parse <aop:remote> elements, and turn them in to RemoteFactoryBeans"
			access="public" returntype="any" output="false">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		//basic attributes
		var id = arguments.element.getAttribute(meta.const.ID_ATTRIBUTE);
		var beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id);
		var targetRef = createObject("component", "coldspring.beans.support.RefValue").init(arguments.element.getAttribute(meta.const.TARGET_REF_ATTRIBUTE), arguments.parserContext.getBeanFactory());
		//call it 'prop' since intelliJ has issues with the keyword 'property'
		var prop = createObject("component", "coldspring.beans.support.Property").init("target", targetRef);
		var value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.SERVICE_NAME_ATTRIBUTE));
		var node = arguments.parserContext.getDelegate().getNode();
		var childNodes = arguments.element.getChildNodes();
		var counter = 0;
		var child = 0;

		beanDef.setClassName(meta.const.REMOTE_FACTORY_BEAN_CLASS);
		beanDef.setLazyInit(false);

		//target property
		beanDef.addProperty(prop);

		//service name property
		prop = createObject("component", "coldspring.beans.support.Property").init("serviceName", value);
		beanDef.addProperty(prop);

		//relative-path
		value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.RELATIVE_PATH_ATTRIBUTE));
		prop = createObject("component", "coldspring.beans.support.Property").init("relativePath", value);
		beanDef.addProperty(prop);

		//bean-factory-name
		if(arguments.element.hasAttribute(meta.const.BEAN_FACTORY_NAME_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.BEAN_FACTORY_NAME_ATTRIBUTE));
			prop = createObject("component", "coldspring.beans.support.Property").init("beanFactoryName", value);
			beanDef.addProperty(prop);
		}

		//remote-methods
		if(arguments.element.hasAttribute(meta.const.REMOTE_METHODS_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.REMOTE_METHODS_ATTRIBUTE));
			prop = createObject("component", "coldspring.beans.support.Property").init("remoteMethodNames", value);
			beanDef.addProperty(prop);
		}

		//trusted-source
		if(arguments.element.hasAttribute(meta.const.TRUSTED_SOURCE_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.TRUSTED_SOURCE_ATTRIBUTE));
			prop = createObject("component", "coldspring.beans.support.Property").init("trustedSource", value);
			beanDef.addProperty(prop);
		}

		//missing-methods
		if(arguments.element.hasAttribute(meta.const.MISSING_METHODS_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.MISSING_METHODS_ATTRIBUTE));
			prop = createObject("component", "coldspring.beans.support.Property").init("addMissingMethods", value);
			beanDef.addProperty(prop);
		}

		//interceptor-refs
		if(arguments.element.hasAttribute(meta.const.INTERCEPTOR_REFS_ATTRIBUTE))
		{
			value = createObject("component", "coldspring.beans.support.SimpleValue").init(arguments.element.getAttribute(meta.const.INTERCEPTOR_REFS_ATTRIBUTE));
			prop = createObject("component", "coldspring.beans.support.Property").init("interceptorNames", value);
			beanDef.addProperty(prop);
		}

		for(;counter < childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);
			//@cfmlvariable name="child" type="org.w3c.dom.Element"

			if(child.getNodeType() eq node.ELEMENT_NODE)
			{
				if(child.getLocalName() eq meta.const.REMOTE_METHODS_ELEMENT)
				{
					parseRemoteMethods(beanDef, child, arguments.parserContext);
				}
				else if(child.getLocalName() eq meta.const.MISSING_METHODS_ELEMENT)
				{
					parseMissingMethods(beanDef, child, arguments.parserContext);
				}
				else if(child.getLocalName() eq meta.const.INTERCEPTORS_ELEMENT)
				{
					parseIntercepors(beanDef, child, arguments.parserContext);
				}
			}
		}

		return beanDef;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="parseRemoteMethods" hint="parse the remote element method elements" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to append remote methods to" type="coldspring.beans.support.BeanDefinition" required="true">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var node = arguments.parserContext.getDelegate().getNode();
		var childNodes = arguments.element.getChildNodes();
		var counter = 0;
		var child = 0;
		var list = createObject("component", "coldspring.beans.support.ListValue").init();
		var value = 0;
		var prop = 0;

		for(;counter < childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);

			if(child.getNodeType() eq node.ELEMENT_NODE and child.getLocalName() eq meta.const.METHOD_ELEMENT)
			{
				value = createObject("component", "coldspring.beans.support.SimpleValue").init(child.getAttribute(meta.const.NAME_ATTRIBUTE));
				list.addValue(value);
			}
		}

		if(!arrayIsEmpty(list.getValueArray()))
		{
			prop = createObject("component", "coldspring.beans.support.Property").init("remoteMethodNames", list);
			arguments.beanDefinition.addProperty(prop);
		}
	</cfscript>
</cffunction>

<cffunction name="parseMissingMethods" hint="parse the missing element method elements" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to append missing methods to" type="coldspring.beans.support.BeanDefinition" required="true">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var node = arguments.parserContext.getDelegate().getNode();
		var childNodes = arguments.element.getChildNodes();
		var counter = 0;
		var child = 0;
		var list = createObject("component", "coldspring.beans.support.ListValue").init();
		var value = 0;
		var prop = 0;

		for(;counter < childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);

			if(child.getNodeType() eq node.ELEMENT_NODE and child.getLocalName() eq meta.const.METHOD_ELEMENT)
			{
				value = createObject("component", "coldspring.beans.support.SimpleValue").init(child.getAttribute(meta.const.NAME_ATTRIBUTE));
				list.addValue(value);
			}
		}

		if(!arrayIsEmpty(list.getValueArray()))
		{
			prop = createObject("component", "coldspring.beans.support.Property").init("addMissingMethods", list);
			arguments.beanDefinition.addProperty(prop);
		}
	</cfscript>
</cffunction>

<cffunction name="parseIntercepors" hint="parse the interceptors element interceptor elements" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to append interceptors to" type="coldspring.beans.support.BeanDefinition" required="true">
	<cfargument name="element" hint="a instance of org.w3c.dom.Element that represent the XML Element" type="any" required="Yes">
	<cfargument name="parserContext" hint="the current parser context" type="coldspring.beans.xml.ParserContext" required="Yes">
	<cfscript>
		var node = arguments.parserContext.getDelegate().getNode();
		var childNodes = arguments.element.getChildNodes();
		var counter = 0;
		var child = 0;
		var list = createObject("component", "coldspring.beans.support.ListValue").init();
		var value = 0;
		var prop = 0;

		for(;counter < childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);

			if(child.getNodeType() eq node.ELEMENT_NODE and child.getLocalName() eq meta.const.INTERCEPTOR_ELEMENT)
			{
				value = createObject("component", "coldspring.beans.support.SimpleValue").init(child.getAttribute(meta.const.REF_ATTRIBUTE));
				list.addValue(value);
			}
		}

		if(!arrayIsEmpty(list.getValueArray()))
		{
			prop = createObject("component", "coldspring.beans.support.Property").init("interceptorNames", list);
			arguments.beanDefinition.addProperty(prop);
		}
	</cfscript>
</cffunction>

</cfcomponent>