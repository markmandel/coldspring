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

<cfcomponent hint="Functional introspection layer into the underlying CFML engine, to see what functionality is available.
			<br/>You can access the version name and number of the engine, but feature detection is the preferred method of
			utilisation"
		output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Engine" output="false">
	<cfscript>
		var singleton = createObject("component", "Singleton").init();

		return singleton.createInstance(getMetaData(this).name);
	</cfscript>
</cffunction>

<cffunction name="configure" hint="Configure method for static configuration" access="public" returntype="void" output="false">
	<cfscript>
		variables.instance = {};
		setJavaClassCache(structNew());
	</cfscript>
</cffunction>

<cffunction name="getName" hint="Get the name of the unlying engine. e.g. ColdFusion or Railo" access="public" returntype="string" output="false">
	<cfreturn listGetAt(Server.ColdFusion.ProductName, 1, " ") />
</cffunction>

<cffunction name="getVersion" hint="Get the version number of the underlying engine." access="public" returntype="string" output="false">
	<cfreturn server.coldfusion.productVersion />
</cffunction>

<cffunction name="getMajorVersion" hint="Get the major version number, e.g. 9" access="public" returntype="numeric" output="false">
	<cfreturn listGetAt(getVersion(), 1) />
</cffunction>

<cffunction name="hasJavaClass" hint="Be able to feature test for certain Java classes" access="public" returntype="boolean" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="false">
	<cfscript>
		var cache = getJavaClassCache();
		if(!structKeyExists(cache, arguments.className))
		{
			try
			{
				getPageContext().getClass().getClassLoader().loadClass(arguments.className);
				cache[arguments.className] = true;
			}
			catch(java.lang.ClassNotFoundException exc)
			{
				cache[arguments.className] = false;
			}
		}

		return cache[arguments.className];
	</cfscript>
</cffunction>

<cffunction name="ormEnabled" hint="Whether ORM can get used" access="public" returntype="boolean" output="false">
	<cfscript>
		if(!structKeyExists(instance, "ormEnabled"))
		{
			try
			{
				ormGetSession();
				instance.ormEnabled = true;
			}
			catch(Any exc)
			{
				instance.ormEnabled = false;
			}
		}

		return instance.ormEnabled;
	</cfscript>
</cffunction>

<cffunction name="getFunctionCalledNameEnabled" hint="Whether or not you can use getFunctionCalledName()" access="public" returntype="boolean" output="false">
	<cfscript>
		if(!structKeyExists(instance, "functionCalledNameEnabled"))
		{
			try
			{
				getFunctionCalledName();
				instance.functionCalledNameEnabled = true;
			}
			catch(Any exc)
			{
				instance.functionCalledNameEnabled = false;
			}
		}

		return instance.functionCalledNameEnabled;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getJavaClassCache" access="private" returntype="struct" output="false">
	<cfreturn instance.javaClassCache />
</cffunction>

<cffunction name="setJavaClassCache" access="private" returntype="void" output="false">
	<cfargument name="javaClassCache" type="struct" required="true">
	<cfset instance.javaClassCache = arguments.javaClassCache />
</cffunction>

</cfcomponent>