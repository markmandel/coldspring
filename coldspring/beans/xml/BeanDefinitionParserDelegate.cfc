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

<cfcomponent hint="Delegate for common XML Bean parsing tasks" output="false">

<cfscript>
	instance.static = {};

	instance.static.BEANS_NAMESPACE_URI = "http://www.coldspringframework.org/schema/beans";

	instance.static.DEFAULT_AUTOWIRE_ATTRIBUTE = "default-autowire";
	instance.static.DEFAULT_LAZY_INIT_ATTRIBUTE = "default-lazy-init";

	instance.static.BEAN_ELEMENT = "bean";
	instance.static.CONSTRUCTOR_ARG_ELEMENT = "constructor-arg";
	instance.static.PROPERTY_ELEMENT = "property";
	instance.static.REF_ELEMENT = "ref";
	instance.static.VALUE_ELEMENT = "value";
	instance.static.LIST_ELEMENT = "list";
	instance.static.MAP_ELEMENT = "map";
	instance.static.META_ELEMENT = "meta";

	instance.static.ID_ATTRIBUTE = "id";
	instance.static.CLASS_ATTRIBUTE = "class";
	instance.static.SCOPE_ATTRIBUTE = "scope";
	instance.static.AUTOWIRE_ATTRIBUTE = "autowire";
	instance.static.NAME_ATTRIBUTE = "name";
	instance.static.REF_ATTRIBUTE = "ref";
	instance.static.VALUE_ATTRIBUTE = "value";
	instance.static.BEAN_ATTRIBUTE = "bean";
	instance.static.KEY_ATTRIBUTE = "key";
	instance.static.KEY_REF_ATTRIBUTE = "key-ref";
	instance.static.VALUE_REF_ATTRIBUTE = "value-ref";
	instance.static.ABSTRACT_ATTRIBUTE = "abstract";
	instance.static.FACTORY_METHOD_ATTRIBUTE = "factory-method";
	instance.static.FACTORY_BEAN_ATTRIBUTE = "factory-bean";
	instance.static.INIT_METHOD_ATTRIBUTE = "init-method";
	instance.static.LAZY_INIT_ATTRIBUTE = "lazy-init";
	instance.static.PARENT_ATTRIBUTE = "parent";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanDefinitionParserDelegate" output="false">
	<cfargument name="beanDefinitionRegistry" hint="The bean definition registry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfargument name="readerContext" hint="the current XML file reader context" type="ReaderContext" required="Yes">
	<cfscript>
		setReaderContext(arguments.readerContext);
		initDefaultValues(getReaderContext().getDocument().getDocumentElement());
		setBeanDefinitionRegistry(arguments.beanDefinitionRegistry);
		setNode(createObject("java", "org.w3c.dom.Node"));

		return this;
	</cfscript>
</cffunction>

<cffunction name="getAutowireMode" hint="returns the overall autowire mode, factoring in the default value" access="public" returntype="string" output="false">
	<cfargument name="autowire" hint="the auto wire mode currently set on the bean defintiion" type="string" required="Yes">
	<cfscript>
		if(arguments.autowire eq "default")
		{
			return getDefaultAutorwireMode();
		}

		return arguments.autowire;
    </cfscript>
</cffunction>

<cffunction name="getLazyInitMode" hint="returns the overall lazy init mode, factoring in the default value" access="public" returntype="string" output="false">
	<cfargument name="lazyInit" hint="the lazy init value set on the bean definition" type="string" required="Yes">
	<cfscript>
		if(arguments.lazyInit eq "default")
		{
			return getDefaultLazyInit();
		}

		return arguments.lazyInit;
    </cfscript>
</cffunction>

