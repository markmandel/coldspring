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

<cfscript>
	reflectionService = getComponentMetaData("coldspring.core.reflect.ReflectionService").singleton.instance;

	//constants
	instance.static = {};

	instance.static.REGISTRY_POST_PROCESSOR_CLASS = reflectionService.loadClass("coldspring.beans.factory.config.BeanDefinitionRegistryPostProcessor");
	instance.static.BEAN_POST_PROCESSOR_CLASS = reflectionService.loadClass("coldspring.beans.factory.config.BeanPostProcessor");
	instance.static.BEAN_FACTORY_POST_PROCESSOR_CLASS = reflectionService.loadClass("coldspring.beans.factory.config.BeanFactoryPostProcessor");
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="BeanDefinitionRegistry" output="false">
	<cfargument name="beanFactory" hint="the containing bean factory" type="coldspring.beans.BeanFactory" required="Yes">
	<cfargument name="beanCache" hint="The actual bean cache. Needed for BeanDefinitions" type="coldspring.beans.factory.BeanCache" required="true">
	<cfscript>
		setReflectionService(getComponentMetadata("coldspring.core.reflect.ReflectionService").singleton.instance);

		setBeanDefinitions(StructNew());
		setTypeNameCache(StructNew());
		setBeanCache(arguments.beanCache);
		setAliasCache(structNew());
		setBeanFactory(arguments.beanFactory);

		if(getBeanFactory().hasParentBeanFactory())
		{
			setParentBeanFactory(getBeanFactory().getParentBeanFactory());
		}

		setRegistryPostProcessorObservable(createObject("component", "coldspring.util.Observable").init());
		setBeanFactoryPostProcessorObservable(createObject("component", "coldspring.util.Observable").init());
		setBeanPostProcessorObservable(createObject("component", "coldspring.beans.factory.config.BeanPostProcessorObservable").init());

		//setup closures
		setCacheNameAgainstTypeClosure(createObject("component", "coldspring.util.Closure").init(cacheNameAgainstType));
		setRemoveNameAgainstTypeClosure(createObject("component", "coldspring.util.Closure").init(removeNameAgainstType));

		getCacheNameAgainstTypeClosure().bind("typeNameCache", getTypeNameCache());
		getRemoveNameAgainstTypeClosure().bind("typeNameCache", getTypeNameCache());

		initDefaultPostProcessors();

		return this;
	</cfscript>
</cffunction>

<cffunction name="registerBeanDefinition" hint="add a bean definition to the registry" access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to add" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var typeNameCache = getTypeNameCache();
		var closure = 0;

		arguments.beanDefinition.configure(this, getBeanCache(), getBeanPostProcessorObservable());

		StructInsert(getBeanDefinitions(), arguments.beanDefinition.getID(), arguments.beanDefinition, true);

		if(arguments.beanDefinition.hasClassName() && getReflectionService().classExists(arguments.beanDefinition.getClassName()))
		{
			closure = getCacheNameAgainstTypeClosure().clone();
			closure.bind("id", arguments.beanDefinition.getID());

			arguments.beanDefinition.$getClass().eachClassInTypeHierarchy(closure);
		}
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinition" hint="Get a bean definition from the registry. Throws a BeanDefinitionNotFoundException if it doesn't exist." access="public" returntype="coldspring.beans.support.BeanDefinition" output="false">
	<cfargument name="name" hint="the name of the bean definition to get" type="string" required="Yes">
	<cfscript>
		var beanDefs = getBeanDefinitions();

		if(StructKeyExists(beanDefs, arguments.name))
		{
			return StructFind(beanDefs, arguments.name);
		}
		else if(isAlias(arguments.name))
		{
			return getBeanDefinition(structFind(getAliasCache(), arguments.name));
		}

		//oops, can't find it.
		createObject("component", "coldspring.beans.exception.BeanDefinitionNotFoundException").init(arguments.name);
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinitionIncludingAncestor" hint="Get a bean definition from the registry, including those that may be in an ancesor factory."
	access="public" returntype="coldspring.beans.support.BeanDefinition" output="false">
	<cfargument name="name" hint="the name of the bean definition to get" type="string" required="Yes">
	<cfscript>
		if(!hasParentBeanFactory() or containsBeanDefinition(argumentCollection=arguments))
		{
			return getBeanDefinition(argumentCollection=arguments);
		}

		return getParentBeanFactory().getBeanDefinitionIncludingAncestor(arguments.name);
    </cfscript>
