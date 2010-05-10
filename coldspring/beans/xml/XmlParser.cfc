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

<cfcomponent hint="The generic parser for the xml configuration">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="XmlParser" output="false">
	<cfargument name="javaLoader" hint="the javaloader lib" type="coldspring.util.java.JavaLoader" required="true">
	<cfscript>
		setNamespaceHandlers(StructNew());

		setConfigLocations(ArrayNew(1)); //have a default value, to prevent error
		setSchemaMap(StructNew());

		setJavaLoader(arguments.javaLoader);

		return this;
	</cfscript>
</cffunction>

<cffunction name="addNamespaceHandler" hint="adds a handler for a given namespace" access="public" returntype="void" output="false">
	<cfargument name="handler" hint="the handler for a given set of namespace" type="coldspring.beans.xml.AbstractNamespaceHandler" required="Yes">
	<cfscript>
		var namespaces = arguments.handler.getNamespaces();
		var namespace = 0;

		if(isSimpleValue(namespaces))
		{
			namespaces = listToArray(namespaces);
		}

		StructAppend(getSchemaMap(), arguments.handler.getSchemaLocations(), true);
    </cfscript>

	<cfloop array="#namespaces#" index="namespace">
		<cfscript>
			structInsert(getNamespaceHandlers(), namespace, arguments.handler, true);
        </cfscript>
	</cfloop>
</cffunction>

<cffunction name="parseConfigLocationsToBeanDefintions" hint="Takes the current XML Config Locations and passes the XML data to their relevent parsers for parsing,
	and then add the beans to the system"
	access="public" returntype="void" output="false">
	<cfscript>
		var configLocations = getConfigLocations();
		var config = 0;
    </cfscript>

	<cfloop array="#configLocations#" index="config">
		<cfset parseXMLToBeanDefinitions(config)>
	</cfloop>
</cffunction>

<cffunction name="parseXMLToBeanDefinitions" hint="Parse a specific XML document into bean definitions, and add them to the registry" access="public" returntype="void" output="false">
	<cfargument name="path" hint="the absolute path to the XML configuration file" type="string" required="Yes">
	<cfscript>
		var xmlFileReader = createObject("component", "coldspring.io.XMLFileReader").init(arguments.path, getJavaLoader(), getSchemaMap());
		var document = xmlFileReader.parseToDocument();
		var delegate = 0;
		var parserContext = 0;

		document.normalize();

		delegate = createObject("component", "coldspring.beans.xml.BeanDefinitionParserDelegate").init(document, getBeanDefinitionRegistry());
		parserContext = createObject("component", "coldspring.beans.xml.ParserContext").init(getBeanDefinitionRegistry(), this, xmlFileReader, delegate);

		parseElement(document.getDocumentElement(), parserContext);
    </cfscript>
</cffunction>

<cffunction name="setBeanDefinitionRegistry" access="public" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

<cffunction name="setConfigLocations" access="public" returntype="void" output="false">
	<cfargument name="configLocations" hint="string path, list path, or array of absolute paths to ColdSpring XML files. Can use setConfigLocations() instead, followed by a call to refresh()"
				type="any" required="yes">
	<cfscript>
		if(isSimpleValue(arguments.configLocations))
		{
			arguments.configLocations = listToArray(arguments.configLocations);
		}
    </cfscript>
	<cfset instance.configLocations = arguments.configLocations />
</cffunction>

<cffunction name="getConfigLocations" access="public" returntype="array" output="false"
			colddoc:generic="string">
	<cfreturn instance.configLocations />
</cffunction>

<cffunction name="getNamespaceHandler" hint="get the namespace handler for a given namespace" access="public" returntype="coldspring.beans.xml.AbstractNamespaceHandler" output="false">
	<cfargument name="namespace" hint="the namespace to look for" type="string" required="Yes">
	<cfreturn StructFind(getNamespaceHandlers(), arguments.namespace) />
</cffunction>

<cffunction name="hasNamespaceHandler" hint="do we have a namespace handler for the given namespace?" access="public" returntype="boolean" output="false">
	<cfargument name="namespace" hint="the namespace to look for" type="string" required="Yes">
	<cfreturn StructKeyExists(getNamespaceHandlers(), arguments.namespace) />
</cffunction>