<cffunction name="parseBeanDefinitionElement" hint="parse a <bean> element and returns a bean definition" access="public" returntype="coldspring.beans.support.AbstractBeanDefinition" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that we are looking for sub elements" type="any" required="Yes">
	<cfscript>
		var id = 0;
		var class = 0;
		var beanDef = 0;

		if(arguments.element.hasAttribute(instance.static.ID_ATTRIBUTE))
		{
			id = arguments.element.getAttribute(instance.static.ID_ATTRIBUTE);
		}
		else
		{
			id = createUUID();
		}

		beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id);

		if(arguments.element.hasAttribute(instance.static.CLASS_ATTRIBUTE))
		{
			beanDef.setClassName(arguments.element.getAttribute(instance.static.CLASS_ATTRIBUTE));
		}

		if(arguments.element.hasAttribute(instance.static.FACTORY_BEAN_ATTRIBUTE))
		{
			beanDef.setFactoryBeanName(arguments.element.getAttribute(instance.static.FACTORY_BEAN_ATTRIBUTE));
		}

		if(arguments.element.hasAttribute(instance.static.FACTORY_METHOD_ATTRIBUTE))
		{
			beanDef.setFactoryMethodName(arguments.element.getAttribute(instance.static.FACTORY_METHOD_ATTRIBUTE));
		}

		if(arguments.element.hasAttribute(instance.static.INIT_METHOD_ATTRIBUTE))
		{
			beanDef.setInitMethod(arguments.element.getAttribute(instance.static.INIT_METHOD_ATTRIBUTE));
		}

		if(arguments.element.hasAttribute(instance.static.SCOPE_ATTRIBUTE))
		{
			beanDef.setScope(arguments.element.getAttribute(instance.static.SCOPE_ATTRIBUTE));
		}

		//set autowire
		beanDef.setAutowire(getAutowireMode(arguments.element.getAttribute(instance.static.AUTOWIRE_ATTRIBUTE)));

		beanDef.setLazyInit(getLazyInitMode(arguments.element.getAttribute(instance.static.LAZY_INIT_ATTRIBUTE)));

		//add constructor args
		parseConstructorArgElements(arguments.element, beanDef);

		//add property args
		parsePropertyElements(arguments.element, beanDef);

		//abstract
		if(arguments.element.hasAttribute(instance.static.ABSTRACT_ATTRIBUTE))
		{
			beanDef.setAbstract(arguments.element.getAttribute(instance.static.ABSTRACT_ATTRIBUTE));
		}

		//parent
		if(arguments.element.hasAttribute(instance.static.PARENT_ATTRIBUTE))
		{
			beanDef.setParentName(arguments.element.getAttribute(instance.static.PARENT_ATTRIBUTE));
		}

		//meta elements
		parseMetaElements(arguments.element, beanDef);

		return beanDef;
    </cfscript>
</cffunction>

<cffunction name="parseBeanDefinitionAliases" hint="parses common aliases from a <bean> implementation" access="public" returntype="array" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that we are looking for sub elements" type="any" required="Yes">
	<cfscript>
		var aliases = 0;
		if(arguments.element.hasAttribute(instance.static.NAME_ATTRIBUTE))
		{
			aliases = arguments.element.getAttribute(instance.static.NAME_ATTRIBUTE).split("[ ,;]+");

			//coldfusion manages lists a little better
			return createObject("java", "java.util.Arrays").asList(aliases);
		}

		return createObject("java", "java.util.ArrayList").init();
    </cfscript>
</cffunction>

<cffunction name="parseConstructorArgElements" hint="parse all constructor arg sub-elements on a given element" access="public" returntype="void" output="false">
	<cfargument name="beanElement" hint="the org.w3c.dom.Element that we are looking for sub elements" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the bean def to add the constructor args to" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var constructorArgs = arguments.beanElement.getElementsByTagName(instance.static.CONSTRUCTOR_ARG_ELEMENT);
		var counter = 0;

		for(; counter lt constructorArgs.getLength(); counter++)
		{
			parseConstructorArgElement(constructorArgs.item(counter), arguments.beanDefinition);
		}
    </cfscript>
</cffunction>

<cffunction name="parseConstructorArgElement" hint="parses a single constructor-arg element" access="public" returntype="void" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is the constructor arg" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the bean def to add the constructor arg to" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		local.name = arguments.element.getAttribute(instance.static.NAME_ATTRIBUTE);

		local.value = parsePropertySubElements(arguments.element, arguments.beanDefinition);

		//maybe we don't find something relevent
		if(structKeyExists(local, "value"))
		{
			local.contructorArg = createObject("component", "coldspring.beans.support.ConstructorArg").init(local.name, local.value);

			//add meta if it exists
			parseMetaElements(arguments.element, local.contructorArg);

			arguments.beanDefinition.addConstructorArg(local.contructorArg);
		}
    </cfscript>
</cffunction>

