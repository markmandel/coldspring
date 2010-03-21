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
<cfcomponent name="MethodInjector" hint="Injects methods into CFCs" output="false">

<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MethodInjector" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="start" hint="start method injection set" access="public" returntype="void" output="false">
	<cfargument name="CFC" hint="The cfc to inject the method into" type="any" required="Yes">
	<cfscript>
		arguments.CFC["injectMethodMixin"] = variables.injectMethodMixin;
		arguments.CFC["removeMethodMixin"] = variables.removeMethodMixin;
	</cfscript>
</cffunction>

<cffunction name="stop" hint="stop injection block" access="public" returntype="void" output="false">
	<cfargument name="CFC" hint="The cfc to inject the method into" type="any" required="Yes">
	<cfscript>
		StructDelete(arguments.CFC, "injectMethodMixin");
		StructDelete(arguments.CFC, "removeMethodMixin");
	</cfscript>
</cffunction>

<cffunction name="injectMethod" hint="Injects a method into a CFC" access="public" returntype="any" output="false">
	<cfargument name="CFC" hint="The cfc to inject the method into" type="any" required="Yes">
	<cfargument name="UDF" hint="UDF to be checked" type="any" required="Yes">
	<cfargument name="overwriteAccess" hint="overwrite the method's access level to another access level" type="string" required="No">
	<cfargument name="overwriteName" hint="overwrite the name in which you wish to inject this method into" type="string" required="No">
	<cfscript>
		arguments.CFC.injectMethodMixin(argumentCollection=arguments);

		return arguments.CFC;
	</cfscript>
</cffunction>

<cffunction name="removeMethod" hint="Take a public Method off a CFC" access="public" returntype="void" output="false">
	<cfargument name="CFC" hint="The cfc to inject the method into" type="any" required="Yes">
	<cfargument name="UDFName" hint="Name of the UDF to be removed" type="string" required="Yes">
	<cfscript>
		arguments.CFC.removeMethodMixin(arguments.UDFName);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- mixins --->
<cffunction name="injectMethodMixin" hint="mixin: injects a method into the CFC scope" access="private" returntype="void" output="false">
	<cfargument name="UDF" hint="UDF to be checked" type="any" required="Yes">
	<cfargument name="overwriteAccess" hint="argument to overwrite the method's access level to another access level" type="string" required="No">
	<cfargument name="overwriteName" hint="overwrite the name in which you wish to inject this method into" type="string" required="No">
	<cfscript>
		var metadata = getMetaData(arguments.UDF);

		if(structKeyExists(arguments, "overwriteAccess"))
		{
			metadata.access = arguments.overwriteAccess;
		}

		if(NOT structKeyExists(arguments, "overwriteName"))
		{
			arguments.overwriteName = metadata.name;
		}

		variables[arguments.overwriteName] = arguments.UDF;

		if(NOT structKeyExists(metadata, "access"))
		{
			metadata.access = "public";
		}

		if(metadata.access neq "private")
		{
			this[arguments.overwriteName] = arguments.UDF;
		}
	</cfscript>
</cffunction>

<cffunction name="removeMethodMixin" hint="mixin: injects a method into the CFC scope" access="private" returntype="void" output="false">
	<cfargument name="UDFName" hint="Name of the UDF to be removed" type="string" required="Yes">
	<cfscript>
		StructDelete(this, arguments.udfName);
		StructDelete(variables, arguments.udfName);
	</cfscript>
</cffunction>
<!--- /mixins --->

</cfcomponent>