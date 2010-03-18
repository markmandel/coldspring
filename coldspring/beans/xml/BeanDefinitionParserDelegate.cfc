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

	instance.static.DEFAULT_AUTOWIRE_ATTRIBUTE = "default-autowire";

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
	instance.static.AUTOWIRE_ATTRIBUTE = "autowire";
	instance.static.NAME_ATTRIBUTE = "name";
	instance.static.REF_ATTRIBUTE = "ref";
	instance.static.VALUE_ATTRIBUTE = "value";
	instance.static.BEAN_ATTRIBUTE = "bean";
	instance.static.KEY_ATTRIBUTE = "key";
	instance.static.KEY_REF_ATTRIBUTE = "key-ref";
	instance.static.VALUE_REF_ATTRIBUTE = "value-ref";
	instance.static.ABSTRACT_ATTRIBUTE = "abstract";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanDefinitionParserDelegate" output="false">
	<cfargument name="document" hint="the configuration XML org.w3c.dom.Document for this XML config file" type="any" required="Yes">
	<cfargument name="beanDefinitionRegistry" hint="The bean definition registry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfscript>
		initDefaultValues(arguments.document.getDocumentElement());
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
			id = class & "." & createUUID();
		}

		beanDef = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id, getBeanDefinitionRegistry());

		if(arguments.element.hasAttribute(instance.static.CLASS_ATTRIBUTE))
		{
			beanDef.setClassName(arguments.element.getAttribute(instance.static.CLASS_ATTRIBUTE));
		}

		//set autowire
		beanDef.setAutowire(getAutowireMode(arguments.element.getAttribute(instance.static.AUTOWIRE_ATTRIBUTE)));

		//add constructor args
		parseConstructorArgElements(arguments.element, beanDef);

		//add property args
		parsePropertyElements(arguments.element, beanDef);

		//abstract
		if(arguments.element.hasAttribute(instance.static.ABSTRACT_ATTRIBUTE))
		{
			beanDef.setAbstract(arguments.element.getAttribute(instance.static.ABSTRACT_ATTRIBUTE));
		}

		//meta elements
		parseMetaElements(arguments.element, beanDef);

		return beanDef;
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

		local.value = parsePropertySubElements(arguments.element);

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

		local.value = parsePropertySubElements(arguments.element);

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
				local.value = parsePropertySubElement(child);

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
					local.value = parsePropertySubElements(local.child);
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
					local.value = parsePropertySubElement(local.element);

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
	<cfscript>
		if(arguments.element.getTagName() eq instance.static.REF_ELEMENT)
		{
			local.beanName = arguments.element.getAttribute(instance.static.BEAN_ATTRIBUTE);
			return createObject("component", "coldspring.beans.support.RefValue").init(local.beanName, getBeanDefinitionRegistry());
		}
		else if(arguments.element.getTagName() eq instance.static.VALUE_ELEMENT)
		{
			local.simpleValue = arguments.element.getTextContent();
			return createObject("component", "coldspring.beans.support.SimpleValue").init(local.simpleValue);
		}
		else if(arguments.element.getTagName() eq instance.static.BEAN_ELEMENT)
		{
			local.beanDef = parseBeanDefinitionElement(arguments.element);
			getBeanDefinitionRegistry().registerBeanDefinition(local.beanDef);

			return createObject("component", "coldspring.beans.support.RefValue").init(local.beanDef.getID(), getBeanDefinitionRegistry());
		}
		else if(arguments.element.getTagName() eq instance.static.LIST_ELEMENT)
		{
			return parseListElement(arguments.element);
		}
		else if(arguments.element.getTagName() eq instance.static.MAP_ELEMENT)
		{
			return parseMapElement(arguments.element);
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

			if(child.getNodeType() eq getNode().ELEMENT_NODE AND child.getTagName() eq instance.static.META_ELEMENT)
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

<cffunction name="getNode" hint="Access to 'org.w3c.dom.Node' static values" access="public" returntype="any" output="false">
	<cfreturn instance.node />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initDefaultValues" hint="initialise default bean values" access="private" returntype="void" output="false">
	<cfargument name="element" hint="the top level org.w3c.dom.Element for the config xml" type="any" required="Yes">
	<cfscript>
		setDefaultAutorwireMode(arguments.element.getAttribute(instance.static.DEFAULT_AUTOWIRE_ATTRIBUTE));
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinitionRegistry" access="private" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn instance.beanDefinitionRegistry />
</cffunction>

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

<cffunction name="getDefaultAutorwireMode" access="private" returntype="string" output="false">
	<cfreturn instance.defaultAutorwireMode />
</cffunction>

<cffunction name="setDefaultAutorwireMode" access="private" returntype="void" output="false">
	<cfargument name="defaultAutorwireMode" type="string" required="true">
	<cfset instance.defaultAutorwireMode = arguments.defaultAutorwireMode />
</cffunction>

<cffunction name="setNode" access="private" returntype="void" output="false">
	<cfargument name="node" type="any" required="true">
	<cfset instance.node = arguments.node />
</cffunction>

</cfcomponent>