<cffunction name="parsePropertyElements" hint="parse all property sub-elements on a given element" access="public" returntype="void" output="false">
	<cfargument name="beanElement" hint="the org.w3c.dom.Element that we are looking for sub elements" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the bean def to add the properties to" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var properties = arguments.beanElement.getElementsByTagName(instance.static.PROPERTY_ELEMENT);
		var counter = 0;

		for(; counter lt properties.getLength(); counter++)
		{
			parsePropertyElement(properties.item(counter), arguments.beanDefinition);
		}
    </cfscript>
</cffunction>

<cffunction name="parsePropertyElement" hint="parses a single property element" access="public" returntype="void" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is the property" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the bean def to add the property to" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		local.name = arguments.element.getAttribute(instance.static.NAME_ATTRIBUTE);

		local.value = parsePropertySubElements(arguments.element, arguments.beanDefinition);

		//maybe we don't find something relevent
		if(structKeyExists(local, "value"))
		{
			local.property = createObject("component", "coldspring.beans.support.Property").init(local.name, local.value);

			//add meta if it exists
			parseMetaElements(arguments.element, local.property);

			arguments.beanDefinition.addProperty(local.property);
		}
    </cfscript>
</cffunction>

<cffunction name="parseListElement" hint="parses a list element" access="public" returntype="coldspring.beans.support.ListValue" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is the list element" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the containing bean definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var childNodes = arguments.element.getChildNodes();
		var counter = 0;
		var value = 0;
		var child = 0;
		var local = {};
		var listValue = createObject("component", "coldspring.beans.support.ListValue").init();

		for(;counter lt childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);

			if(child.getNodeType() eq getNode().ELEMENT_NODE)
			{
				local.value = parsePropertySubElement(child, arguments.beanDefinition);

				if(structKeyExists(local, "value"))
				{
					listValue.addValue(local.value);
				}
			}
		}

		return listValue;
    </cfscript>
</cffunction>

<cffunction name="parseMapElement" hint="parses a Map element" access="public" returntype="coldspring.beans.support.MapValue" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is the list element" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the containing bean definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var local = {};
		var mapValue = createObject("component", "coldspring.beans.support.MapValue").init();

		local.childNodes = arguments.element.getChildNodes();

		for(local.counter = 0; local.counter lt local.childNodes.getLength(); local.counter++)
		{
			local.child = local.childNodes.item(local.counter);

			if(local.child.getNodeType() eq getNode().ELEMENT_NODE)
			{
				//work out key
				if(local.child.hasAttribute(instance.static.KEY_ATTRIBUTE))
				{
					local.key = createObject("component", "coldspring.beans.support.SimpleValue").init(local.child.getAttribute(instance.static.KEY_ATTRIBUTE));
				}
				else if(local.child.hasAttribute(instance.static.KEY_REF_ATTRIBUTE))
				{
					local.beanName = local.child.getAttribute(instance.static.KEY_REF_ATTRIBUTE);
					local.key = createObject("component", "coldspring.beans.support.RefValue").init(local.beanName, getBeanDefinitionRegistry());
				}

				//work out value
				if(local.child.hasAttribute(instance.static.VALUE_ATTRIBUTE))
				{
					local.value = createObject("component", "coldspring.beans.support.SimpleValue").init(local.child.getAttribute(instance.static.VALUE_ATTRIBUTE));
				}
				else if(local.child.hasAttribute(instance.static.VALUE_REF_ATTRIBUTE))
				{
					local.beanName = local.child.getAttribute(instance.static.VALUE_REF_ATTRIBUTE);
					local.value = createObject("component", "coldspring.beans.support.RefValue").init(local.beanName, getBeanDefinitionRegistry());
				}
				else
				{
					local.value = parsePropertySubElements(local.child, arguments.beanDefinition);
				}

				if(structKeyExists(local, "key") AND structKeyExists(local, "value"))
				{
					mapValue.addValue(local.key, local.value);
				}
			}
		}

		return mapValue;
    </cfscript>
</cffunction>

