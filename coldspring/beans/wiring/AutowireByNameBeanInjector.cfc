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

<cfcomponent hint="Bean Injector that autowires by setter property names" extends="AbstractBaseBeanInjector" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AutowireByNameBeanInjector" output="false">
	<cfargument name="debugMode" hint="turns on extra debugging, that can be seeing in the trace view, if you can't work out why a bean isn't being injected"
				type="boolean" required="No" default="false">
	<cfscript>
		super.init(arguments.debugMode);

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="calculateDependencyInjection" hint="abstract method: Needs to overwritten to determine the strategy used to wire the target object" access="private" returntype="array" output="false"
	colddoc:generic="struct">
	<cfargument name="object" hint="the target object" type="any" required="Yes">
	<cfscript>
		var funcMeta = 0;
		var key = 0;
		var injectDetails = [];
		var detail = 0;
		var propertyName = 0;

		//beanName, methodName, argumentName

		//let's go the easy way for this object, loop around the functions on it
		for(key in arguments.object)
		{
			key = Lcase(key);
			if(isCustomFunction(arguments.object[key]) AND key.startsWith("set"))
			{
				propertyName = replace(key, "set", "");

				if(getBeanFactory().containsBean(propertyName) AND getBeanFactory().isAutowireCandidate(propertyName));
				{
					funcMeta = getMetadata(arguments.object[key]);
					if(StructKeyExists(funcMeta, "parameters")
						AND ArrayLen(funcMeta.parameters) eq 1)
					{
						detail =
						{
							beanName = propertyName
							,methodName = key
							,argumentName = funcMeta.parameters[1].name
						};

						arrayAppend(injectDetails, detail);
					}
				}
			}
		}

		return injectDetails;
    </cfscript>
</cffunction>

</cfcomponent>