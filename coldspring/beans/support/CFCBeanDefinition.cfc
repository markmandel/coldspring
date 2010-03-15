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
	<cfargument name="class" hint="the class of this bean" type="string" required="Yes">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset super.init(argumentCollection=arguments)>
	<cfreturn this />
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

			<cftry>
				<cfscript>
					args = {};

					args[getMetaData(arguments.bean[setterName]).parameters[1].name] = property.getValue();
	            </cfscript>

				<cfinvoke component="#arguments.bean#" method="#setterName#" argumentcollection="#args#" />

				<cfcatch>
					<!--- ignore it, something went wrong with the injection --->
				</cfcatch>
			</cftry>

		</cfif>
	</cfloop>
</cffunction>

<cffunction name="autowire" hint="virtual method: autowires the given beanReference type with it's dependencies, depending on the autowire type" access="private" returntype="void" output="false">
	<cfscript>
		var meta = getComponentMetadata(getClassName());
		var args = {meta = meta};
		eachMetaFunction(meta, autowireCallback, args);
    </cfscript>
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
		        	args.func = meta.functions[counter];
					call(argumentCollection=args);
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
		var ref = 0;
		var property = 0;
		var name = 0;
		var type = 0;
		var counter = 1;
		var len = 0;
		var param = 0;
		var constructorArg = 0;
		var class = 0;
		var array = 0;
		var package = getPackage(arguments.meta.name);

		/*
		Constructor autowire metadata
		*/

		if(arguments.func.access eq "public"
			AND LCase(arguments.func.name) eq "init")
		{
			len = arraylen(arguments.func.parameters);
			for(; counter lte len; counter++)
			{
				param = arguments.func.parameters[counter];

				//don't overwrite if we have the constructor arg
				if(NOT hasConstructorArgsByName(param.name))
				{
					if(getAutowire() eq "byName")
					{
						if(getBeanDefinitionRegistry().containsBeanDefinition(param.name))
						{
							ref = createObject("component", "RefValue").init(param.name, getBeanDefinitionRegistry());
							constructorArg = createObject("component", "ConstructorArg").init(param.name, ref);
							addConstructorArg(constructorArg);
						}
					}
					else if(getAutowire() eq "byType" AND structKeyExists(param, "type"))
					{
						class = resolveClassName(param.type, package);
						array = getBeanDefinitionRegistry().getBeanNamesForType(class);

						if(ArrayLen(array) eq 1)
						{
							ref = createObject("component", "RefValue").init(array[1], getBeanDefinitionRegistry());
							constructorArg = createObject("component", "ConstructorArg").init(param.name, ref);
							addConstructorArg(constructorArg);
						}
						else if(ArrayLen(array) gt 1)
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
			name = replaceNoCase(arguments.func.name, "set", "");

			//don't overwrite if we already have the property
			if(NOT hasPropertyByName(name))
			{
				if(getAutowire() eq "byName")
				{
					if(getBeanDefinitionRegistry().containsBeanDefinition(name))
					{
						ref = createObject("component", "RefValue").init(name, getBeanDefinitionRegistry());
						property = createObject("component", "Property").init(name, ref);
						addProperty(property);
					}
				}
				else if(getAutowire() eq "byType" AND structKeyExists(arguments.func.parameters[1], "type"))
				{
					class = resolveClassName(arguments.func.parameters[1].type, package);

					array = getBeanDefinitionRegistry().getBeanNamesForType(class);
					if(ArrayLen(array) eq 1)
					{
						ref = createObject("component", "RefValue").init(array[1], getBeanDefinitionRegistry());
						property = createObject("component", "Property").init(name, ref);
						addProperty(property);
					}
					else if(ArrayLen(array) gt 1)
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
		var builder = createObject("java", "java.lang.StringBuilder").init(arguments.className);

		builder.setLength(builder.lastIndexOf("."));

		return builder.toString();
    </cfscript>

</cffunction>

</cfcomponent>