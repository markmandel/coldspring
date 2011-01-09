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

<cfcomponent hint="An abstract bean factory" implements="BeanFactory" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setParentBeanFactory" access="public" returntype="void" output="false">
	<cfargument name="parent" type="any" required="Yes"
	colddoc:generic="BeanFactory">
	<cfset instance.parent = arguments.parent />
</cffunction>

<cffunction name="getParentBeanFactory"  hint="Returns the parent BeanFactory that can be considered for hierarchical bean factories"
	access="public" returntype="any" output="false"
	colddoc:generic="BeanFactory">
	<cfreturn instance.parent />
</cffunction>

<cffunction name="hasParentBeanFactory" hint="whether this abstract bean factory has a parent" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "parent") />
</cffunction>

<cffunction name="getBean" hint="Return an instance, which may be shared or independent, of the specified bean.<br/>
			This method allows a ColdSpring BeanFactory to be used as a replacement for the Singleton or Prototype design pattern. Callers may retain references to returned objects in the case of Singleton beans.<br/>
			Translates aliases back to the corresponding canonical bean name. Will ask the parent factory if the bean cannot be found in this factory instance. " access="public" returntype="any" output="false">
	<cfargument name="name" hint="the name of the bean to get" type="string" required="Yes">
	<cfscript>
		/*
			This is the only time in which the BeanFactory goes up to the parent
			all other hierarchical support is done through the BeanDefinitionRegistry.

			Since this method is one of the few non-proxy methods for the Registry,
			we manage this here.
		*/

		if(!hasParentBeanFactory() OR containsBeanDefinition(argumentCollection=arguments))
		{
			return getBeanDefinitionRegistry().getBeanDefinition(argumentCollection=arguments).getInstance();
		}

		//go up to parent
		return getParentBeanFactory().getBean(arguments.name);
    </cfscript>
</cffunction>

<cffunction name="containsBean" hint="Does this bean factory contain a bean with the given name? More specifically, is getBean(java.lang.String) able to obtain a bean instance for the given name?<br/>
	Translates aliases back to the corresponding canonical bean name. Will ask the parent factory if the bean cannot be found in this factory instance. "
	access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
	<cfscript>
		return getBeanDefinitionRegistry().containsBean(argumentCollection=arguments);
    </cfscript>
</cffunction>

<cffunction name="containsBeanDefinition" hint="Check if this bean factory contains a bean definition with the given name.<br/>
		Does not consider any hierarchy this factory may participate in, and ignores any singleton beans that have been registered by other means than bean definitions."
		access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
	<cfreturn getBeanDefinitionRegistry().containsBeanDefinition(argumentCollection=arguments) />
</cffunction>

<cffunction name="refresh" hint="Refresh the bean factory. Implementations of this BeanFactory will want to implement their own refresh() method."
			access="public" returntype="void" output="false">
	<cfscript>
		prepareRefresh();
		endRefresh();
    </cfscript>
</cffunction>

<cffunction name="getAliases"
	hint="Return the aliases for the given bean name, if any. All of those aliases point to the same bean when used in a getBean(java.lang.String) call.<br/>
	If the given name is an alias, the corresponding original bean name and other aliases (if any) will be returned, with the original bean name being the first element in the array.<br/>
	Will ask the parent factory if the bean cannot be found in this factory instance." access="public" returntype="array" output="false">
	<cfargument name="name" hint="name - the bean name to check for aliases " type="string" required="Yes">
	<cfreturn getBeanDefinitionRegistry().getAliases(argumentCollection=arguments) />
</cffunction>

<cffunction name="addBeanFactoryPostProcessor" hint="programatically add a beanFactory post processor" access="public" returntype="void" output="false">
	<cfargument name="postProcessor" hint="the post processor in question" type="coldspring.beans.factory.config.BeanFactoryPostProcessor" required="Yes">
	<cfreturn getBeanDefinitionRegistry().addBeanFactoryPostProcessor(argumentCollection=arguments) />
</cffunction>

<cffunction name="addBeanPostProcessor" hint="programatically add a bean post processor" access="public" returntype="void" output="false">
	<cfargument name="postProcessor" hint="the post processor in question" type="coldspring.beans.factory.config.BeanPostProcessor" required="Yes">
	<cfset getBeanDefinitionRegistry().addBeanPostProcessor(argumentCollection=arguments)>
</cffunction>

<cffunction name="getBeanDefinitionCount" hint="Return the number of beans defined in this bean factory." access="public" returntype="numeric" output="false">
	<cfreturn getBeanDefinitionRegistry().getBeanDefinitionCount() />
</cffunction>

<cffunction name="getBeanDefinitionNames" hint="Return the names of all beans defined in this bean factory" access="public" returntype="array" output="false"
			colddoc:generic="string">
	<cfreturn getBeanDefinitionRegistry().getBeanDefinitionNames() />
</cffunction>

<cffunction name="getBeanNamesForType" hint="Return the names of beans matching the given type (including subclasses),
			judging from either bean definitions or the value of getObjectType in the case of FactoryBeans.<br/>
			Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized.<br/>
			Does not consider any hierarchy this factory may participate in."
			access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class type" type="string" required="Yes">
	<cfreturn getBeanDefinitionRegistry().getBeanNamesForType(argumentCollection=arguments) />
</cffunction>

