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

<cfinterface hint="An bean definition for any sort of bean that can be setup in ColdSpring">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getInstance" hint="Returns an instance of the bean this represents as managed By ColdSpring." access="public" returntype="any" output="false">
</cffunction>

<cffunction name="create" hint="Creates a new object intsance, with any constructor args it has (Not managed by ColdSpring).
	This is generally used by classes that need to create proxies of beans"
	access="public" returntype="any" output="false">
</cffunction>

<cffunction name="configure" hint="configure after this bean definition has been registered" access="public" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" hint="the bean definition registry this belongs to" type="coldspring.beans.BeanDefinitionRegistry" required="Yes">
	<cfargument name="beanCache" type="coldspring.beans.factory.BeanCache" hint="The bean cache" required="true">
	<cfargument name="beanPostProcessorObservable" hint="the observable collection for bean post processing" type="coldspring.beans.factory.config.BeanPostProcessorObservable" required="Yes" colddoc:generic="coldspring.beans.factory.config.BeanPostProcessor">
</cffunction>

<cffunction name="overrideFrom" hint="Override settings in this bean definition (assumably a copied parent from a parent-child inheritance relationship) from the given bean definition (assumably the child).
			<br/>
			* Will override className if specified in the given bean definition.<br/>
	        * Will always take abstract, scope, lazyInit, autowireMode, from the given bean definition.<br/>
	        * Will add constructorArguments, properties, from the given bean definition to existing ones.<br/>
	        * Will override factoryBeanName, factoryMethodName, and initMethodName if specified in the given bean definition.<br/>
			* Will override meta data, if it exists"

	access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to overwrite with" type="BeanDefinition" required="Yes">
</cffunction>

<cffunction name="notifyComplete" hint="Called when all the beans are added to the Factory, and post processing can occur." access="public" returntype="void" output="false">
</cffunction>

<cffunction name="validate" hint="Validates the structure of this bean, throws an exception if it is invalid" access="public" returntype="void" output="false">
</cffunction>

<cffunction name="getID" access="public" returntype="string" output="false">
</cffunction>

<cffunction name="setID" access="public" returntype="void" output="false">
	<cfargument name="id" type="string" required="true">
</cffunction>

<cffunction name="getClassName" access="public" returntype="string" output="false">
</cffunction>

<cffunction name="setClassName" access="public" returntype="void" output="false">
	<cfargument name="class" type="string" required="true">
</cffunction>

<cffunction name="hasClassName" hint="whether this object has a class name" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="getScope" access="public" returntype="string" output="false">
</cffunction>

<cffunction name="setScope" access="public" hint="bean scope, singleton, prototype, request, session" returntype="void" output="false">
	<cfargument name="scope" type="string" required="true">
</cffunction>

<cffunction name="getAutowire" access="public" returntype="string" output="false">
</cffunction>

<cffunction name="setAutowire" hint="The method to use when autowiring, no, byName, byType" access="public" returntype="void" output="false">
	<cfargument name="autowire" type="string" required="true">
</cffunction>

<cffunction name="isLazyInit" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="setLazyInit" access="public" returntype="void" output="false">
	<cfargument name="lazyInit" type="boolean" required="true">
</cffunction>

<cffunction name="getInitMethod" access="public" hint="Get the name of the custom initialization method to invoke after setting bean properties." returntype="string" output="false">
</cffunction>

<cffunction name="setInitMethod" access="public" hint="Set the name of the custom initialization method to invoke after setting bean properties." returntype="void" output="false">
	<cfargument name="initMethod" type="string" required="true">
</cffunction>

<cffunction name="hasInitMethod" hint="whether this object has a init-method" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="removeInitMethod" hint="removes the init method set on this bean definition" access="public" returntype="void" output="false">
</cffunction>

<cffunction name="getConstructorArgs" hint="constructor argument dependencies" access="public" returntype="struct" output="false"
	colddoc:generic="string,ConstructorArg">
</cffunction>

<cffunction name="getConstructorArgsAsArray" hint="returns the constructor args as an array, for convenience" access="public" returntype="array" output="false"
			colddoc:generic="ConstructorArg">
</cffunction>

<cffunction name="hasConstructorArgsByName" hint="a check to see if a constructor arg with the given name exists" access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the constructor arg" type="string" required="Yes">
</cffunction>

<cffunction name="addConstructorArg" hint="adds a constructor argument dependency."
			access="public" returntype="void" output="false">
	<cfargument name="constructorArg" type="coldspring.beans.support.ConstructorArg" required="true" />
</cffunction>

<cffunction name="getPropertiesAsArray" hint="returns the properties as an array, for convenience" access="public" returntype="array" output="false"
			colddoc:generic="Property">
</cffunction>

<cffunction name="getProperties" access="public" returntype="struct" output="false"
			colddoc:generic="string,Property">
</cffunction>

<cffunction name="addProperty" hint="adds a property dependency."
			access="public" returntype="void" output="false">
	<cfargument name="property" type="coldspring.beans.support.Property" required="true" />
</cffunction>

<cffunction name="hasPropertyByName" hint="a check to see if a property with the given name exists" access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the property" type="string" required="Yes">
</cffunction>

<cffunction name="isAbstract" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="setAbstract" hint="Set the bean to not being able to be instantiated." access="public" returntype="void" output="false">
	<cfargument name="Abstract" type="boolean" required="true">
</cffunction>

<cffunction name="getFactoryBeanName" access="public" returntype="string" output="false">
</cffunction>

<cffunction name="setFactoryBeanName" access="public" returntype="void" output="false">
	<cfargument name="factoryBeanName" type="string" required="true">
</cffunction>

<cffunction name="hasFactoryBeanName" hint="whether this object has a factoryBeanName" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="getFactoryMethodName" access="public" returntype="string" output="false">
</cffunction>

<cffunction name="setFactoryMethodName" access="public" returntype="void" output="false">
	<cfargument name="factoryMethodName" type="string" required="true">
</cffunction>

<cffunction name="hasFactoryMethodName" hint="whether this object has a factoryMethodName" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="getParentName" hint="Return the name of the parent definition of this bean definition" access="public" returntype="string" output="false">
</cffunction>

<cffunction name="setParentName" hint="Set the name of the parent definition of this bean definition" access="public" returntype="void" output="false">
	<cfargument name="parentName" type="string" required="true">
</cffunction>

<cffunction name="hasParentName" hint="whether this object has a parentName" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="isAutowireCandidate" access="public" returntype="boolean" output="false">
</cffunction>

<cffunction name="setAutowireCandidate" access="public" returntype="void" output="false">
	<cfargument name="isAutowireCandidate" type="boolean" required="true">
</cffunction>


<cffunction name="getMeta" hint="Return custom object meta data" access="public" returntype="struct" output="false"
			colddoc:generic="string,string">
</cffunction>

<cffunction name="$getClass" hint="retrieves the relevent meta data about the class for the JVM language this bean represents" access="public" returntype="any" output="false">
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="BeanDefinition" output="false">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>