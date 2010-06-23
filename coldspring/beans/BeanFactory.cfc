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

<cfinterface hint="Interface to a Bean Factory, that can be used to dependency inject a series of bean definitions">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getBean" hint="Return an instance, which may be shared or independent, of the specified bean.<br/>
			This method allows a ColdSpring BeanFactory to be used as a replacement for the Singleton or Prototype design pattern. Callers may retain references to returned objects in the case of Singleton beans.<br/>
			Translates aliases back to the corresponding canonical bean name. Will ask the parent factory if the bean cannot be found in this factory instance. " access="public" returntype="any" output="false">
	<cfargument name="name" hint="the name of the bean to get" type="string" required="Yes">
</cffunction>

<cffunction name="containsBean" hint="Does this bean factory contain a bean with the given name? More specifically, is getBean(java.lang.String) able to obtain a bean instance for the given name?<br/>
	Translates aliases back to the corresponding canonical bean name. Will ask the parent factory if the bean cannot be found in this factory instance. "
	access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
</cffunction>

<cffunction name="containsBeanDefinition" hint="Check if this bean factory contains a bean definition with the given name.<br/>
		Does not consider any hierarchy this factory may participate in, and ignores any singleton beans that have been registered by other means than bean definitions."
		access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
</cffunction>

<cffunction name="getBeanDefinitionCount" hint="Return the number of beans defined in this bean factory.<br/>Does not consider any hierarchy this factory may participate in."
	access="public" returntype="numeric" output="false">
</cffunction>

<cffunction name="getBeanDefinitionNames" hint="Return the names of all beans defined in this bean factory.<br/>Does not consider any hierarchy this factory may participate in."
			access="public" returntype="array" output="false"
			colddoc:generic="string">
</cffunction>

<cffunction name="getBeanNamesForType" hint="Return the names of beans matching the given type (including subclasses),
			judging from either bean definitions or the value of getObjectType in the case of FactoryBeans.<br/>
			Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized.<br/>
			Does not consider any hierarchy this factory may participate in."
			access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class type" type="string" required="Yes">
</cffunction>

<cffunction name="getBeanNamesForTypeIncludingAncestor" hint="Get all bean names for the given type, including those defined in ancestor factories. Will return unique names in case of overridden bean definitions.<br/>
		    Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized."
	access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class type" type="string" required="Yes">
</cffunction>

<cffunction name="getBeanDefinition" hint="Get a bean definition from the registry. Throws a BeanDefinitionNotFoundException if it doesn't exist.<br/>Does not consider any hierarchy this bean factor may participate in."
	access="public" returntype="coldspring.beans.support.BeanDefinition" output="false">
	<cfargument name="name" hint="the name of the bean definition to get" type="string" required="Yes">
</cffunction>

<cffunction name="getBeanDefinitionIncludingAncestor" hint="Get a bean definition from the registry, including those that may be in an ancesor factory."
	access="public" returntype="coldspring.beans.support.BeanDefinition" output="false">
	<cfargument name="name" hint="the name of the bean definition to get" type="string" required="Yes">
</cffunction>

<cffunction name="getAliases"
	hint="Return the aliases for the given bean name, if any. All of those aliases point to the same bean when used in a getBean(java.lang.String) call.<br/>
	If the given name is an alias, the corresponding original bean name and other aliases (if any) will be returned, with the original bean name being the first element in the array.<br/>
	Will ask the parent factory if the bean cannot be found in this factory instance."
	access="public" returntype="array" output="false">
	<cfargument name="name" hint="name - the bean name to check for aliases " type="string" required="Yes">
</cffunction>

<cffunction name="isAutowireCandidate" hint="Determine whether the specified bean qualifies as an autowire candidate, to be injected into other beans which declare a dependency of matching type/name.<br/>
	This method checks ancestor factories as well. Throws an exception if the bean is not found."
	access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check" type="string" required="Yes">
</cffunction>

<cffunction name="getParentBeanFactory" hint="Returns the parent BeanFactory that can be considered for hierarchical bean factories"
	access="public" returntype="any" output="false">
</cffunction>

<cffunction name="hasParentBeanFactory" hint="whether this bean factory has a parent" access="public" returntype="boolean" output="false">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>