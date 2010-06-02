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

<cfcomponent hint="Visitor class for traversing BeanDefinition objects, in particular the property values and constructor argument values contained in them,
 					resolving bean metadata values.<br/>
 					Used by PropertyPlaceholderConfigurer(?) to parse all String values contained in a BeanDefinition, resolving any placeholders found."
					output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanDefinitionVisitor.cfc" output="false">
	<cfargument name="valueResolver" hint="the StringValueResolver for visiting each of the string property values, and manipulating them"
		type="any" required="Yes" colddoc:generic="coldspring.util.StringValueResolver">
	<cfscript>
		setValueResolver(arguments.valueResolver);

		return this;
	</cfscript>
</cffunction>

<cffunction name="visitBeanDefinition" hint="Traverse the given BeanDefinition object, Property Values, ConstructorArg Values and Meta values contained in them."
	access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		visitAutowire(argumentCollection=arguments);
		visitClassName(argumentCollection=arguments);
		visitFactoryBeanName(argumentCollection=arguments);
		visitFactoryMethodName(argumentCollection=arguments);
		visitParentName(argumentCollection=arguments);
		visitScope(argumentCollection=arguments);
		visitMap(arguments.beanDefinition.getMeta());
		visitMap(arguments.beanDefinition.getConstructorArgs());
		visitMap(arguments.beanDefinition.getProperties());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="visitAutowire" hint="visit the autowire mode" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		local.autowire = arguments.beanDefinition.getAutowire();
		local.resolvedAutowire = getValueResolver().resolveStringValue(local.autowire);

		if(structKeyExists(local, "resolvedAutowire") && compare(local.autowire, local.resolvedAutowire) != 0)
		{
			arguments.beanDefinition.setAutowire(local.resolvedAutowire);
		}
    </cfscript>
</cffunction>