</cffunction>

<cffunction name="containsBean" hint="Does this bean factory contain a bean with the given name? More specifically, is getBean(java.lang.String) able to obtain a bean instance for the given name?<br/>
	Translates aliases back to the corresponding canonical bean name. Will ask the parent factory if the bean cannot be found in this factory instance. "
	access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
	<cfscript>
		var result = containsBeanDefinition(argumentCollection=arguments);

		if(!result && hasParentBeanFactory())
		{
			return getParentBeanFactory().containsBean(arguments.name);
		}

		return result;
    </cfscript>
</cffunction>

<cffunction name="containsBeanDefinition" hint="Check if this bean factory contains a bean definition with the given name.<br/>
		Does not consider any hierarchy this factory may participate in, and ignores any singleton beans that have been registered by other means than bean definitions."
		access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
	<cfscript>
		var beanDefs = getBeanDefinitions();

		if(StructKeyExists(beanDefs, arguments.name))
		{
			return true;
		}
		else if(isAlias(arguments.name))
		{
			return containsBeanDefinition(structFind(getAliasCache(), arguments.name));
		}

		return false;
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinitionCount" hint="Return the number of beans defined in this bean factory.<br/>Does not consider any hierarchy this factory may participate in."
	access="public" returntype="numeric" output="false">
	<cfreturn structCount(getBeanDefinitions()) />
</cffunction>

<cffunction name="getBeanDefinitionNames" hint="Return the names of all beans defined in this bean factory.<br/>Does not consider any hierarchy this factory may participate in."
			access="public" returntype="array" output="false"
			colddoc:generic="string">
	<cfreturn structKeyArray(getBeanDefinitions()) />
</cffunction>

<cffunction name="removeBeanDefinition" hint="Remove the BeanDefinition for the given name.  Throws a BeanDefinitionNotFoundException if it doesn't exist" access="public" returntype="void" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
	<cfscript>
		var beanDefs = getBeanDefinitions();
		var beanDefinition = getBeanDefinition(arguments.name);
		var closure = 0;

		structDelete(beanDefs, beanDefinition.getID());

		closure = getRemoveNameAgainstTypeClosure().clone();
		closure.bind("id", beanDefinition.getID());

		if(beanDefinition.hasClassName() && getReflectionService().classExists(beanDefinition.getClassName()))
		{
			beanDefinition.$getClass().eachClassInTypeHierarchy(closure);
		}
    </cfscript>
</cffunction>

<cffunction name="getBeanNamesForType" hint="Return the names of beans matching the given type (including subclasses),
			judging from either bean definitions or the value of getObjectType in the case of FactoryBeans.<br/>
			Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized.<br/>
			Does not consider any hierarchy this factory may participate in."
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

<cffunction name="getBeanNamesForTypeIncludingAncestor" hint="Get all bean names for the given type, including those defined in ancestor factories. Will return unique names in case of overridden bean definitions.<br/>
		    Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized."
	access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class type" type="string" required="Yes">
	<cfscript>
		var result = getBeanNamesForType(argumentCollection=arguments);
		if(hasParentBeanFactory())
		{
			result.addAll(getParentBeanFactory().getBeanNamesForTypeIncludingAncestor(arguments.className));
		}

		return result;
    </cfscript>
</cffunction>