<cffunction name="getNamespaceHandlers" access="public" hint="Return all the namespace handlers for all namespaces" returntype="struct" output="false"
			colddoc:generic="string,AbstractNamespaceHandler">
	<cfreturn instance.namespaceHandlers />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!---
	/**
	 * Parse the elements at the root level in the document:
	 * "import", "alias", "bean".
	 * @param root the DOM root element of the document
	 */
	protected void parseBeanDefinitions(Element root, BeanDefinitionParserDelegate delegate) {
		if (delegate.isDefaultNamespace(root.getNamespaceURI())) {
			NodeList nl = root.getChildNodes();
			for (int i = 0; i < nl.getLength(); i++) {
				Node node = nl.item(i);
				if (node instanceof Element) {
					Element ele = (Element) node;
					String namespaceUri = ele.getNamespaceURI();
					if (delegate.isDefaultNamespace(namespaceUri)) {
						parseDefaultElement(ele, delegate);
					}
					else {
						delegate.parseCustomElement(ele);
					}
				}
			}
		}
		else {
			delegate.parseCustomElement(root);
		}
	}

 --->

<cffunction name="parseElement" hint="parses an XML element" access="private" returntype="void" output="false">
	<cfargument name="element" hint="The root org.w3c.dom.Element of the document, to parse" type="any" required="Yes">
	<cfargument name="parserContext" hint="the parser context" type="coldspring.beans.xml.ParserContext" required="No" default="#getParserContextThreadLocal().get()#">
	<cfscript>
		var Node = arguments.parserContext.getDelegate().getNode();
		var namespaceHandler = 0;
		var parser = 0;
		var local = {};
		var nodeList = 0;
		var counter = 0;
		var newContext = 0;
		var child = 0;

		if(arguments.element.getNodeType() eq Node.ELEMENT_NODE)
		{
			newContext = arguments.parserContext.clone();

			if(hasNamespaceHandler(arguments.element.getNamespaceURI()))
			{
				namespaceHandler = getNamespaceHandler(arguments.element.getNamespaceURI());

				if(namespaceHandler.hasBeanDefinitionParser(arguments.element))
				{
					arguments.parserContext.setNamespaceHandler(namespaceHandler);

					parser = namespaceHandler.getBeanDefinitionParser(arguments.element);

					//do your parsing.
					local.beanDefinitions = parser.parse(arguments.element, arguments.parserContext);

					if(NOT structKeyExists(local, "beanDefinitions"))
					{
						if(arguments.parserContext.hasContainingBeanDefinition())
						{
							newContext.setContainingBeanDefinition(arguments.parserContext.getContainingBeanDefinition());
						}
					}
					else if(isObject(local.beanDefinitions))
					{
						newContext.setContainingBeanDefinition(local.beanDefinitions);

						getBeanDefinitionRegistry().registerBeanDefinition(local.beanDefinitions);
					}
					else if(isArray(local.beanDefinitions))
					{
						local.len = ArrayLen(local.beanDefinitions);
                        for(local.counter=1; local.counter lte local.len; local.counter++)
                        {
                        	local.beanDef = local.beanDefinitions[local.counter];
							getBeanDefinitionRegistry().registerBeanDefinition(local.beanDef);
                        }
					}
				}
			}

			nodeList = arguments.element.getChildNodes();

			for(counter = 0; counter lt nodeList.getLength(); counter++)
			{
				parseElement(nodeList.item(counter), newContext);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="setNamespaceHandlers" access="private" returntype="void" output="false">
	<cfargument name="namespaceHandlers" type="struct" required="true" colddoc:generic="string,AbstractNamespaceHandler">
	<cfset instance.namespaceHandlers = arguments.namespaceHandlers />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldspring.util.java.JavaLoader" output="false">
	<cfreturn instance.JavaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="JavaLoader" type="coldspring.util.java.JavaLoader" required="true">
	<cfset instance.JavaLoader = arguments.JavaLoader />
</cffunction>

<cffunction name="getBeanDefinitionRegistry" access="private" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn instance.beanDefinitionRegistry />
</cffunction>

<cffunction name="getSchemaMap" access="private" returntype="struct" output="false" hint="Collection to map all the schemas to local resource paths"
			colddoc:generic="string,string">
	<cfreturn instance.schemaMap />
</cffunction>

<cffunction name="setSchemaMap" access="private" returntype="void" output="false">
	<cfargument name="schemaMap" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.schemaMap = arguments.schemaMap />
</cffunction>

</cfcomponent>