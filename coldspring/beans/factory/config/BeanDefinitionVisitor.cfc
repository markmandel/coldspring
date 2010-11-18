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

<cffunction name="init" hint="Constructor" access="public" returntype="BeanDefinitionVisitor" output="false">
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
		visitClassName(argumentCollection=arguments);
		visitFactoryBeanName(argumentCollection=arguments);
		visitFactoryMethodName(argumentCollection=arguments);
		visitParentName(argumentCollection=arguments);
		visitScope(argumentCollection=arguments);
		visitInitMethod(argumentCollection=arguments);
		visitMap(arguments.beanDefinition.getMeta());
		visitMap(arguments.beanDefinition.getConstructorArgs());
		visitMap(arguments.beanDefinition.getProperties());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="visitClassName" hint="visit the class name" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.beanDefinition.hasClassName())
		{
			local.className = arguments.beanDefinition.getClassName();
			local.resolvedClassName = getValueResolver().resolveStringValue(local.className);

			if(StructKeyExists(local, "resolvedClassName") && compare(local.className, local.resolvedClassName) != 0)
			{
				arguments.beanDefinition.setClassName(local.resolvedClassName);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="visitInitMethod" hint="visit the Init Method" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.beanDefinition.hasInitMethod())
		{
			local.initMethod = arguments.beanDefinition.getInitMethod();
			local.resolvedInitMethod = getValueResolver().resolveStringValue(local.initMethod);

			if(StructKeyExists(local, "resolvedInitMethod") && compare(local.initMethod, local.resolvedInitMethod) != 0)
			{
				arguments.beanDefinition.setInitMethod(local.resolvedInitMethod);
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
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.beanDefinition.hasFactoryMethodName())
		{
			local.methodName = arguments.beanDefinition.getFactoryMethodName();
			local.resolveMethodName = getValueResolver().resolveStringValue(local.methodName);

			if(StructKeyExists(local, "resolveMethodName") && compare(local.methodName, local.resolveMethodName) != 0)
			{
				arguments.beanDefinition.setFactoryMethodName(local.resolveMethodName);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="visitParentName" hint="visit the parent name" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to visit" type="coldspring.beans.support.BeanDefinition" required="Yes">
	<cfscript>
		var local = {};

		if(arguments.beanDefinition.hasParentName())
		{
			local.name = arguments.beanDefinition.getParentName();
			local.resolvedName = getValueResolver().resolveStringValue(local.name);

			if(StructKeyExists(local, "resolvedName") && compare(local.name, local.resolvedName) != 0)
			{
				arguments.beanDefinition.setParentName(local.resolvedName);
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
	<cfargument name="map" hint="the Map in question" type="struct" required="Yes">
	<cfscript>
		var local = {};

		local.newContent = {};
		local.modified = false;

		for(local.key in arguments.map)
		{
			local.resolvedKey = resolveValue(local.key);

			local.item = arguments.map.get(local.key);
			local.resolvedItem = resolveValue(local.item);

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
				/*
					we can get away with this here, as objects don't need to be returned, only strings
				*/
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

			local.newContent.put(local.actualKey, local.actualItem);
		}

		if(local.modified)
		{
			structClear(arguments.map);
			structAppend(arguments.map, local.newContent);
		}
    </cfscript>
</cffunction>

<cffunction name="visitList" hint="visit the contents of an array" access="private" returntype="void" output="false">
	<cfargument name="array" hint="the array to visit" type="array" required="Yes">
	<cfscript>
		var item = 0;
    </cfscript>
	<cfloop array="#arguments.array#" index="item">
		<cfset resolveValue(item)>
	</cfloop>
</cffunction>

<cffunction name="resolveValue" hint="generic resolve value method, that resolves properties based on the object type" access="private" returntype="any" output="false">
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
				arguments.value.setValue(local.resolvedValue);
			}
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.RefValue"))
		{
			local.resolvedBeanName = getValueResolver().resolveStringValue(arguments.value.getBeanName());

			if(structKeyExists(local, "resolvedBeanName") && compare(arguments.value.getBeanName(), local.resolvedBeanName) != 0)
			{
				arguments.value.setBeanName(local.resolvedBeanName);
			}
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.MapValue"))
		{
			visitMap(arguments.value.getValueMap());
		}
		else if(isInstanceOf(arguments.value, "coldspring.beans.support.ListValue"))
		{
			visitList(arguments.value.getValueArray());
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