<cffunction name="getAliases"
	hint="Return the aliases for the given bean name, if any. All of those aliases point to the same bean when used in a getBean(java.lang.String) call.<br/>
	If the given name is an alias, the corresponding original bean name and other aliases (if any) will be returned, with the original bean name being the first element in the array.<br/>
	Will ask the parent factory if the bean cannot be found in this factory instance."
	access="public" returntype="array" output="false">
	<cfargument name="name" hint="name - the bean name to check for aliases " type="string" required="Yes">
	<cfscript>
		var aliasCache = getAliasCache();
		var alias = 0;
		var aliases = [];
		var id = 0;

		id = arguments.name;

		if(isAlias(id))
		{
			while(!isAlias(arguments.name))
			{
				id = aliasCache[arguments.name];
			}

			arrayAppend(aliases, id);
		}

		/*
			Unlikely to be called very often, so we'll just loop around
		*/

		for(alias in aliasCache)
		{
			if(aliasCache[alias] eq id);
			{
				arrayAppend(aliases, alias);
			}
		}

		//hierarchy support
		if(hasParentBeanFactory())
		{
			aliases.addAll(getParentBeanFactory().getAliases(arguments.name));
		}

		return aliases;
    </cfscript>
</cffunction>

<cffunction name="isAlias" hint="Determine whether this given name is defines as an alias (as opposed to the name of an actually registered component). "
			access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="name - the bean name to check for aliases " type="string" required="Yes">
	<cfscript>
		return structKeyExists(getAliasCache(), arguments.name);
    </cfscript>
</cffunction>

<cffunction name="registerAlias" hint="given the name, register an alias for it" access="public" returntype="void" output="false">
	<cfargument name="name" hint="the bean name of the concrete Bean Definition (Could be an alias, name or id)" type="string" required="Yes">
	<cfargument name="alias" hint="the alias to register - either a simple value, or an array of aliases for this name" type="any" required="Yes">
	<cfscript>
		var local = {};

		if(isSimpleValue(arguments.alias))
		{
			registerAliasSingle(argumentCollection=arguments);
		}
		else
		{
			local.len = ArrayLen(arguments.alias);
            for(local.counter=1; local.counter lte local.len; local.counter++)
            {
				registerAliasSingle(arguments.name, arguments.alias[local.counter]);
            }
		}
    </cfscript>
</cffunction>

<cffunction name="removeAlias" hint="Remove the specified alias from this registry." access="public" returntype="void" output="false">
	<cfargument name="alias" hint="the alias to remove" type="string" required="Yes">
	<cfscript>
		structDelete(getAliasCache(), arguments.alias);
    </cfscript>
</cffunction>

<cffunction name="isAutowireCandidate" hint="Determine whether the specified bean qualifies as an autowire candidate, to be injected into other beans which declare a dependency of matching type/name.<br/>
	This method checks ancestor factories as well. Thrown an exception if the bean is not found"
	access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check" type="string" required="Yes">
	<cfscript>
		if(!hasParentBeanFactory() or containsBeanDefinition(argumentCollection=arguments))
		{
			return getBeanDefinition(argumentCollection=arguments).isAutowireCandidate();
		}

		return getParentBeanFactory().isAutowireCandidate(arguments.name);
    </cfscript>
</cffunction>

<cffunction name="validate" hint="validate all the bean definitions in the Registry. Usually called after notifyCompete()" access="public" returntype="void" output="false">
	<cfscript>
		var beanDefinitions = getBeanDefinitions();
		var id = 0;
		var beanDefinition = 0;

		for(id in beanDefinitions)
		{
			beanDefinition = beanDefinitions[id];

			beanDefinition.validate();
		}
    </cfscript>
</cffunction>

<cffunction name="notifyComplete" hint="Called when all the BeanDefinitions have been added to the registry, and calls notifyComplete() on all BeanDefinitions to allow them to do post processing"
			access="public" returntype="void" output="false">
	<cfscript>
		var beanDefinitions = 0;
		var id = 0;
		var beanDefinition = 0;

		//auto register any registry observers
		autoRegisterRegistryPostProcessors();

		//fire RegistryPost Processor (do this before bean post processors go into effect, as you may need a hook to remove them from the meta)
		getRegistryPostProcessorObservable().postProcessBeanDefinitionRegistry(this);

		//refresh the type cache, as things may have changed behind the scenes without anyone knowing.
		refreshTypeCache();

		//get this here, as it may be different, due to the processors
		beanDefinitions = getBeanDefinitions();

		//notify complete
		for(id in beanDefinitions)
		{
			beanDefinition = beanDefinitions[id];

			beanDefinition.notifyComplete();
		}

		//auto register BeanFactoryPostProcessors
		autoRegisterBeanFactoryPostProcessors();

		getBeanFactoryPostProcessorObservable().postProcessBeanFactory(getBeanFactory());

		//auto register beanProstProcessors
		autoRegisterBeanPostProcessors();
    </cfscript>
