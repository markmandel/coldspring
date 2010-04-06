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
	//constants
	instance.static = {};

	instance.static.REGISTRY_POST_PROCESSOR_CLASS = "coldspring.beans.BeanDefinitionRegistryPostProcessor";
	instance.static.BEAN_POST_PROCESSOR_CLASS = "coldspring.beans.factory.config.BeanPostProcessor";
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="BeanDefinitionRegistry" output="false">
	<cfargument name="beanCache" hint="The actual bean cache. Needed for AbstractBeanDefinitions" type="coldspring.beans.factory.BeanCache" required="true">
	<cfscript>
		setBeanDefinitions(StructNew());
		setTypeNameCache(StructNew());
		setBeanCache(arguments.beanCache);

		setCFCMetaUtil(createObject("component", "coldspring.util.CFCMetaUtil").init());

		setRegistryPostProcessorObservable(createObject("component", "coldspring.util.Observable").init());
		setBeanPostProcessorObservable(createObject("component", "coldspring.beans.factory.config.BeanPostProcessObservable").init());

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
	<cfargument name="beanDefinition" hint="the bean definition to add" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var typeNameCache = getTypeNameCache();
		var args = {id = arguments.beanDefinition.getID()};

		arguments.beanDefinition.configure(this, getBeanCache(), getBeanPostProcessorObservable());

		StructInsert(getBeanDefinitions(), arguments.beanDefinition.getID(), arguments.beanDefinition, true);

		if(arguments.beanDefinition.hasClassName())
		{
			getCFCMetaUtil().eachClassInTypeHierarchy(arguments.beanDefinition.getClassName(), getCacheNameAgainstTypeClosure(), args);
		}
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

		getCFCMetaUtil().eachClassInTypeHierarchy(beanDefinition.getClassName(), getRemoveNameAgainstTypeClosure(), args);
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

<cffunction name="notifyComplete" hint="Called when all the BeanDefinitions have been added to the registry, and calls notifyComplete() on all AbstractBeanDefinitions to allow them to do post processing"
			access="public" returntype="void" output="false">
	<cfscript>
		var beanDefinitions = 0;
		var id = 0;
		var beanDefinition = 0;

		//set up post processors
		autoRegisterObservers();

		//fire RegistryPost Processor
		getRegistryPostProcessorObservable().postProcessBeanDefinitionRegistry(this);

		//get this here, as it may be different, do to the processors
		beanDefinitions = getBeanDefinitions();

		//notify complete
		for(id in beanDefinitions)
		{
			beanDefinition = beanDefinitions[id];

			beanDefinition.notifyComplete();
		}
    </cfscript>
</cffunction>

<cffunction name="addBeanPostProcessor" hint="programatically add a bean post processor" access="public" returntype="void" output="false">
	<cfargument name="postProcessor" hint="the post processor in question" type="coldspring.beans.factory.config.BeanPostProcessor" required="Yes">
	<cfset getBeanPostProcessorObservable().addObserver(arguments.postProcessor)>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initDefaultPostProcessors" hint="Add the default post processors to their appropriate observables" access="private" returntype="void" output="false">
	<cfscript>
		//registry post processors
		getRegistryPostProcessorObservable().addObserver(createObject("component", "coldspring.beans.factory.FactoryBeanRegistryPostProcessor").init());

		//bean post processors
		addBeanPostProcessor(createObject("component", "coldspring.beans.factory.BeanNameAwarePostProcessor").init());
    </cfscript>
</cffunction>

<cffunction name="autoRegisterObservers" hint="auto register all the observer bean definitions in the registry" access="private" returntype="void" output="false">
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
				if(getCFCMetaUtil().isAssignableFrom(beanDefinition.getClassName(), instance.static.REGISTRY_POST_PROCESSOR_CLASS))
				{
					getRegistryPostProcessorObservable().addObserver(beanDefinition.getInstance());
				}

				if(getCFCMetaUtil().isAssignableFrom(beanDefinition.getClassName(), instance.static.BEAN_POST_PROCESSOR_CLASS))
				{
					addBeanPostProcessor(beanDefinition.getInstance());
				}
			}
		}
    </cfscript>
</cffunction>

<!--- closure functions --->
<cffunction name="removeNameAgainstType" hint="closure function for eachInTypeHierarchy that removes the bean name against the class in the type cache" access="private" returntype="void" output="false">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfargument name="id" hint="the bean definition id" type="string" required="Yes">
	<cfscript>
		if(structKeyExists(typeNameCache, arguments.className))
		{
			typeNameCache[arguments.className].remove(arguments.id);
		}
    </cfscript>
</cffunction>

<cffunction name="cacheNameAgainstType" hint="closure function for eachInTypeHierarchy that caches the bean name against the class the type cache" access="private" returntype="void" output="false">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfargument name="id" hint="the bean definition id" type="string" required="Yes">
	<cfscript>
		if(NOT structKeyExists(typeNameCache, arguments.className))
		{
			//use an array list for speed and pass by reference.
			structInsert(typeNameCache, arguments.className, createObject("java", "java.util.ArrayList").init());
		}

		ArrayAppend(typeNameCache[className], arguments.id);
	</cfscript>
</cffunction>
<!--- /closure functions --->

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

<cffunction name="getCFCMetaUtil" access="private" returntype="coldspring.util.CFCMetaUtil" output="false">
	<cfreturn instance.cfcMetaUtil />
</cffunction>

<cffunction name="setCFCMetaUtil" access="private" returntype="void" output="false">
	<cfargument name="cfcMetaUtil" type="coldspring.util.CFCMetaUtil" required="true">
	<cfset instance.cfcMetaUtil = arguments.cfcMetaUtil />
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

<cffunction name="getRegistryPostProcessorObservable" access="private" returntype="coldspring.util.Observable" output="false" colddoc:generic="coldspring.beans.BeanDefinitionRegistryPostProcessor">
	<cfreturn instance.registryPostProcessorObservable />
</cffunction>

<cffunction name="setRegistryPostProcessorObservable" access="private" returntype="void" output="false">
	<cfargument name="registryPostProcessorObservable" type="coldspring.util.Observable" required="true" colddoc:generic="coldspring.beans.BeanDefinitionRegistryPostProcessor">
	<cfset instance.registryPostProcessorObservable = arguments.registryPostProcessorObservable />
</cffunction>

<cffunction name="getBeanPostProcessorObservable" access="private" returntype="coldspring.beans.factory.config.BeanPostProcessObservable" output="false"
	colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
	<cfreturn instance.beanPostProcessorObservable />
</cffunction>

<cffunction name="setBeanPostProcessorObservable" access="private" returntype="void" output="false">
	<cfargument name="beanPostProcessorObservable" type="coldspring.beans.factory.config.BeanPostProcessObservable" required="true" colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
	<cfset instance.beanPostProcessorObservable = arguments.beanPostProcessorObservable />
</cffunction>

</cfcomponent>