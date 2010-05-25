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

<cfcomponent hint="An abstract bean definition for any sort of bean that can be setup in ColdSpring" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getInstance" hint="Returns an instance of the bean this represents. Calls the private method 'create' to create the instance.
									<br/>on notifyComplete, if isAbstract() this gets switched with a method that throws an Exception."
			access="public" returntype="any" output="false">
	<cfscript>
		var local = {};
		var bean = 0;
		var cache = getBeanCache().getCache(getScope());
		var id = getID();
		var completeKey = id & ":complete";
	</cfscript>

	<!---
		The ':complete' key tracks if the beanDef has been fully initialised. This stops outside beans
		picking up a copy before the bean has been fully initialised, even though it is in cache.
	 --->
	<cfif NOT StructKeyExists(cache, id) AND NOT structKeyExists(cache, completeKey)>
    	<cflock name="#getBeanCache().getLockName(this)#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(NOT StructKeyExists(cache, id))
    		{
				bean = create();

				//add it to the cache
				cache[id] = bean;

				/*
					Add it to the cache first, as we may need to
					reconcile a circular dependency.
				*/
				injectPropertyDependencies(bean);

				local.postBean = getBeanPostProcessorObservable().notifyBeforeUpdate(bean, getID());

				if(structKeyExists(local, "postBean"))
				{
					bean = local.postBean;
				}

				if(hasInitMethod())
				{
					invokeInitMethod(bean);
				}

				local.postBean = getBeanPostProcessorObservable().notifyAfterUpdate(bean, getID());

				if(structKeyExists(local, "postBean"))
				{
					bean = local.postBean;
				}

				//replace in cache, in case it was wrapped
				cache[id] = bean;

				//now set it to being truly complete.
				cache[completeKey] = 1;

				//do this here, as prototype scoped beans, have a cache that stores nothing
				return bean;
			}
    	</cfscript>
    	</cflock>
    </cfif>

	<cfscript>
		return cache[id];
    </cfscript>
</cffunction>

<cffunction name="configure" hint="configure after this bean definition has been registered" access="public" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" hint="the bean definition registry this belongs to" type="coldspring.beans.BeanDefinitionRegistry" required="Yes">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" hint="The bean cache" required="true">
	<cfargument name="beanPostProcessorObservable" hint="the observable collection for bean post processing" type="coldspring.beans.factory.config.BeanPostProcessorObservable" required="Yes" colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
	<cfscript>
		setBeanDefinitionRegistry(arguments.beanDefinitionRegistry);
		setBeanCache(arguments.beanCache);
		setBeanPostProcessorObservable(arguments.beanPostProcessorObservable);
    </cfscript>
</cffunction>

<cffunction name="overrideFrom" hint="Override settings in this bean definition (assumably a copied parent from a parent-child inheritance relationship) from the given bean definition (assumably the child).
			<br/>
			* Will override className if specified in the given bean definition.<br/>
	        * Will always take abstract, scope, lazyInit, autowireMode, from the given bean definition.<br/>
	        * Will add constructorArguments, properties, from the given bean definition to existing ones.<br/>
	        * Will override factoryBeanName, factoryMethodName, and initMethodName if specified in the given bean definition.<br/>
			* Will override meta data, if it exists"

	access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to overwrite with" type="AbstractBeanDefinition" required="Yes">
	<cfscript>
		var len = 0;
		var counter = 0;
		var item = 0;
		var values = 0;

		if(arguments.beanDefinition.hasClassName())
		{
			setClassName(arguments.beanDefinition.getClassName());
		}

		setAbstract(arguments.beanDefinition.isAbstract());
		setScope(arguments.beanDefinition.getScope());
		setLazyInit(arguments.beanDefinition.isLazyInit());
		setAutowire(arguments.beanDefinition.getAutowire());

		if(!structIsEmpty(arguments.beanDefinition.getMeta()))
		{
			setMeta(arguments.beanDefinition.getMeta());
		}

		values = arguments.beanDefinition.getConstructorArgsAsArray();
		len = arrayLen(values);
		for(counter = 1; counter <= len; counter++)
		{
			item = values[counter];
			addConstructorArg(item);
		}

		values = arguments.beanDefinition.getPropertiesAsArray();
		len = arrayLen(values);
		for(counter = 1; counter <= len; counter++)
		{
			item = values[counter];
			addProperty(item);
		}

		if(arguments.beanDefinition.hasFactoryBeanName())
		{
			setFactoryBeanName(arguments.beanDefinition.getFactoryBeanName());
		}

		if(arguments.beanDefinition.hasFactoryMethodName())
		{
			setFactoryMethodName(arguments.beanDefinition.getFactoryMethodName());
		}

		if(arguments.beanDefinition.hasInitMethod())
		{
			setInitMethod(arguments.beanDefinition.getInitMethod());
		}
    </cfscript>
