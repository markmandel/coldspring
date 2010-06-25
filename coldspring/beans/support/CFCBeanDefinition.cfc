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

<cffunction name="notifyComplete" hint="Called when all the beans are added to the Factory, and post processing can occur." access="public" returntype="void" output="false">
	<cfscript>
		var methodInjector = 0;

		//if we are a factory bean, overwrite how create() works.
		if(hasFactoryBeanName() AND hasFactoryMethodName())
		{
			methodInjector = createObject("component", "coldspring.util.MethodInjector").init();

			methodInjector.start(this);

			methodInjector.injectMethod(cfc=this, udf=create_factoryBean, overwriteName="create");

			methodInjector.stop(this);
		}

		super.notifyComplete();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="create" hint="constructs the cfc instance" access="private" returntype="any" output="false">
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

<cffunction name="injectPropertyDependencies" hint="inject all the properpty values into the given bean" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean to inject the properties into" type="any" required="Yes">
	<cfscript>
		var properties = getPropertiesAsArray();
		var property = 0;
		var args = 0;
		var setterName = 0;
	</cfscript>

	<cfloop array="#properties#" index="property">

		<cfset setterName = "set" & property.getName()>

		<cfif structKeyExists(arguments.bean, setterName)>

			<cfscript>
				//move this up here, in case something goes wrong in create()
				args = {};
				args[getMetaData(arguments.bean[setterName]).parameters[1].name] = property.create();
            </cfscript>

			<cftry>
				<cfinvoke component="#arguments.bean#" method="#setterName#" argumentcollection="#args#" />

				<cfcatch>
					<!--- ignore it, something went wrong with the injection --->
				</cfcatch>
			</cftry>

		</cfif>
	</cfloop>
</cffunction>

<cffunction name="autowire" hint="autowires the given beanReference type with it's dependencies, depending on the autowire type" access="private" returntype="void" output="false">
	<cfscript>
		var meta = getComponentMetadata(getClassName());
		var cfcMetaUtil = createObject("component", "coldspring.util.CFCMetaUtil").init();
		var closure = createObject("component", "coldspring.util.Closure").init(autowireByMode);

		closure.curry("meta", meta);
		//method bindings
		closure.bind("getPackage", cfcMetaUtil.getPackage);
		closure.bind("resolveClassName", cfcMetaUtil.resolveClassName);
		closure.bind("isBeanNameAutoWireCandidate", isBeanNameAutoWireCandidate);

		//variable bindings
		closure.bind("id", getID());
		closure.bind("autowireMode", getAutowire());
		closure.bind("beanDef", this);
		closure.bind("registry", getBeanDefinitionRegistry());

		cfcMetaUtil.eachMetaFunction(meta, closure);
    </cfscript>
</cffunction>

<cffunction name="invokeInitMethod" hint="invoke the init method specified" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean created from this beanDefinition" type="any" required="Yes">
	<cfinvoke component="#arguments.bean#" method="#getInitMethod()#">
</cffunction>

<!--- Closure Methods --->

<cffunction name="autowireByMode" hint="Closure method for each function to autowire the CFC" access="private" returntype="void" output="false">
	<cfargument name="func" hint="the function meta data" type="struct" required="Yes">
	<cfargument name="meta" hint="the original meta data" type="struct" required="Yes">
	<cfscript>
		var local = {};

		local.package = getPackage(arguments.meta.name);

		/*
		Constructor autowire metadata
		*/

		if(NOT structKeyExists(arguments.func, "access"))
		{
			arguments.func.access = "public";
		}

		if(variables.autowireMode eq "byType")
		{
			local.closure = createObject("component", "coldspring.util.Closure").init(isBeanNameAutoWireCandidate);
			local.closure.bind("beanRegistry", variables.registry);
		}

		if(arguments.func.access eq "public"
			AND arguments.func.name eq "init")
		{
			local.len = arraylen(arguments.func.parameters);
			for(local.counter = 1; local.counter lte local.len; local.counter++)
			{
				local.param = arguments.func.parameters[local.counter];

				//don't overwrite if we have the constructor arg
				if(NOT variables.beanDef.hasConstructorArgsByName(local.param.name))
				{
					if(variables.autowireMode eq "byName")
					{
						//need to make sure we ignore non autowire candidates
						if(variables.registry.containsBean(local.param.name)
							AND variables.registry.isAutowireCandidate(local.param.name))
						{
							local.ref = createObject("component", "RefValue").init(local.param.name, variables.registry.getBeanFactory());
							local.constructorArg = createObject("component", "ConstructorArg").init(local.param.name, local.ref);
							variables.beanDef.addConstructorArg(local.constructorArg);
						}
					}
					else if(variables.autowireMode eq "byType" AND structKeyExists(local.param, "type"))
					{
						local.class = resolveClassName(local.param.type, local.package);
						local.array = variables.registry.getBeanNamesForTypeIncludingAncestor(local.class);

						local.collection = createObject("component", "coldspring.util.Collection").init(local.array);
						local.collection = local.collection.select(local.closure);

						if(local.collection.length() eq 1)
						{
							local.ref = createObject("component", "RefValue").init(local.collection.get(1), variables.registry.getBeanFactory());
							local.constructorArg = createObject("component", "ConstructorArg").init(local.param.name, local.ref);
							variables.beanDef.addConstructorArg(local.constructorArg);
						}
						else if(ArrayLen(local.array) gt 1)
						{
							createObject("component", "coldspring.beans.support.exception.AmbiguousTypeAutowireException").init(variables.id, param.type);
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
		if(arguments.func.access eq "public"
			AND JavaCast("string", LCase(arguments.func.name)).startsWith("set")
			AND ArrayLen(arguments.func.parameters) eq 1
			)
		{
			local.name = replaceNoCase(arguments.func.name, "set", "");

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
				else if(variables.autowireMode eq "byType" AND structKeyExists(arguments.func.parameters[1], "type"))
				{
					local.class = resolveClassName(arguments.func.parameters[1].type, local.package);

					local.array = variables.registry.getBeanNamesForTypeIncludingAncestor(local.class);

					local.collection = createObject("component", "coldspring.util.Collection").init(local.array);
					local.collection = local.collection.select(local.closure);

					if(local.collection.length() eq 1)
					{
						local.ref = createObject("component", "RefValue").init(local.collection.get(1), variables.registry.getBeanFactory());
						local.property = createObject("component", "Property").init(local.name, local.ref);
						variables.beanDef.addProperty(local.property);
					}
					else if(ArrayLen(local.array) gt 1)
					{
						createObject("component", "coldspring.beans.support.exception.AmbiguousTypeAutowireException").init(variables.id, arguments.func.parameters[1].type);
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