<cffunction name="parsePropertySubElements" hint="parses property or constructor-arg for common sub elements of such as ref, bean, map etc and returns a AbstractValue is it find something" access="public" returntype="any" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is the parent element" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the containing bean definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.element.hasAttribute(instance.static.REF_ATTRIBUTE))
		{
			local.beanName = arguments.element.getAttribute(instance.static.REF_ATTRIBUTE);
			return createObject("component", "coldspring.beans.support.RefValue").init(local.beanName, getBeanDefinitionRegistry());
		}
		else if(arguments.element.hasAttribute(instance.static.VALUE_ATTRIBUTE))
		{
			local.simpleValue = arguments.element.getAttribute(instance.static.VALUE_ATTRIBUTE);
			return createObject("component", "coldspring.beans.support.SimpleValue").init(local.simpleValue);
		}
		else
		{
			local.childNodes = arguments.element.getChildNodes();

			for(local.counter = 0; local.counter lt local.childNodes.getLength(); local.counter++)
			{
				local.element = local.childNodes.item(local.counter);

				if(local.element.getNodeType() eq getNode().ELEMENT_NODE)
				{
					local.value = parsePropertySubElement(local.element, arguments.beanDefinition);

					//could be a Meta or Description element, which is ignored
					if(structKeyExists(local, "value"))
					{
						return local.value;
					}
				}
			}
		}
    </cfscript>
</cffunction>

<cffunction name="parsePropertySubElement" hint="parses a common sub element such as ref, bean, map etc and returns a AbstractValue is it find something" access="public" returntype="any" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is the parent element" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the containing bean definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(!isDefaultNamespace(arguments.element.getNamespaceURI()))
		{
			local.beanDef = parseNestedCustomElement(arguments.element, arguments.beanDefinition);
			getBeanDefinitionRegistry().registerBeanDefinition(local.beanDef);

			return createObject("component", "coldspring.beans.support.RefValue").init(local.beanDef.getId(), getBeanDefinitionRegistry());
		}

		if(arguments.element.getLocalName() eq instance.static.REF_ELEMENT)
		{
			local.beanName = arguments.element.getAttribute(instance.static.BEAN_ATTRIBUTE);
			return createObject("component", "coldspring.beans.support.RefValue").init(local.beanName, getBeanDefinitionRegistry());
		}
		else if(arguments.element.getLocalName() eq instance.static.VALUE_ELEMENT)
		{
			local.simpleValue = arguments.element.getTextContent();
			return createObject("component", "coldspring.beans.support.SimpleValue").init(local.simpleValue);
		}
		else if(arguments.element.getLocalName() eq instance.static.BEAN_ELEMENT)
		{
			local.beanDef = parseBeanDefinitionElement(arguments.element);
			getBeanDefinitionRegistry().registerBeanDefinition(local.beanDef);

			return createObject("component", "coldspring.beans.support.RefValue").init(local.beanDef.getID(), getBeanDefinitionRegistry());
		}
		else if(arguments.element.getLocalName() eq instance.static.LIST_ELEMENT)
		{
			return parseListElement(argumentCollection=arguments);
		}
		else if(arguments.element.getLocalName() eq instance.static.MAP_ELEMENT)
		{
			return parseMapElement(argumentCollection=arguments);
		}
    </cfscript>
</cffunction>

