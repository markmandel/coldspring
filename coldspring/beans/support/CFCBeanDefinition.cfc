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

<cfcomponent hint="A bean definition for a CFC" extends="AbstractBeanDefinition" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CFCBeanDefinition" output="false">
	<cfargument name="id" hint="the id of this bean" type="string" required="Yes">
	<cfset super.init(argumentCollection=arguments)>
	<cfreturn this />
</cffunction>

<cffunction name="create" hint="Constructs a cfc instance, with any constructor args it has (Not managed by ColdSpring).
	This is generally used by classes that need to create proxies of beans, or internally by the BeanDefinition"
	access="public" returntype="any" output="false">
	<cfscript>
		var constructorArgs = getConstructorArgsAsArray();
		var arg = 0;
		var initArgs = {};
	</cfscript>

	<cfloop array="#constructorArgs#" index="arg">
		<cfscript>
			initArgs[arg.getName()] = arg.create();
        </cfscript>
	</cfloop>

	<cftry>
		<cfreturn createObject("component", getClassName()).init(argumentCollection=initArgs)/>
		<cfcatch>
			<cfset createObject("component", "coldspring.beans.exception.BeanCreationException").init(this, cfcatch)>
		</cfcatch>
	</cftry>
</cffunction>

<cffunction name="notifyComplete" hint="Called when all the beans are added to the Factory, and post processing can occur." access="public" returntype="void" output="false">
	<cfscript>
		var methodInjector = 0;

		//if we are a factory bean, overwrite how create() works.
		if(hasFactoryBeanName() AND hasFactoryMethodName())
		{
			methodInjector = getComponentMetadata("coldspring.util.MethodInjector").singleton.instance;

			methodInjector.start(this);

			methodInjector.injectMethod(cfc=this, udf=create_factoryBean, overwriteName="create");

			methodInjector.stop(this);
		}

		super.notifyComplete();
    </cfscript>
</cffunction>

<cffunction name="$getClass" hint="retrieves the relevent meta data about the class for the JVM language this bean represents" access="public" returntype="any" output="false">
	<cfscript>
		var reflectionService = getComponentMetaData("coldspring.core.reflect.ReflectionService").singleton.instance;

		return reflectionService.loadClass(getClassName());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="injectPropertyDependencies" hint="inject all the properpty values into the given bean" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean to inject the properties into" type="any" required="Yes">
	<cfscript>
		var properties = getPropertiesAsArray();
		var property = 0;
		var args = 0;
		var setterName = 0;
	</cfscript>

	<cfloop array="#properties#" index="property">
		<cfscript>
			setterName = "set" & property.getName();

			//move this up here, in case something goes wrong in create()
			args = {};

			//let cf work out the argument name
			args[1] = property.create();
        </cfscript>

		<cftry>
			<cfinvoke component="#arguments.bean#" method="#setterName#" argumentcollection="#args#" />

			<cfcatch>
				<!--- ignore it, something went wrong with the injection --->
			</cfcatch>
		</cftry>

	</cfloop>
</cffunction>

<cffunction name="autowire" hint="autowires the given beanReference type with it's dependencies, depending on the autowire type" access="private" returntype="void" output="false">
	<cfscript>
		var closure = createObject("component", "coldspring.util.Closure").init(autowireByMode);
		var class = $getClass();

		//method bindings
		closure.bind("isBeanNameAutoWireCandidate", isBeanNameAutoWireCandidate);

		//variable bindings
		closure.bind("id", getID());
		closure.bind("autowireMode", getAutowire());
		closure.bind("beanDef", this);
		closure.bind("registry", getBeanDefinitionRegistry());

		//this was originally done as a closure, in theory this could be moved to a loop.
		class.getMethodsCollection().each(closure);
    </cfscript>
</cffunction>

<cffunction name="invokeInitMethod" hint="invoke the init method specified" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean created from this beanDefinition" type="any" required="Yes">
	<cfinvoke component="#arguments.bean#" method="#getInitMethod()#">
</cffunction>

<!--- Closure Methods --->