</cffunction>

<cffunction name="addBeanPostProcessor" hint="programatically add a bean post processor" access="public" returntype="void" output="false">
	<cfargument name="postProcessor" hint="the post processor in question" type="coldspring.beans.factory.config.BeanPostProcessor" required="Yes">
	<cfset getBeanPostProcessorObservable().addObserver(arguments.postProcessor)>
</cffunction>

<cffunction name="addBeanFactoryPostProcessor" hint="programatically add a beanFactory post processor" access="public" returntype="void" output="false">
	<cfargument name="postProcessor" hint="the post processor in question" type="coldspring.beans.factory.config.BeanFactoryPostProcessor" required="Yes">
	<cfset getBeanFactoryPostProcessorObservable().addObserver(arguments.postProcessor)>
</cffunction>

<cffunction name="getBeanFactory" access="public" returntype="coldspring.beans.BeanFactory" output="false">
	<cfreturn instance.beanFactory />
</cffunction>

<cffunction name="getParentBeanFactory"  hint="Returns the parent BeanFactory that can be considered for hierarchical bean factories"
	access="public" returntype="any" output="false"
	colddoc:generic="BeanFactory">
	<cfreturn instance.parent />
</cffunction>

<cffunction name="hasParentBeanFactory" hint="whether this abstract bean factory has a parent" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "parent") />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initDefaultPostProcessors" hint="Add the default post processors to their appropriate observables" access="private" returntype="void" output="false">
	<cfscript>
		//registry post processors

		//only add it if there are dynamic properties
		if(!structIsEmpty(getBeanFactory().getDynamicProperties()))
		{
			getRegistryPostProcessorObservable().addObserver(createObject("component", "coldspring.beans.factory.DynamicPropertyRegistryPostProcessor").init(getBeanFactory().getDynamicProperties()));
		}

		getRegistryPostProcessorObservable().addObserver(createObject("component", "coldspring.beans.factory.ChildBeanRegistryPostProcessor").init());
		getRegistryPostProcessorObservable().addObserver(createObject("component", "coldspring.beans.factory.FactoryBeanRegistryPostProcessor").init());

		//bean post processors
		addBeanPostProcessor(createObject("component", "coldspring.beans.factory.BeanFactoryAwarePostProcessor").init(getBeanFactory()));
		addBeanPostProcessor(createObject("component", "coldspring.beans.factory.BeanNameAwarePostProcessor").init());
    </cfscript>
</cffunction>

