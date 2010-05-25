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
			initArgs[arg.getName()] = arg.getValue();
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
				//move this up here, in case something goes wrong in getValue()
				args = {};
				args[getMetaData(arguments.bean[setterName]).parameters[1].name] = property.getValue();
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
		var args = {meta = meta};
		eachMetaFunction(meta, autowireCallback, args);
    </cfscript>
</cffunction>

<cffunction name="invokeInitMethod" hint="invoke the init method specified" access="private" returntype="void" output="false">
	<cfargument name="bean" hint="the bean created from this beanDefinition" type="any" required="Yes">
	<cfinvoke component="#arguments.bean#" method="#getInitMethod()#">
</cffunction>

<cffunction name="eachMetaFunction" hint="calls a callback for each function that is found in meta data, with 'func' as the argument name" access="private" returntype="void" output="false">
	<cfargument name="meta" hint="the meta data to loop through for functions" type="struct" required="Yes">
	<cfargument name="func" hint="the HOF to call for each function that is found" type="any" required="Yes">
	<cfargument name="args" hint="the arguments to pass to the HOF. 'func' is reserved for each function that is found" type="struct" required="No" default="#StructNew()#">
	<cfscript>
		var len = 0;
		var counter = 0;
		var ref = 0;
		var property = 0;
		var name = 0;
		var type = 0;
		var call = arguments.func;

		while(StructKeyExists(meta, "extends"))
		{
			if(StructKeyExists(meta, "functions"))
			{
				len = ArrayLen(meta.functions);
		        for(counter = 1; counter lte len; counter++)
		        {
		        	arguments.args.func = meta.functions[counter];
					call(argumentCollection=arguments.args);
		        }
			}

			meta = meta.extends;
		}
    </cfscript>
</cffunction>

<cffunction name="autowireCallback" hint="Callback for each to autowire the CFC" access="private" returntype="void" output="false">
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

		if(getAutowire() eq "byType")
		{
			local.closure = createObject("component", "coldspring.util.Closure").init(isBeanNameAutoWireCandidate);
			local.closure.bind("beanRegistry", getBeanDefinitionRegistry());
		}

		if(arguments.func.access eq "public"
			AND LCase(arguments.func.name) eq "init")
		{
			local.len = arraylen(arguments.func.parameters);
			for(local.counter = 1; local.counter lte local.len; local.counter++)
			{
				local.param = arguments.func.parameters[local.counter];

				//don't overwrite if we have the constructor arg
				if(NOT hasConstructorArgsByName(local.param.name))
				{
					if(getAutowire() eq "byName")
					{
						//need to make sure we ignore non autowire candidates
						if(getBeanDefinitionRegistry().containsBeanDefinition(local.param.name)
							AND getBeanDefinitionRegistry().getBeanDefinition(local.param.name).isAutowireCandidate())
						{
							local.ref = createObject("component", "RefValue").init(local.param.name, getBeanDefinitionRegistry());
							local.constructorArg = createObject("component", "ConstructorArg").init(local.param.name, local.ref);
							addConstructorArg(local.constructorArg);
						}
					}
					else if(getAutowire() eq "byType" AND structKeyExists(local.param, "type"))
					{
						local.class = resolveClassName(local.param.type, local.package);
						local.array = getBeanDefinitionRegistry().getBeanNamesForType(local.class);

						local.collection = createObject("component", "coldspring.util.Collection").init(local.array);
						local.collection = local.collection.select(local.closure);

						if(local.collection.length() eq 1)
						{
							local.ref = createObject("component", "RefValue").init(local.collection.get(1), getBeanDefinitionRegistry());
							local.constructorArg = createObject("component", "ConstructorArg").init(local.param.name, local.ref);
							addConstructorArg(local.constructorArg);
						}
						else if(ArrayLen(local.array) gt 1)
						{
							createObject("component", "coldspring.beans.support.exception.AmbiguousTypeAutowireException").init(getID(), param.type);
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
			if(NOT hasPropertyByName(local.name))
			{
				if(getAutowire() eq "byName")
				{
					if(getBeanDefinitionRegistry().containsBeanDefinition(local.name)
							AND getBeanDefinitionRegistry().getBeanDefinition(local.name).isAutowireCandidate())
					{
						local.ref = createObject("component", "RefValue").init(local.name, getBeanDefinitionRegistry());
						local.property = createObject("component", "Property").init(local.name, local.ref);
						addProperty(local.property);
					}
				}
				else if(getAutowire() eq "byType" AND structKeyExists(arguments.func.parameters[1], "type"))
				{
					local.class = resolveClassName(arguments.func.parameters[1].type, local.package);

					local.array = getBeanDefinitionRegistry().getBeanNamesForType(local.class);

					local.collection = createObject("component", "coldspring.util.Collection").init(local.array);
					local.collection = local.collection.select(local.closure);

					if(local.collection.length() eq 1)
					{
						local.ref = createObject("component", "RefValue").init(local.collection.get(1), getBeanDefinitionRegistry());
						local.property = createObject("component", "Property").init(local.name, local.ref);
						addProperty(local.property);
					}
					else if(ArrayLen(local.array) gt 1)
					{
						createObject("component", "coldspring.beans.support.exception.AmbiguousTypeAutowireException").init(getID(), arguments.func.parameters[1].type);
					}
				}
			}
		}
    </cfscript>
</cffunction>

<cffunction name="resolveClassName" hint="resolves a class name that may not be full qualified" access="private" returntype="string" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfargument name="package" hint="the package the class comes from" type="string" required="Yes">
	<cfscript>
		if(ListLen(arguments.className, ".") eq 1)
		{
			arguments.className = arguments.package & "." & arguments.className;
		}

		return arguments.className;
    </cfscript>
</cffunction>

<cffunction name="getPackage" hint="returns the package this class belongs to" access="private" returntype="string" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfscript>
		//have to do this stupid juggling because CF8 'can't find 'setLength() on a Builder'
		var builder = createObject("java", "java.lang.StringBuilder").init(arguments.className);

		//builder.setLength(builder.lastIndexOf(".")); << CF8 fails on this because it can't resolve Java Methods. Grrr.
		builder.delete(javacast("int", builder.lastIndexOf(".")), len(arguments.className));

		return builder.toString();
    </cfscript>
</cffunction>

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
			initArgs[arg.getName()] = arg.getValue();
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

<!--- closures --->

<cffunction name="isBeanNameAutoWireCandidate" hint="is the given bean name an autowireable candidate" access="private" returntype="boolean" output="false">
	<cfargument name="name" hint="the bean definition name" type="string" required="Yes">
	<cfscript>
		return variables.beanRegistry.getBeanDefinition(arguments.name).isAutowireCandidate();
    </cfscript>
</cffunction>

<!--- /closures --->

</cfcomponent>