<cffunction name="getBeanNamesForTypeIncludingAncestor" hint="Get all bean names for the given type, including those defined in ancestor factories. Will return unique names in case of overridden bean definitions.<br/>
		    Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized."
	access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class type" type="string" required="Yes">
	<cfreturn getBeanDefinitionRegistry().getBeanNamesForTypeIncludingAncestor(argumentCollection=arguments) />
</cffunction>

<cffunction name="getBeanDefinition" hint="Get a bean definition from the registry. Throws a BeanDefinitionNotFoundException if it doesn't exist.<br/>Does not consider any hierarchy this bean factor may participate in."
	access="public" returntype="coldspring.beans.support.BeanDefinition" output="false">
	<cfargument name="name" hint="the name of the bean definition to get" type="string" required="Yes">
	<cfreturn getBeanDefinitionRegistry().getBeanDefinition(argumentCollection=arguments) />
</cffunction>

<cffunction name="getBeanDefinitionIncludingAncestor" hint="Get a bean definition from the registry, including those that may be in an ancesor factory."
	access="public" returntype="coldspring.beans.support.BeanDefinition" output="false">
	<cfargument name="name" hint="the name of the bean definition to get" type="string" required="Yes">
	<cfreturn getBeanDefinitionRegistry().getBeanDefinitionIncludingAncestor(argumentCollection=arguments) />
</cffunction>

<cffunction name="isAutowireCandidate" hint="Determine whether the specified bean qualifies as an autowire candidate, to be injected into other beans which declare a dependency of matching type/name.<br/>
	This method checks ancestor factories as well. Thrown an exception if the bean is not found"
	access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check" type="string" required="Yes">
	<cfreturn getBeanDefinitionRegistry().isAutowireCandidate(argumentCollection=arguments) />
</cffunction>

<cffunction name="getDynamicProperties" access="public" returntype="struct" output="false">
	<cfreturn instance.dynamicProperties />
</cffunction>

<cffunction name="getVersion" hint="Retrieves the version of the bean factory you are using" access="public" returntype="string" output="false">
	<cfreturn "0.6">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfargument name="dynamicProperties" hint="A struct of key value pairs, for which the keys will be used to translate '${key}' string values in BeanDefinitions properties into their corresponding values."
				type="struct" required="no" default="#StructNew()#">
	<cfscript>
		initSingletons();
		setDynamicProperties(arguments.dynamicProperties);
	</cfscript>
</cffunction>

<cffunction name="prepareRefresh" hint="prepares the refresh method, should be called at the beginning of refresh()" access="private" returntype="void" output="false">
	<cfscript>
		setBeanCache(createObject("component", "coldspring.beans.factory.BeanCache").init());
		setBeanDefinitionRegistry(createObject("component", "BeanDefinitionRegistry").init(this, getBeanCache()));
    </cfscript>
</cffunction>

<cffunction name="endRefresh" hint="finalises the refresh, and notifies the beans they are complete, and validates them. Should be called at the end of a refresh() method."
			access="private" returntype="void" output="false">
	<cfscript>
		getBeanDefinitionRegistry().notifyComplete();
		getBeanDefinitionRegistry().validate();

		instantiateaNonLazyBeans();
    </cfscript>
</cffunction>

<cffunction name="instantiateaNonLazyBeans" hint="go through the bean definitions and instantiate any of the beans that aren't lazy-init='true'" access="private" returntype="void" output="false">
	<cfscript>
		var beanNames = getBeanDefinitionNames();
		var len = ArrayLen(beanNames);
		var counter = 1;
		var name = 0;
		var beanDef = 0;

        for(; counter lte len; counter++)
        {
			name = beanNames[counter];

			beanDef = getBeanDefinition(name);

			/**
			 * only eagerly init when a bean is lazy-init=false, a singleton
			 * and also not abstract.
			 */
			if(NOT beanDef.isAbstract() AND NOT beanDef.isLazyInit() AND beanDef.getScope() eq "singleton")
			{
				getBean(name);
			}
        }
    </cfscript>
</cffunction>

<cffunction name="initSingletons" hint="create the singletons that are used by this framework" access="private" returntype="void" output="false">
	<cfscript>
		var singleton = createObject("component", "coldspring.util.Singleton").init();
		var reflectionService = singleton.createInstance("coldspring.core.reflect.ReflectionService");
		var args = {version=getVersion()};

		/*
			This needs to cleared on each init, as the class
			cache is stored in the meta data scope with this
			singleton, and class data may have changed.
		*/
		reflectionService.clearCache();

		singleton.createInstance("coldspring.core.java.JavaLoader", args);
		singleton.createInstance("coldspring.util.Singleton");
		singleton.createInstance("coldspring.util.MethodInjector");
		singleton.createInstance("coldspring.util.Cloneable");
		singleton.createInstance("coldspring.core.proxy.DynamicProxyFactory");
		singleton.createInstance("coldspring.core.OrderComparator");
    </cfscript>
</cffunction>

<cffunction name="getBeanCache" access="private" returntype="coldspring.beans.factory.BeanCache" output="false">
	<cfreturn instance.beanCache />
</cffunction>

<cffunction name="setBeanCache" access="private" returntype="void" output="false">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" required="true">
	<cfset instance.beanCache = arguments.beanCache />
</cffunction>

<cffunction name="getBeanDefinitionRegistry" access="private" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn instance.beanDefinitionRegistry />
</cffunction>

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

<cffunction name="setDynamicProperties" access="private" returntype="void" output="false">
	<cfargument name="dynamicProperties" type="struct" required="true">
	<cfset instance.dynamicProperties = arguments.dynamicProperties />
</cffunction>

</cfcomponent>