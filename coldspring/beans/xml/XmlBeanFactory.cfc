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

<cfcomponent hint="Bean Factory whose source is XML" extends="coldspring.beans.AbstractBeanFactory" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="XMLBeanFactory" output="false">
	<cfargument name="configLocations" hint="optional string path, list path, or array of absolute paths to ColdSpring XML files. Can use setConfigLocations() instead, followed by a call to refresh()"
				type="any" required="no">
	<cfscript>
		super.init();

		setXMLParser(createObject("component", "XmlParser").init(getJavaLoader()));

		initDefaultNamespaceHandlers();

		if(structKeyExists(arguments, "configLocations"))
		{
			setConfigLocations(arguments.configLocations);
			refresh();
		}

		return this;
	</cfscript>
</cffunction>

<cffunction name="setConfigLocations" access="public" returntype="void" output="false">
	<cfargument name="configLocations" hint="string path, list path, or array of absolute paths to ColdSpring XML files. Can use setConfigLocations() instead, followed by a call to refresh()"
				type="any" required="yes">
	<cfset getXMLParser().setConfigLocations(argumentCollection=arguments)>
</cffunction>

<cffunction name="refresh" hint="refresh the bean factory" access="public" returntype="void" output="false">
	<cfscript>
		prepareRefresh();

		getXMLParser().setBeanDefinitionRegistry(getBeanDefinitionRegistry());

		getXMLParser().parseConfigLocationsToBeanDefintions();

		endRefresh();
    </cfscript>
</cffunction>

<cffunction name="addNamespaceHandler" hint="adds a handler for a given namespace" access="public" returntype="void" output="false">
	<cfargument name="handler" hint="the handler for a given set of namespace" type="coldspring.beans.xml.AbstractNamespaceHandler" required="Yes">
	<cfscript>
		getXMLParser().addNamespaceHandler(argumentCollection=arguments);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initDefaultNamespaceHandlers" hint="sets up the default namespace handlers" access="private" returntype="void" output="false">
	<cfscript>
		addNamespaceHandler(createObject("component", "coldspring.beans.xml.config.BeansNamespaceHandler").init());
		addNamespaceHandler(createObject("component", "coldspring.beans.xml.config.UtilNamespaceHandler").init());
    </cfscript>
</cffunction>

<cffunction name="getXMLParser" access="private" returntype="XmlParser" output="false">
	<cfreturn instance.xmlParser />
</cffunction>

<cffunction name="setXMLParser" access="private" returntype="void" output="false">
	<cfargument name="xmlParser" type="XmlParser" required="true">
	<cfset instance.xmlParser = arguments.xmlParser />
</cffunction>

</cfcomponent>