<cffunction name="autowireByMode" hint="Closure method for each function to autowire the CFC" access="private" returntype="void" output="false">
	<cfargument name="method" hint="the method that is currently being looked at as a potential autowire point." type="coldspring.core.reflect.Method" required="Yes">
	<cfscript>
		var local = {};

		/*
		Constructor autowire metadata
		*/

		if(variables.autowireMode eq "byType")
		{
			local.closure = createObject("component", "coldspring.util.Closure").init(isBeanNameAutoWireCandidate);
			local.closure.bind("beanRegistry", variables.registry);
		}

		if(arguments.method.getName() eq "init")
		{
			local.params = arguments.method.getParameters();
			local.counter = 1;
			local.len = ArrayLen(local.params);
			for(; local.counter <= local.len; local.counter++)
			{
				local.param = local.params[local.counter];

				//don't overwrite if we have the constructor arg
				if(NOT variables.beanDef.hasConstructorArgsByName(local.param.getName()))
				{
					if(variables.autowireMode eq "byName")
					{
						//need to make sure we ignore non autowire candidates
						if(variables.registry.containsBean(local.param.getName())
							AND variables.registry.isAutowireCandidate(local.param.getName()))
						{
							local.ref = createObject("component", "RefValue").init(local.param.getName(), variables.registry.getBeanFactory());
							local.constructorArg = createObject("component", "ConstructorArg").init(local.param.getName(), local.ref);
							variables.beanDef.addConstructorArg(local.constructorArg);
						}
					}
					else if(variables.autowireMode eq "byType")
					{
						local.array = variables.registry.getBeanNamesForTypeIncludingAncestor(local.param.getType());

						local.collection = createObject("component", "coldspring.util.Collection").init(local.array);
						local.collection = local.collection.findAll(local.closure);

						if(local.collection.length() eq 1)
						{
							local.ref = createObject("component", "RefValue").init(local.collection.get(1), variables.registry.getBeanFactory());
							local.constructorArg = createObject("component", "ConstructorArg").init(local.param.getName(), local.ref);
							variables.beanDef.addConstructorArg(local.constructorArg);
						}
						else if(ArrayLen(local.array) gt 1)
						{
							createObject("component", "coldspring.beans.support.exception.AmbiguousTypeAutowireException").init(variables.id, local.param.getType());
						}
					}
				}
			}
		}

		/*
			Property Autowire:
			The rule is it has to be public
			AND starts with 'set'
			AND it only has 1 argument
		*/
		if(JavaCast("string", LCase(arguments.method.getName())).startsWith("set")
			AND ArrayLen(arguments.method.getParameters()) eq 1
			)
		{
			local.name = replaceNoCase(arguments.method.getName(), "set", "");

			//don't overwrite if we already have the property
			if(NOT variables.beanDef.hasPropertyByName(local.name))
			{
				if(variables.autowireMode eq "byName")
				{
					if(variables.registry.containsBean(local.name)
							AND variables.registry.isAutowireCandidate(local.name))
					{
						local.ref = createObject("component", "RefValue").init(local.name, variables.registry.getBeanFactory());
						local.property = createObject("component", "Property").init(local.name, local.ref);
						variables.beanDef.addProperty(local.property);
					}
				}
				else if(variables.autowireMode eq "byType")
				{
					local.class = arguments.method.getParameter(1).getType();

					local.array = variables.registry.getBeanNamesForTypeIncludingAncestor(local.class);

					local.collection = createObject("component", "coldspring.util.Collection").init(local.array);
					local.collection = local.collection.findAll(local.closure);

					if(local.collection.length() eq 1)
					{
						local.ref = createObject("component", "RefValue").init(local.collection.get(1), variables.registry.getBeanFactory());
						local.property = createObject("component", "Property").init(local.name, local.ref);
						variables.beanDef.addProperty(local.property);
					}
					else if(ArrayLen(local.array) gt 1)
					{
						createObject("component", "coldspring.beans.support.exception.AmbiguousTypeAutowireException").init(variables.id, arguments.method.getParameter(1).getType());
					}
				}
			}
		}
    </cfscript>
</cffunction>

<cffunction name="isBeanNameAutoWireCandidate" hint="is the given bean name an autowireable candidate" access="private" returntype="boolean" output="false">
	<cfargument name="name" hint="the bean definition name" type="string" required="Yes">
	<cfscript>
		return variables.beanRegistry.isAutowireCandidate(arguments.name);
    </cfscript>
</cffunction>

<!--- /Closure Methods --->

<!--- mixins --->

<cffunction name="create_factoryBean" hint="mixin: to replace create(), when we need to constructs the cfc instance from a factory bean"
			access="private" returntype="any" output="false">
	<cfscript>
		var constructorArgs = getConstructorArgsAsArray();
		var arg = 0;
		var initArgs = {};
		var factoryBean = getBeanDefinitionRegistry().getBeanDefinition(getFactoryBeanName()).getInstance();
		var object = 0;
	</cfscript>

	<cfloop array="#constructorArgs#" index="arg">
		<cfscript>
			initArgs[arg.getName()] = arg.create();
        </cfscript>
	</cfloop>

	<cftry>
		<cfinvoke component="#factoryBean#" method="#getFactoryMethodName()#" argumentcollection="#initArgs#" returnvariable="object">

		<cfscript>
			return object;
        </cfscript>

		<cfcatch>
			<cfset createObject("component", "coldspring.beans.exception.BeanCreationException").init(this, cfcatch)>
		</cfcatch>
	</cftry>
</cffunction>

<!--- /mixins --->

</cfcomponent>