<cffunction name="visitClassName" hint="visit the class name" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.beanDefinition.hasClassName())
		{
			local.className = arguments.beanDefinition.getClassName();
			local.resolvedClassName = getValueResolver().resolveStringValue(local.className);

			if(StrutKeyExists(local, "resolvedClassName") && compare(local.className, local.resolvedClassName) != 0)
			{
				arguments.beanDefinition.setClassName(local.resolvedClassName);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="visitFactoryBeanName" hint="visit the factory bean name" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.beanDefinition.hasFactoryBeanName())
		{
			local.factory = arguments.beanDefinition.getFactoryBeanName();
			local.resolvedFactory = getValueResolver().resolveStringValue(local.factory);

			if(StructKeyExists(local, "resolvedFactory") && compare(local.factory, local.resolvedFactory) != 0)
			{
				arguments.beanDefinition.setFactoryBeanName(local.resolvedFactory);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="visitFactoryMethodName" hint="visit the factory Method name" access="private" returntype="void" output="false">
	<cfargument name="MethodDefinition" hint="the Method definition to visit" type="coldspring.Methods.support.MethodDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.MethodDefinition.hasFactoryMethodName())
		{
			local.methodName = arguments.MethodDefinition.getFactoryMethodName();
			local.resolveMethodName = getValueResolver().resolveStringValue(local.factory);

			if(StructKeyExists(local, "resolveMethodName") && compare(local.methodName, local.resolveMethodName) != 0)
			{
				arguments.MethodDefinition.setFactoryMethodName(local.resolveMethodName);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="visitParentName" hint="visit the parent name" access="private" returntype="void" output="false">
	<cfargument name="MethodDefinition" hint="the Method definition to visit" type="coldspring.Methods.support.MethodDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.MethodDefinition.hasParentName())
		{
			local.name = arguments.MethodDefinition.getParentName();
			local.resolvedName = getValueResolver().resolveStringValue(local.name);

			if(StructKeyExists(local, "resolvedName") && compare(local.name, local.resolvedName) != 0)
			{
				arguments.MethodDefinition.setParentName(local.resolvedName);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="visitScope" hint="visit the scope" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		local.scope = arguments.beanDefinition.getScope();
		local.resolvedScope = getValueResolver().resolveStringValue(local.scope);

		if(StructKeyExists(local, "resolvedScope") && compare(local.scope, local.resolvedScope) != 0)
		{
			arguments.beanDefinition.setScope(local.resolvedScope);
		}
    </cfscript>
</cffunction>

<cffunction name="visitMap" hint="visit a Map structure" access="private" returntype="void" output="false">
	<cfargument name="meta" hint="the metadata struct" type="struct" required="Yes">
	<cfscript>
		var local = {};

		local.newContent = {};
		local.modified = false;

		for(local.key in arguments.meta)
		{
			local.item = arguments.meta[local.key];
			local.resolvedKey = getValueResolver().resolveStringValue(key);
			local.resolvedItem = resolveValue(item);

			if(structKeyExists(local, "resolvedKey"))
			{
				if(local.key != local.resolvedKey)
				{
					local.modified = true;
				}
				local.actualKey = local.resolvedKey;
			}
			else
			{
				local.actualKey = local.key;
			}

			if(structKeyExists(local, "resolvedItem"))
			{
				if(compare(local.item, local.resolvedItem) != 0)
				{
					local.modified = true;
				}
				local.actualItem = local.resolvedItem;
			}
			else
			{
				local.actualItem = local.item;
			}

			local.newContent[local.actualKey] = local.actualItem;
		}

		if(local.modified)
		{
			structClear(arguments.meta);
			structAppend(arguments.meta, local.newContent);
		}
    </cfscript>
</cffunction>

<cffunction name="visitArray" hint="visit the contents of an array" access="public" returntype="void" output="false">
	<cfargument name="array" hint="the array to visit" type="array" required="Yes">
	<cfscript>
		var item = 0;
    </cfscript>
	<cfloop collection="#arguments.array#" index="item">
		<cfset resolveValue(item)>
	</cfloop>
</cffunction>

<cffunction name="resolveValue" hint="generic resolve value method, that resolves properties based on the object type" access="public" returntype="any" output="false">
	<cfargument name="value" hint="the value to resolve" type="any" required="Yes">
	<cfscript>
		var local = {};

		if(isSimpleValue(arguments.value))
		{
			return getValueResolver().resolveStringValue(arguments.value);
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.AbstractProperty"))
		{
			visitMap(arguments.value.getMeta());
			resolveValue(arguments.value.getValue());

			local.resolvedName = getValueResolver().resolveStringValue(arguments.value.getName());
			if(StructKeyExists(local, "resolvedName") && compare(arguments.value.getName(), local.resolvedName) != 0)
			{
				arguments.value.setName(local.resolvedName);
			}
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.SimpleValue"))
		{
			local.resolvedValue = getValueResolver().resolveStringValue(arguments.value.getValue());

			if(StructKeyExists(local, "resolvedValue") && compare(arguments.value.getValue(), local.resolvedValue) != 0)
			{
				local.value.setValue(local.resolvedValue);
			}
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.RefValue"))
		{
			local.resolvedBeanName = getValueResolver().resolveStringValue(arguments.value.getBeanName());

			if(structKeyExists(local, "resolvedBeanName") && compare(arguments.value.getBeanName(), local.resolvedBeanName) != 0)
			{
				local.value.setBeanName(local.resolvedBeanName);
			}
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.MapValue"))
		{
			visitMap(arguments.value.getValueMap());
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.ListValue"))
		{
			visitList(argumetns.value.getValueArray());
		}
    </cfscript>
</cffunction>

<cffunction name="getValueResolver" access="private" returntype="any" output="false">
	<cfreturn instance.valueResolver />
</cffunction>

<cffunction name="setValueResolver" access="private" returntype="void" output="false">
	<cfargument name="valueResolver" type="any" required="true">
	<cfset instance.valueResolver = arguments.valueResolver />
</cffunction>


</cfcomponent>