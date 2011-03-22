<!---
   Copyright 2011 Mark Mandel
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

<cfcomponent hint="A argument parameter for a method" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Parameter" output="false">
	<cfargument name="paramMeta" hint="the parameter meta" type="struct" required="Yes">
	<cfargument name="method" hint="the method this param belogs to" type="Method" required="Yes">
	<cfscript>
		var reflectionService = getComponentMetaData("coldspring.core.reflect.ReflectionService").singleton.instance;

		if(!StructKeyExists(arguments.paramMeta, "required"))
		{
			arguments.paramMeta.required = false;
		}

		if(!structKeyExists(arguments.paramMeta, "type"))
		{
			arguments.paramMeta.type = "any";
		}
		else
		{
			arguments.paramMeta.type = reflectionService.resolveClassName(arguments.paramMeta.type, arguments.method.$getClass().getPackage());
		}

		if(!StructKeyExists(arguments.paramMeta, "hint"))
		{
			arguments.paramMeta.hint = "";
		}

		setMeta(arguments.paramMeta);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getMeta" hint="get the original meta data for this parameter" access="public" returntype="struct" output="false">
	<cfreturn instance.meta />
</cffunction>

<cffunction name="hasDefault" hint="whether or not it has a default value" access="public" returntype="boolean" output="false">
	<cfreturn structKeyExists(getMeta(), "default") />
</cffunction>

<cffunction name="getDefault" hint="get the default value" access="public" returntype="string" output="false">
	<cfreturn getMeta().default />
</cffunction>

<cffunction name="getName" hint="get the name of parameter" access="public" returntype="string" output="false">
	<cfreturn getMeta().name />
</cffunction>

<cffunction name="getType" hint="get the type checking for this parameter" access="public" returntype="string" output="false">
	<cfreturn getMeta().type />
</cffunction>

<cffunction name="isRequired" hint="Is this param required" access="public" returntype="boolean" output="false">
	<cfreturn getMeta().required />
</cffunction>

<cffunction name="hasAnnotation" hint="does the given annotation exist on this parameter" access="public" returntype="boolean" output="false">
	<cfargument name="annotation" hint="the name of the annotation" type="string" required="Yes">
	<cfreturn structKeyExists(getMeta(), arguments.annotation) />
</cffunction>

<cffunction name="getHint" hint="Get the hint. if none was set, "" is returned." access="public" returntype="string" output="false">
	<cfreturn getMeta().hint />
</cffunction>

<cffunction name="getAnnotation" hint="Gets the value of this annotation from the metadata, and returns it" access="public" returntype="boolean" output="false">
	<cfargument name="annotation" hint="the name of the annotation" type="string" required="Yes">
	<cfreturn structKeyExists(getMeta(), arguments.annotation) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setMeta" access="private" returntype="void" output="false">
	<cfargument name="meta" type="struct" required="true">
	<cfset instance.meta = arguments.meta />
</cffunction>

</cfcomponent>