<cffunction name="parseMetaElements" hint="parse all meta sub-elements on a given element" access="public" returntype="void" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that we are looking for sub elements" type="any" required="Yes">
	<cfargument name="metaObject" hint="to object to add custm meta data to. Must have a method getMeta() that returns a struct" type="any" required="Yes">
	<cfscript>
		/*
			Don't use getElementsByTagName(), as <meta> an be in <bean>, <property>, and <constructor-arg>
		*/
		var childNodes = arguments.element.getChildNodes();
		var counter = 0;
		var child = 0;

		for(;counter lt childNodes.getLength(); counter++)
		{
			child = childNodes.item(counter);

			if(child.getNodeType() eq getNode().ELEMENT_NODE AND child.getLocalName() eq instance.static.META_ELEMENT)
			{
				parseMetaElement(child, arguments.metaObject);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="parseMetaElement" hint="parses a single meta element" access="public" returntype="void" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is the property" type="any" required="Yes">
	<cfargument name="metaObject" hint="to object to add custm meta data to. Must have a method getMeta() that returns a struct" type="any" required="Yes">
	<cfscript>
		var key = arguments.element.getAttribute(instance.static.KEY_ATTRIBUTE);
		var value = arguments.element.getAttribute(instance.static.VALUE_ELEMENT);

		structInsert(arguments.metaObject.getMeta(), key, value, true);
    </cfscript>
</cffunction>

<cffunction name="isDefaultNamespace" hint="utility method for determining if the namespace is the default beans namespace" access="public" returntype="boolean" output="false">
	<cfargument name="namespaceUri" hint="the namespace uri" type="string" required="Yes">
	<cfscript>
		return arguments.namespaceUri eq instance.static.BEANS_NAMESPACE_URI;
    </cfscript>
</cffunction>

<cffunction name="parseCustomElement" hint="parses a custom element, and returns the bean definitions that it returns (if any)" access="public" returntype="any" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element to be parsed" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the containing bean definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var namespaceHandler = getReaderContext().getXMLParser().getNamespaceHandler(arguments.element.getNamespaceURI());
		var parser = 0;
		var parserContext = 0;

		if(namespaceHandler.hasBeanDefinitionParser(arguments.element))
		{
			parserContext = createObject("component", "coldspring.beans.xml.ParserContext").init(getBeanDefinitionRegistry(), this);

			parserContext.setNamespaceHandler(namespaceHandler);
			parserContext.setContainingBeanDefinition(arguments.beanDefinition);

			parser = namespaceHandler.getBeanDefinitionParser(arguments.element);

			return parser.parse(arguments.element, parserContext);
		}
    </cfscript>
</cffunction>

<cffunction name="getReaderContext" hint="get the current context for reading the current xml document"
	access="public" returntype="ReaderContext" output="false">
	<cfreturn instance.readerContext />
</cffunction>

<cffunction name="getNode" hint="Access to 'org.w3c.dom.Node' static values" access="public" returntype="any" output="false">
	<cfreturn instance.node />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initDefaultValues" hint="initialise default bean values" access="private" returntype="void" output="false">
	<cfargument name="element" hint="the top level org.w3c.dom.Element for the config xml" type="any" required="Yes">
	<cfscript>
		setDefaultAutorwireMode(arguments.element.getAttribute(instance.static.DEFAULT_AUTOWIRE_ATTRIBUTE));
		setDefaultLazyInit(arguments.element.getAttribute(instance.static.DEFAULT_LAZY_INIT_ATTRIBUTE));
    </cfscript>
</cffunction>

<cffunction name="parseNestedCustomElement" hint="parses a nested custom element, and throws an exception if anything but a single beanDefinition is returned" access="private"
			returntype="coldspring.beans.support.AbstractBeanDefinition" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element to be parsed" type="any" required="Yes">
	<cfargument name="beanDefinition" hint="the bean definition that wraps this custom element" type="any" required="Yes">
	<cfscript>
		var local = {};

		local.beanDef = parseCustomElement(argumentCollection=arguments);

		if(!structKeyExists(local, "beanDef") OR !isInstanceOf(local.beanDef, "coldspring.beans.support.AbstractBeanDefinition"))
		{
			createObject("component", "coldspring.beans.xml.exception.InvalidInnerBeanException").init(arguments.element, arguments.containingBeanDef);
		}

		//set the id, as it won't have one as it's an inner bean
		local.beanDef.setId(createUUID());

		return local.beanDef;
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinitionRegistry" access="private" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn instance.beanDefinitionRegistry />
</cffunction>

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

<cffunction name="setReaderContext" access="private" returntype="void" output="false">
	<cfargument name="readerContext" type="ReaderContext" required="true">
	<cfset instance.readerContext = arguments.readerContext />
</cffunction>

<cffunction name="getDefaultAutorwireMode" access="private" returntype="string" output="false">
	<cfreturn instance.defaultAutorwireMode />
</cffunction>

<cffunction name="setDefaultAutorwireMode" access="private" returntype="void" output="false">
	<cfargument name="defaultAutorwireMode" type="string" required="true">
	<cfset instance.defaultAutorwireMode = arguments.defaultAutorwireMode />
</cffunction>

<cffunction name="getDefaultLazyInit" access="private" returntype="string" output="false">
	<cfreturn instance.defaultLazyInit />
</cffunction>

<cffunction name="setDefaultLazyInit" access="private" returntype="void" output="false">
	<cfargument name="defaultLazyInit" type="string" required="true">
	<cfset instance.defaultLazyInit = arguments.defaultLazyInit />
</cffunction>

<cffunction name="setNode" access="private" returntype="void" output="false">
	<cfargument name="node" type="any" required="true">
	<cfset instance.node = arguments.node />
</cffunction>

</cfcomponent>