</cffunction>

<cffunction name="notifyComplete" hint="Called when all the beans are added to the Factory, and post processing can occur." access="public" returntype="void" output="false">
	<cfscript>
		buildAutowire();
		buildGetInstance();
    </cfscript>
</cffunction>

<cffunction name="validate" hint="Validates the structure of this bean, throws an exception if it is invalid" access="public" returntype="void" output="false">
	<cfscript>
		//if has factory-method, or factory-bean, must have the other
		if(hasFactoryBeanName() neq hasFactoryMethodName())
		{
			createObject("component", "coldspring.beans.support.exception.BeanDefinitionValidationException").init(this, "factory-bean and factory-method attriutes must be set together.");
		}

		if(NOT (hasFactoryBeanName() AND hasFactoryMethodName()) AND NOT hasClassName())
		{
			createObject("component", "coldspring.beans.support.exception.BeanDefinitionValidationException").init(this, "If no factory-bean has been specified, a bean must have a class.");
		}
    </cfscript>
</cffunction>

<cffunction name="getID" access="public" returntype="string" output="false">
	<cfreturn instance.id />
</cffunction>

<cffunction name="setID" access="public" returntype="void" output="false">
	<cfargument name="id" type="string" required="true">
	<cfset instance.id = arguments.id />
</cffunction>

<cffunction name="getClassName" access="public" returntype="any" output="false">
	<cfreturn instance.class />
</cffunction>

<cffunction name="setClassName" access="public" returntype="void" output="false">
	<cfargument name="class" type="any" required="true">
	<cfset instance.class = arguments.class />
</cffunction>

<cffunction name="hasClassName" hint="whether this object has a class name" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "class") />
</cffunction>

<cffunction name="getScope" access="public" returntype="string" output="false">
	<cfreturn instance.scope />
</cffunction>

<cffunction name="setScope" access="public" hint="bean scope, singleton, prototype, request, session" returntype="void" output="false">
	<cfargument name="scope" type="string" required="true">

	<cfif NOT ListFindNoCase("singleton,prototype,request,session", arguments.scope)>
		<cfset createObject("component", "coldspring.beans.support.exception.InvalidBeanScopeException").init(arguments.scope)>
	</cfif>

	<cfset instance.scope = arguments.scope />
</cffunction>

<cffunction name="getAutowire" access="public" returntype="string" output="false">
	<cfreturn instance.autowire />
</cffunction>

<cffunction name="setAutowire" hint="The method to use when autowiring, no, byName, byType" access="public" returntype="void" output="false">
	<cfargument name="autowire" type="string" required="true">
	<cfset instance.autowire = arguments.autowire />
	<cfif NOT ListFindNoCase("no,byName,byType", arguments.autowire)>
		<cfset createObject("component", "coldspring.beans.support.exception.InvalidAutowireTypeException").init(arguments.autowire)>
	</cfif>
</cffunction>

<cffunction name="isLazyInit" access="public" returntype="boolean" output="false">
	<cfreturn instance.lazyInit />
</cffunction>

<cffunction name="setLazyInit" access="public" returntype="void" output="false">
	<cfargument name="lazyInit" type="boolean" required="true">
	<cfset instance.lazyInit = arguments.lazyInit />
</cffunction>

<cffunction name="getInitMethod" access="public" hint="Get the name of the custom initialization method to invoke after setting bean properties." returntype="string" output="false">
	<cfreturn instance.initMethod />
</cffunction>

<cffunction name="setInitMethod" access="public" hint="Set the name of the custom initialization method to invoke after setting bean properties." returntype="void" output="false">
	<cfargument name="initMethod" type="string" required="true">
	<cfset instance.initMethod = arguments.initMethod />
</cffunction>

<cffunction name="hasInitMethod" hint="whether this object has a init-method" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "initMethod") />
</cffunction>

<cffunction name="removeInitMethod" hint="removes the init method set on this bean definition" access="public" returntype="void" output="false">
	<cfset structDelete(instance, "initMethod")>
</cffunction>

<cffunction name="getConstructorArgs" hint="constructor argument dependencies" access="public" returntype="struct" output="false"
	colddoc:generic="string,ConstructorArg">
	<cfreturn instance.constructorArgs />
</cffunction>

<cffunction name="getConstructorArgsAsArray" hint="returns the constructor args as an array, for convenience" access="public" returntype="array" output="false"
			colddoc:generic="ConstructorArg">
	<cfreturn createObject("java", "java.util.ArrayList").init(getConstructorArgs().values()) />
</cffunction>