<cffunction name="refreshTypeCache" hint="clear the type cache, and repopulate it with the types from all the beans" access="private" returntype="void" output="false">
	<cfscript>
		var beanDefinitions = getBeanDefinitions();
		var id = 0;
		var beanDefinition = 0;
		var args = 0;
		var closure = getCacheNameAgainstTypeClosure().clone();

		//reset the type name cache
		structClear(getTypeNameCache());

		for(id in beanDefinitions)
		{
			beanDefinition = beanDefinitions[id];

			if(beanDefinition.hasClassName())
			{
				closure.bind("id", beanDefinition.getID());
				beanDefinition.$getClass().eachClassInTypeHierarchy(closure);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="registerAliasSingle" hint="given the name, register an alias for it" access="public" returntype="void" output="false">
	<cfargument name="name" hint="the bean name of the concrete Bean Definition (Could be an alias, name or id)" type="string" required="Yes">
	<cfargument name="alias" hint="the alias to register" type="string" required="Yes">
	<cfscript>
		structInsert(getAliasCache(), arguments.alias, arguments.name, true);
    </cfscript>
</cffunction>

<cffunction name="autoRegisterRegistryPostProcessors" hint="auto register all the BeanRegistry post processors" access="private" returntype="void" output="false">
	<cfscript>
		var beanDefinitions = getBeanDefinitions();
		var id = 0;
		var beanDefinition = 0;
		for (id in beanDefinitions)
		{
			beanDefinition = beanDefinitions[id];

			//check for special marker classes
			if(beanDefinition.hasClassName())
			{
				if(instance.static.REGISTRY_POST_PROCESSOR_CLASS.isAssignableFrom(beanDefinition.getClassName()))
				{
					getRegistryPostProcessorObservable().addObserver(beanDefinition.getInstance());
				}
			}
		}
    </cfscript>
</cffunction>

<cffunction name="autoRegisterBeanFactoryPostProcessors" hint="auto register all the beanfactory post processors" access="private" returntype="void" output="false">
	<cfscript>
		var beanDefinitions = getBeanDefinitions();
		var id = 0;
		var beanDefinition = 0;
		for (id in beanDefinitions)
		{
			beanDefinition = beanDefinitions[id];

			//check for special marker classes
			if(beanDefinition.hasClassName())
			{
				if(instance.static.BEAN_FACTORY_POST_PROCESSOR_CLASS.isAssignableFrom(beanDefinition.getClassName()))
				{
					addBeanFactoryPostProcessor(beanDefinition.getInstance());
				}
			}
		}
    </cfscript>
</cffunction>

<cffunction name="autoRegisterBeanPostProcessors" hint="auto register all the bean post processors" access="private" returntype="void" output="false">
	<cfscript>
		var beanDefinitions = getBeanDefinitions();
		var id = 0;
		var beanDefinition = 0;

		for (id in beanDefinitions)
		{
			beanDefinition = beanDefinitions[id];

			//check for special marker classes
			if(beanDefinition.hasClassName())
			{
				if(instance.static.BEAN_POST_PROCESSOR_CLASS.isAssignableFrom(beanDefinition.getClassName()))
				{
					addBeanPostProcessor(beanDefinition.getInstance());
				}
			}
		}
    </cfscript>
</cffunction>

<!--- closure functions --->
<cffunction name="removeNameAgainstType" hint="closure function for eachInTypeHierarchy that removes the bean name against the class in the type cache" access="private" returntype="void" output="false">
	<cfargument name="class" hint="the class name" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		if(structKeyExists(typeNameCache, arguments.class.getName()))
		{
			typeNameCache[arguments.class.getName()].remove(id);
		}
    </cfscript>
</cffunction>

<cffunction name="cacheNameAgainstType" hint="closure function for eachInTypeHierarchy that caches the bean name against the class the type cache" access="private" returntype="void" output="false">
	<cfargument name="class" hint="the class name" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		if(NOT structKeyExists(typeNameCache, arguments.class.getName()))
		{
			//use an array list for speed and pass by reference.
			structInsert(typeNameCache, arguments.class.getName(), createObject("java", "java.util.ArrayList").init());
		}

		ArrayAppend(typeNameCache[arguments.class.getName()], id);
	</cfscript>
</cffunction>
<!--- /closure functions --->

<cffunction name="getBeanDefinitions" access="private" returntype="struct" output="false"
			colddoc:generic="string,coldspring.beans.support.BeanDefinition">
	<cfreturn instance.beanDefinitions />
</cffunction>

<cffunction name="setBeanDefinitions" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitions" type="struct" required="true" colddoc:generic="string,coldspring.beans.support.BeanDefinition">
	<cfset instance.beanDefinitions = arguments.beanDefinitions />
</cffunction>

<cffunction name="getBeanCache" access="private" returntype="coldspring.beans.factory.BeanCache" output="false">
	<cfreturn instance.beanCache />
</cffunction>

<cffunction name="setBeanCache" access="private" returntype="void" output="false">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" required="true">
	<cfset instance.beanCache = arguments.beanCache />
</cffunction>

<cffunction name="getAliasCache" access="private" returntype="struct" output="false" colddoc:generic="string,string">
	<cfreturn instance.aliasCache />
</cffunction>

<cffunction name="setAliasCache" access="private" returntype="void" output="false">
	<cfargument name="aliasCache" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.aliasCache = arguments.aliasCache />
</cffunction>

<cffunction name="getTypeNameCache" hint="returns a map of class types that match up to arrays of bean names" access="private" returntype="struct" output="false" colddoc:generic="string,array">
	<cfreturn instance.typeNameCache />
</cffunction>

<cffunction name="setTypeNameCache" access="private" returntype="void" output="false" colddoc:generic="string,string">
	<cfargument name="typeNameCache" type="struct" required="true">
	<cfset instance.typeNameCache = arguments.typeNameCache />
</cffunction>

<cffunction name="getRemoveNameAgainstTypeClosure" access="private" returntype="coldspring.util.Closure" output="false">
	<cfreturn instance.removeNameAgainstTypeClosure />
</cffunction>

<cffunction name="setRemoveNameAgainstTypeClosure" access="private" returntype="void" output="false">
	<cfargument name="removeNameAgainstTypeClosure" type="coldspring.util.Closure" required="true">
	<cfset instance.removeNameAgainstTypeClosure = arguments.removeNameAgainstTypeClosure />
</cffunction>

<cffunction name="getCacheNameAgainstTypeClosure" access="private" returntype="coldspring.util.Closure" output="false">
	<cfreturn instance.cacheNameAgainstTypeClosure />
</cffunction>

<cffunction name="setCacheNameAgainstTypeClosure" access="private" returntype="void" output="false">
	<cfargument name="cacheNameAgainstTypeClosure" type="coldspring.util.Closure" required="true">
	<cfset instance.cacheNameAgainstTypeClosure = arguments.cacheNameAgainstTypeClosure />
</cffunction>

<cffunction name="getRegistryPostProcessorObservable" access="private" returntype="coldspring.util.Observable" output="false" colddoc:generic="coldspring.beans.factory.config.BeanDefinitionRegistryPostProcessor">
	<cfreturn instance.registryPostProcessorObservable />
</cffunction>

<cffunction name="setRegistryPostProcessorObservable" access="private" returntype="void" output="false">
	<cfargument name="registryPostProcessorObservable" type="coldspring.util.Observable" required="true" colddoc:generic="coldspring.beans.factory.config.BeanDefinitionRegistryPostProcessor">
	<cfset instance.registryPostProcessorObservable = arguments.registryPostProcessorObservable />
</cffunction>

<cffunction name="getBeanPostProcessorObservable" access="private" returntype="coldspring.beans.factory.config.BeanPostProcessorObservable" output="false"
	colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
	<cfreturn instance.beanPostProcessorObservable />
</cffunction>

<cffunction name="setBeanPostProcessorObservable" access="private" returntype="void" output="false">
	<cfargument name="beanPostProcessorObservable" type="coldspring.beans.factory.config.BeanPostProcessorObservable" required="true" colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
	<cfset instance.beanPostProcessorObservable = arguments.beanPostProcessorObservable />
</cffunction>

<cffunction name="getBeanFactoryPostProcessorObservable" access="private" returntype="coldspring.util.Observable" output="false"
	colddoc:generic="coldspring.beans.factory.config.BeanFactoryPostProcessor">
	<cfreturn instance.BeanFactoryPostProcessorObservable />
</cffunction>

<cffunction name="setBeanFactoryPostProcessorObservable" access="private" returntype="void" output="false">
	<cfargument name="BeanFactoryPostProcessorObservable" type="coldspring.util.Observable" required="true" colddoc:generic="coldspring.beans.factory.config.BeanFactoryPostProcessor">
	<cfset instance.BeanFactoryPostProcessorObservable = arguments.BeanFactoryPostProcessorObservable />
</cffunction>

<cffunction name="setBeanFactory" access="private" returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true">
	<cfset instance.beanFactory = arguments.beanFactory />
</cffunction>

<cffunction name="setParentBeanFactory" access="private" returntype="void" output="false">
	<cfargument name="parent" type="any" required="Yes"
	colddoc:generic="BeanFactory">
	<cfset instance.parent = arguments.parent />
</cffunction>

<cffunction name="getReflectionService" access="private" returntype="coldspring.core.reflect.ReflectionService" output="false">
	<cfreturn instance.reflectionService />
</cffunction>

<cffunction name="setReflectionService" access="private" returntype="void" output="false">
	<cfargument name="reflectionService" type="coldspring.core.reflect.ReflectionService" required="true">
	<cfset instance.reflectionService = arguments.reflectionService />
</cffunction>

</cfcomponent>