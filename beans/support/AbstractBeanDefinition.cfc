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

<cffunction name="getInstance" hint="Returns an instance of the bean this represents. Calls the private method 'create' to create the instance, and autowire() to autowire"
			access="public" returntype="any" output="false"
			colddoc:abstract="true"
			>
	<cfscript>
		var bean = 0;
		var cache = getBeanCache().getCache(getScope());
		var id = getID();

		if(isAbstract())
		{
			createObject("component", "coldspring.beans.support.exception.AbstractBeanCannotBeInstantiatedException").init(this);
		}

		/*
		make sure the meta data is complete
		we do this here, because its only place we
		can guarentee the autowire mode is going to have
		been stopped being fiddled with.
		*/
		if(NOT isAutowireComplete())
		{
			buildAutowire();
		}
	</cfscript>

	<cfif NOT StructKeyExists(cache, getID())>
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
			}
    	</cfscript>
    	</cflock>
    </cfif>

	<cfscript>
		return cache[id];
    </cfscript>
</cffunction>

<cffunction name="getID" access="public" returntype="string" output="false">
	<cfreturn instance.id />
</cffunction>

<cffunction name="getClassName" access="public" returntype="any" output="false">
	<cfreturn instance.class />
</cffunction>

<cffunction name="setClassName" access="public" returntype="void" output="false">
	<cfargument name="class" type="any" required="true">
	<cfset instance.class = arguments.class />
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

<cffunction name="getInitMethod" access="public" returntype="string" output="false">
	<cfreturn instance.initMethod />
</cffunction>

<cffunction name="setInitMethod" access="public" returntype="void" output="false">
	<cfargument name="initMethod" type="string" required="true">
	<cfset instance.initMethod = arguments.initMethod />
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
	<cfset structInsert(getConstructorArgs(), arguments.constructorArg.getName(), arguments.constructorArg, false) />
</cffunction>

<cffunction name="getPropertiesAsArray" hint="retursn the properties as an array, for convenience" access="public" returntype="array" output="false"
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
	<cfset structInsert(getProperties(), arguments.property.getName(), arguments.property) />
</cffunction>

<cffunction name="hasPropertyByName" hint="a check to see if a property with the given name exists" access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the property" type="string" required="Yes">
	<cfreturn structKeyExists(getProperties(), arguments.name) />
</cffunction>

<cffunction name="setBeanCache" hint="Set the bean cache. Gets called when being added to an AbstractBeanFactory" access="public" returntype="void" output="false">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" required="true">
	<cfset instance.beanCache = arguments.beanCache />
</cffunction>

<cffunction name="isAbstract" access="public" returntype="boolean" output="false">
	<cfreturn instance.Abstract />
</cffunction>

<cffunction name="setAbstract" hint="Set the bean to not being able to be instantiated." access="public" returntype="void" output="false">
	<cfargument name="Abstract" type="boolean" required="true">
	<cfset instance.Abstract = arguments.Abstract />
</cffunction>

<cffunction name="getMeta" hint="Return custom object meta data" access="public" returntype="struct" output="false"
			colddoc:generic="string,string">
	<cfreturn instance.Meta />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="AbstractBeanDefinition" output="false">
	<cfargument name="id" hint="the id of this bean" type="string" required="Yes">
	<cfargument name="class" hint="the class of this bean" type="string" required="Yes">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfscript>
		setID(arguments.id);
		setClassName(arguments.class);
		setBeanDefinitionRegistry(arguments.beanDefinitionRegistry);
		setScope("singleton");
		setAutowire("no");
		setLazyInit(false);
		setInitMethod("");
		setAutowireComplete(false);
		setConstructorArgs(StructNew());
		setProperties(StructNew());
		setAbstract(false);
		setMeta(structNew());

		return this;
	</cfscript>
</cffunction>

<cffunction name="buildAutowire" hint="construct all the required meta that needs to be built around this BeanDefinition" access="private" returntype="void" output="false">
		<!--- don't double check, as we have an if already around this --->
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
</cffunction>

<cffunction name="autowire" hint="virtual method: autowires the given beanReference type with it's dependencies, depending on the autowire type" access="private" returntype="void" output="false">
	<cfset createObject("component", "coldspring.exception.VirtualMethodException").init("autowire", this)>
</cffunction>

<cffunction name="create" hint="vitual method: creates the object intsance" access="private" returntype="any" output="false">
	<cfset createObject("component", "coldspring.exception.VirtualMethodException").init("create", this)>
</cffunction>

<cffunction name="injectPropertyDependencies" hint="virtual method: inject all the properpty values into the given bean" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean to inject the properties into" type="any" required="Yes">
	<cfset createObject("component", "coldspring.exception.VirtualMethodException").init("injectPropertyDependencies", this)>
</cffunction>

<cffunction name="setID" access="private" returntype="void" output="false">
	<cfargument name="id" type="string" required="true">
	<cfset instance.id = arguments.id />
</cffunction>

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

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

<cffunction name="setMeta" access="private" returntype="void" output="false">
	<cfargument name="Meta" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.Meta = arguments.Meta />
</cffunction>

</cfcomponent>