<cffunction name="hasConstructorArgsByName" hint="a check to see if a constructor arg with the given name exists" access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the constructor arg" type="string" required="Yes">
	<cfreturn structKeyExists(getConstructorArgs(), arguments.name) />
</cffunction>

<cffunction name="addConstructorArg" hint="adds a constructor argument dependency."
			access="public" returntype="void" output="false">
	<cfargument name="constructorArg" type="coldspring.beans.support.ConstructorArg" required="true" />
	<cfset structInsert(getConstructorArgs(), arguments.constructorArg.getName(), arguments.constructorArg, true) />
</cffunction>

<cffunction name="getPropertiesAsArray" hint="returns the properties as an array, for convenience" access="public" returntype="array" output="false"
			colddoc:generic="Property">
	<cfreturn createObject("java", "java.util.ArrayList").init(getProperties().values()) />
</cffunction>

<cffunction name="getProperties" access="public" returntype="struct" output="false"
			colddoc:generic="string,Property">
	<cfreturn instance.properties />
</cffunction>

<cffunction name="addProperty" hint="adds a property dependency."
			access="public" returntype="void" output="false">
	<cfargument name="property" type="coldspring.beans.support.Property" required="true" />
	<cfset structInsert(getProperties(), arguments.property.getName(), arguments.property, true) />
</cffunction>

<cffunction name="hasPropertyByName" hint="a check to see if a property with the given name exists" access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the property" type="string" required="Yes">
	<cfreturn structKeyExists(getProperties(), arguments.name) />
</cffunction>

<cffunction name="isAbstract" access="public" returntype="boolean" output="false">
	<cfreturn instance.Abstract />
</cffunction>

<cffunction name="setAbstract" hint="Set the bean to not being able to be instantiated." access="public" returntype="void" output="false">
	<cfargument name="Abstract" type="boolean" required="true">
	<cfset instance.Abstract = arguments.Abstract />
</cffunction>

<cffunction name="getFactoryBeanName" access="public" returntype="string" output="false">
	<cfreturn instance.factoryBeanName />
</cffunction>

<cffunction name="setFactoryBeanName" access="public" returntype="void" output="false">
	<cfargument name="factoryBeanName" type="string" required="true">
	<cfset instance.factoryBeanName = arguments.factoryBeanName />
</cffunction>

<cffunction name="hasFactoryBeanName" hint="whether this object has a factoryBeanName" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "factoryBeanName") />
</cffunction>

<cffunction name="getFactoryMethodName" access="public" returntype="string" output="false">
	<cfreturn instance.factoryMethodName />
</cffunction>

<cffunction name="setFactoryMethodName" access="public" returntype="void" output="false">
	<cfargument name="factoryMethodName" type="string" required="true">
	<cfset instance.factoryMethodName = arguments.factoryMethodName />
</cffunction>

<cffunction name="hasFactoryMethodName" hint="whether this object has a factoryMethodName" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "factoryMethodName") />
</cffunction>

<cffunction name="getParentName" hint="Return the name of the parent definition of this bean definition" access="public" returntype="string" output="false">
	<cfreturn instance.parentName />
</cffunction>

<cffunction name="setParentName" hint="Set the name of the parent definition of this bean definition" access="public" returntype="void" output="false">
	<cfargument name="parentName" type="string" required="true">
	<cfset instance.parentName = arguments.parentName />
</cffunction>

<cffunction name="hasParentName" hint="whether this object has a parentName" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "parentName") />
</cffunction>

<cffunction name="isAutowireCandidate" access="public" returntype="boolean" output="false">
	<cfreturn instance.isAutowireCandidate />
</cffunction>

<cffunction name="setAutowireCandidate" access="public" returntype="void" output="false">
	<cfargument name="isAutowireCandidate" type="boolean" required="true">
	<cfset instance.isAutowireCandidate = arguments.isAutowireCandidate />
</cffunction>


<cffunction name="getMeta" hint="Return custom object meta data" access="public" returntype="struct" output="false"
			colddoc:generic="string,string">
	<cfreturn instance.meta />
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="AbstractBeanDefinition" output="false">
	<cfscript>
		var cloneable = createObject("component", "coldspring.util.Cloneable").init();

		return cloneable.clone(this);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="AbstractBeanDefinition" output="false">
	<cfargument name="id" hint="the id of this bean" type="string" required="Yes">
	<cfscript>
		setID(arguments.id);
		setScope("singleton");
		setAutowire("no");
		setLazyInit(false);
		setAutowireComplete(false);
		setConstructorArgs(StructNew());
		setProperties(StructNew());
		setAbstract(false);
		setMeta(structNew());
		setAutowireCandidate(true);

		return this;
	</cfscript>
