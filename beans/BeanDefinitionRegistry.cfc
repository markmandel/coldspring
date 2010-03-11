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

<cfcomponent hint="Registry for all the bean Definitions" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanDefinitionRegistry" output="false">
	<cfargument name="beanCache" hint="The actual bean cache. Needed for AbstractBeanDefinitions" type="coldspring.beans.factory.BeanCache" required="true">
	<cfscript>
		setBeanDefinitions(StructNew());
		setTypeNameCache(StructNew());
		setBeanCache(arguments.beanCache);

		return this;
	</cfscript>
</cffunction>

<cffunction name="registerBeanDefinition" hint="add a bean definition to the registry" access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to add" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		arguments.beanDefinition.setBeanCache(getBeanCache());

		StructInsert(getBeanDefinitions(), arguments.beanDefinition.getID(), arguments.beanDefinition, true);
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinition" hint="Get a bean definition from the registry. Throws a BeanDefinitionNotFoundException if it doesn't exist." access="public" returntype="coldspring.beans.support.AbstractBeanDefinition" output="false">
	<cfargument name="id" hint="the id of the bean definition to get" type="string" required="Yes">
	<cfscript>
		var beanDefs = getBeanDefinitions();

		if(NOT StructKeyExists(beanDefs, arguments.id))
		{
			createObject("component", "coldspring.beans.exception.BeanDefinitionNotFoundException").init(arguments.id);
		}

		return StructFind(beanDefs, arguments.id);
    </cfscript>
</cffunction>

<cffunction name="containsBeanDefinition" hint="Returns true if a bean definition exists" access="public" returntype="boolean" output="false">
	<cfargument name="id" hint="the id of the bean to check for" type="string" required="Yes" />
	<cfscript>
		var beanDefs = getBeanDefinitions();

		if(StructKeyExists(beanDefs, arguments.id))
		{
			return true;
		}

		return false;
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinitionCount" hint="Return the number of beans defined in the registry." access="public" returntype="numeric" output="false">
	<cfreturn structCount(getBeanDefinitions()) />
</cffunction>

<cffunction name="getBeanDefinitionNames" hint="Return the names of all beans defined in this registry" access="public" returntype="array" output="false"
			colddoc:generic="string">
	<cfreturn structKeyArray(getBeanDefinitions()) />
</cffunction>

<cffunction name="removeBeanDefinition" hint="Remove the BeanDefinition for the given name.  Throws a BeanDefinitionNotFoundException if it doesn't exist" access="public" returntype="void" output="false">
	<cfargument name="id" hint="the name of the bean to check for" type="string" required="Yes" />
	<cfscript>
		var beanDefs = getBeanDefinitions();

		if(NOT StructKeyExists(beanDefs, arguments.id))
		{
			createObject("component", "coldspring.beans.exception.BeanDefinitionNotFoundException").init(arguments.id);
		}

		structDelete(beanDefs, arguments.id);
    </cfscript>
</cffunction>

<!---
 String[] 	getBeanNamesForType(Class type, boolean includeNonSingletons, boolean allowEagerInit)
          Return the names of beans matching the given type (including subclasses), judging from either bean definitions or the value of getObjectType in the case of FactoryBeans.

		  Note: have a BeanTypeCache that stores names against types in an array.
		  When adding a new BeanDefinition, get the MetaData, and loop up the inheritene tree, and set all the types found to that particular name
		  that way it's easy to go up the tree.

		  removing will be more fun, as you will have to do the same thing.  May want to do an eachClassInInheritence(class, callback)
 --->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getBeanDefinitions" access="private" returntype="struct" output="false"
			colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfreturn instance.beanDefinitions />
</cffunction>

<cffunction name="setBeanDefinitions" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitions" type="struct" required="true" colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfset instance.beanDefinitions = arguments.beanDefinitions />
</cffunction>

<cffunction name="getBeanCache" access="private" returntype="coldspring.beans.factory.BeanCache" output="false">
	<cfreturn instance.beanCache />
</cffunction>

<cffunction name="setBeanCache" access="private" returntype="void" output="false">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" required="true">
	<cfset instance.beanCache = arguments.beanCache />
</cffunction>

<cffunction name="getTypeNameCache" hint="returns a map of class types that match up to arrays of bean names" access="private" returntype="struct" output="false" colddoc:generic="string,array">
	<cfreturn instance.typeNameCache />
</cffunction>
<cffunction name="setTypeNameCache" access="private" returntype="void" output="false" colddoc:generic="string,string">
	<cfargument name="typeNameCache" type="struct" required="true">
	<cfset instance.typeNameCache = arguments.typeNameCache />
</cffunction>


</cfcomponent>