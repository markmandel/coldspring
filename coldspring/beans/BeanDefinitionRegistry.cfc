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
		var typeNameCache = getTypeNameCache();
		var args = {id = arguments.beanDefinition.getID()};

		arguments.beanDefinition.setBeanCache(getBeanCache());

		StructInsert(getBeanDefinitions(), arguments.beanDefinition.getID(), arguments.beanDefinition, true);

		eachClassInTypeHierarchy(arguments.beanDefinition.getClassName(), cacheNameAgainstType, args);
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
		var beanDefinition = getBeanDefinition(arguments.id);
		var args = {id = beanDefinition.getID()};

		structDelete(beanDefs, arguments.id);

		eachClassInTypeHierarchy(beanDefinition.getClassName(), removeNameAgainstType, args);
    </cfscript>
</cffunction>

<cffunction name="getBeanNamesForType" hint="Return the names of beans matching the given type (including subclasses),
			judging from either bean definitions or the value of getObjectType in the case of FactoryBeans.<br/>
			<br/><strong>NOTE: This method introspects top-level beans only.</strong> It does not  check nested beans which might match the specified type as well.<br/>
			Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized. If the object created by the FactoryBean doesn't match, the raw FactoryBean itself will be matched against the type.
			"
			access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class type" type="string" required="Yes">
	<cfscript>
		var typeNameCache = getTypeNameCache();
		if(structKeyExists(typeNameCache, arguments.className))
		{
			return typeNameCache[arguments.className];
		}

		return arrayNew(1);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- Wrap this into a coldpsring.util.Class library?  --->
<cffunction name="eachClassInTypeHierarchy" hint="Calls the callback for each class type in inheritence, and also for each interface it implements" access="private" returntype="void" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfargument name="callback" hint="the callback to fire for each class type found a" type="any" required="Yes">
	<cfargument name="args" hint="optional arguments to also pass through to the callback" type="struct" required="No" default="#structNew()#">
	<cfscript>
		var meta = getComponentMetadata(arguments.className);
		var call = arguments.callback;
		var local = {};

		while(structKeyExists(meta, "extends"))
		{
			arguments.args.className = meta.name;
			call(argumentCollection=arguments.args);

			if(structKeyExists(meta, "implements"))
			{
				local.implements = meta.implements;

				for(local.key in local.implements)
				{
					local.imeta = local.implements[local.key];

					arguments.args.className = local.imeta.name;
					call(argumentCollection=arguments.args);

					while(structKeyExists(local.imeta, "extends"))
					{
						//this is here because extends on interfaces goes extends[classname];
						local.imeta = local.imeta.extends[structKeyList(local.imeta.extends)];

						arguments.args.className = local.imeta.name;
						call(argumentCollection=arguments.args);
					}
				}
			}

			meta = meta.extends;
		}
    </cfscript>
</cffunction>

<cffunction name="removeNameAgainstType" hint="callback for eachInTypeHierarchy that removes the bean name against the class in the type cache" access="private" returntype="void" output="false">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfargument name="id" hint="the bean definition id" type="string" required="Yes">
	<cfscript>
		var typeNameCache = getTypeNameCache();

		if(structKeyExists(typeNameCache, arguments.className))
		{
			typeNameCache[arguments.className].remove(arguments.id);
		}
    </cfscript>
</cffunction>

<cffunction name="cacheNameAgainstType" hint="callback for eachInTypeHierarchy that caches the bean name against the class the type cache" access="private" returntype="void" output="false">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfargument name="id" hint="the bean definition id" type="string" required="Yes">
	<cfscript>
		var typeNameCache = getTypeNameCache();

		if(NOT structKeyExists(typeNameCache, arguments.className))
		{
			//use an array list for speed and pass by reference.
			structInsert(typeNameCache, arguments.className, createObject("java", "java.util.ArrayList").init());
		}

		ArrayAppend(typeNameCache[className], arguments.id);
	</cfscript>
</cffunction>

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