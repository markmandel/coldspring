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

<cfcomponent hint="An abstract bean factory" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setParent" access="public" returntype="void" output="false">
	<cfargument name="parent" type="coldspring.beans.AbstractBeanFactory" required="Yes">
	<cfset instance.parent = arguments.parent />
</cffunction>

<cffunction name="getParent" access="public" returntype="coldspring.beans.AbstractBeanFactory" output="false">
	<cfreturn instance.parent />
</cffunction>

<cffunction name="hasParent" hint="whether this abstract bean factory has a parent" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "parent") />
</cffunction>

<cffunction name="getBean" hint="gets a bean by a given id" access="public" returntype="any" output="false">
	<cfargument name="id" hint="the id of the bean to get" type="string" required="Yes">
	<cfscript>
    	var beanDef = 0;
		var bean = 0;
    </cfscript>

	<cftry>
	<cfscript>
		beanDef = getBeanDefinitionRegistry().getBeanDefinition(argumentCollection=arguments);
		bean = beanDef.getInstance();

		//clear out the prototype cache, is it is thread local.
		getBeanCache().clearPrototypeCache();

		return bean;
    </cfscript>
		<cfcatch>
			<cfset getBeanCache().clearPrototypeCache()>
			<cfrethrow>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="containsBeanDefinition" hint="Returns true if a bean (definition) exists" access="public" returntype="boolean" output="false">
	<cfargument name="id" hint="the id of the bean to check for" type="string" required="Yes" />
	<cfreturn getBeanDefinitionRegistry().containsBeanDefinition(argumentCollection=arguments) />
</cffunction>

<cffunction name="refresh" hint="refresh the bean factory" access="public" returntype="void" output="false">
	<cfscript>
		setBeanCache(createObject("component", "coldspring.beans.factory.BeanCache").init());
		setBeanDefinitionRegistry(createObject("component", "BeanDefinitionRegistry").init(getBeanCache()));
    </cfscript>
</cffunction>

<cffunction name="getVersion" hint="Retrieves the version of the bean factory you are using" access="public" returntype="string" output="false">
	<cfreturn "0.1.b">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfscript>
		setJavaLoader(createObject("component", "coldspring.util.java.JavaLoader").init(getVersion()));
	</cfscript>
</cffunction>

<cffunction name="getBeanCache" access="private" returntype="coldspring.beans.factory.BeanCache" output="false">
	<cfreturn instance.beanCache />
</cffunction>

<cffunction name="setBeanCache" access="private" returntype="void" output="false">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" required="true">
	<cfset instance.beanCache = arguments.beanCache />
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

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

</cfcomponent>