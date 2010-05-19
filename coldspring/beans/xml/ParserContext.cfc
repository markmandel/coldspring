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

<cfcomponent hint="The parser context when parsing XML" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ParserContext" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfargument name="delegate" type="coldspring.beans.xml.BeanDefinitionParserDelegate" required="true">
	<cfscript>
		setBeanDefinitionRegistry(arguments.beanDefinitionRegistry);
		setDelegate(arguments.delegate);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getNamespaceHandler" hint="The current namespace handler" access="public" returntype="coldspring.beans.xml.AbstractNamespaceHandler" output="false">
	<cfreturn instance.namespaceHandler />
</cffunction>

<cffunction name="setNamespaceHandler" access="public" returntype="void" output="false">
	<cfargument name="namespaceHandler" type="coldspring.beans.xml.AbstractNamespaceHandler" required="true">
	<cfset instance.namespaceHandler = arguments.namespaceHandler />
</cffunction>

<cffunction name="getContainingBeanDefinition" hint="The parent bean defintion that was created from a parent element of this one" access="public" returntype="coldspring.beans.support.AbstractBeanDefinition" output="false">
	<cfreturn instance.containingBeanDefinition />
</cffunction>

<cffunction name="setContainingBeanDefinition" access="public" returntype="void" output="false">
	<cfargument name="containingBeanDefinition" type="coldspring.beans.support.AbstractBeanDefinition" required="true">
	<cfset instance.containingBeanDefinition = arguments.containingBeanDefinition />
</cffunction>

<cffunction name="hasContainingBeanDefinition" hint="whether this object has a containing BeanDefinition" access="public" returntype="boolean" output="false">
  	<cfreturn StructKeyExists(instance, "containingBeanDefinition") />
</cffunction>

<cffunction name="getBeanDefinitionRegistry" hint="The bean definition registry" access="public" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn instance.beanDefinitionRegistry />
</cffunction>

<cffunction name="getDelegate" access="public" hint="Access to the bean defintion parser delegate, for easy access to Bean Definition parsing routines"
	returntype="coldspring.beans.xml.BeanDefinitionParserDelegate" output="false">
	<cfreturn instance.delegate />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="clone" hint="clone this parser context. Does not copy the containing bean definition, or the namespace handler" access="public" returntype="ParserContext" output="false">
	<cfscript>
		//not using clonable framework, just as this is super easy to clone, and this will be faster.
		var clone = createObject("component", "ParserContext").init(getBeanDefinitionRegistry(), getDelegate());

		return clone;
    </cfscript>
</cffunction>

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

<cffunction name="setDelegate" access="private" returntype="void" output="false">
	<cfargument name="delegate" type="coldspring.beans.xml.BeanDefinitionParserDelegate" required="true">
	<cfset instance.delegate = arguments.delegate />
</cffunction>

</cfcomponent>