</cffunction>

<cffunction name="buildAutowire" hint="construct all the required meta that needs to be built around this BeanDefinition" access="private" returntype="void" output="false">
	<cfif NOT isAutowireComplete()>
    	<cflock name="coldspring.beans.support.abstractBeanDefinition.buildAutowire.#getID()#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(NOT isAutowireComplete())
    		{
				if(getAutowire() neq "no")
				{
					autowire();
				}

				setAutowireComplete(true);
			}
    	</cfscript>
    	</cflock>
	</cfif>
</cffunction>

<cffunction name="buildGetInstance" hint="applies the appropriate mixin to getInstance() to control what how the instance is created" access="private" returntype="void" output="false">
	<cfscript>
		var methodInjector = 0;

		if(isAbstract())
		{
			methodInjector = createObject("component", "coldspring.util.MethodInjector").init();

			methodInjector.start(this);
			methodInjector.injectMethod(this, getInstance_Abstract, "public", "getInstance");
			methodInjector.stop(this);
		}
    </cfscript>
</cffunction>

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		arguments.instance.constructorArgs = arguments.cloneable.cloneStruct(arguments.instance.constructorArgs);
		arguments.instance.properties = arguments.cloneable.cloneStruct(arguments.instance.properties);
		arguments.instance.meta = duplicate(arguments.instance.meta);

		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<!--- abstract methods --->

<cffunction name="autowire" hint="abstract method: autowires the given beanReference type with it's dependencies, depending on the autowire type" access="private" returntype="void" output="false">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("autowire", this)>
</cffunction>

<cffunction name="create" hint="vitual method: creates the object intsance" access="private" returntype="any" output="false">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("create", this)>
</cffunction>

<cffunction name="injectPropertyDependencies" hint="abstract method: inject all the properpty values into the given bean" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean to inject the properties into" type="any" required="Yes">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("injectPropertyDependencies", this)>
</cffunction>

<cffunction name="invokeInitMethod" hint="invoke the init method specified" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean created from this beanDefinition" type="any" required="Yes">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("invokeInitMethod", this)>
</cffunction>

<!--- /abstract methods --->

<!--- mixins --->

<cffunction name="getInstance_Abstract" hint="Mixin: method to be used to switch with getInstance, if isAbstract is set to true, on notifyComplete()"
			access="private" returntype="any" output="false">
	<cfscript>
		createObject("component", "coldspring.beans.support.exception.AbstractBeanCannotBeInstantiatedException").init(this);
    </cfscript>
</cffunction>

<!--- /mixins --->

<cffunction name="setConstructorArgs" access="private" returntype="void" output="false">
	<cfargument name="constructorArgs" type="struct" required="true" colddoc:generic="string,ConstructorArg">
	<cfset instance.constructorArgs = arguments.constructorArgs />
</cffunction>

<cffunction name="setProperties" access="private" returntype="void" output="false">
	<cfargument name="properties" type="struct" required="true" colddoc:generic="string,Property">
	<cfset instance.properties = arguments.properties />
</cffunction>

<cffunction name="isAutowireComplete" access="private" returntype="boolean" output="false">
	<cfreturn instance.isAutowireComplete />
</cffunction>

<cffunction name="setAutowireComplete" access="private" returntype="void" output="false">
	<cfargument name="isAutowireComplete" type="boolean" required="true">
	<cfset instance.isAutowireComplete = arguments.isAutowireComplete />
</cffunction>

<cffunction name="getBeanCache" access="private" returntype="coldspring.beans.factory.BeanCache" output="false">
	<cfreturn instance.beanCache />
</cffunction>

<cffunction name="getBeanDefinitionRegistry" access="private" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn instance.beanDefinitionRegistry />
</cffunction>

<cffunction name="setBeanCache" hint="Set the bean cache." access="private" returntype="void" output="false">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" required="true">
	<cfset instance.beanCache = arguments.beanCache />
</cffunction>

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

<cffunction name="setMeta" access="private" returntype="void" output="false">
	<cfargument name="Meta" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.Meta = arguments.Meta />
</cffunction>

<cffunction name="getBeanPostProcessorObservable" access="private" returntype="coldspring.beans.factory.config.BeanPostProcessorObservable" output="false"
	colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
	<cfreturn instance.beanPostProcessorObservable />
</cffunction>

<cffunction name="setBeanPostProcessorObservable" access="private" returntype="void" output="false">
	<cfargument name="beanPostProcessorObservable" type="coldspring.beans.factory.config.BeanPostProcessorObservable" required="true" colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
	<cfset instance.beanPostProcessorObservable = arguments.beanPostProcessorObservable />
</cffunction>

</cfcomponent>