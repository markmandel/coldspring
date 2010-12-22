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

<cfcomponent hint="Factory for creating method objects. <br/>Best to be stored as a singleton, as Method objects are cached for performance." output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor - always returns singleton" access="public" returntype="MethodFactory" output="false">
	<cfscript>
		var singleton = createObject("component", "coldspring.util.Singleton").init();

		return singleton.createInstance(getMetaData(this).name);
	</cfscript>
</cffunction>

<cffunction name="createMethod" hint="factory method for creating a Method Object" access="public" returntype="Method" output="false">
	<cfargument name="className" hint="the classname in question" type="string" required="Yes">
	<cfargument name="function" hint="the name of the function" type="string" required="Yes">
	<cfscript>
		var key = arguments.className & ":" & arguments.function;
		var cache = getMethodCache();
		var method = 0;

		//not going to worry about locking, as we don't care if we create more than 1
		if(!structKeyExists(cache, key))
		{
			method = buildMethod(argumentCollection=arguments);
			cache[key] = method;
		}

		return cache[key];
    </cfscript>

</cffunction>

<cffunction name="configure" hint="Configure method for static configuration" access="public" returntype="void" output="false">
	<cfscript>
		var closure = createObject("component", "coldspring.util.Closure").init(findMethod);

		setFindMethodClosure(closure);
		setMethodCache(StructNew());
		setCFCMetaUtil(getComponentMetadata("coldspring.util.CFCMetaUtil").singleton.instance);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildMethod" hint="build the method object" access="private" returntype="Method" output="false">
	<cfargument name="className" hint="the classname in question" type="string" required="Yes">
	<cfargument name="function" hint="the name of the function" type="string" required="Yes">
	<cfscript>
		var classMeta = getComponentMetadata(arguments.className);
		var args =
			{
				functionName = arguments.function
				,result = {} //this struct is for results to be passed by reference
			};

		getCFCMetaUtil().eachMetaFunction(classMeta, getFindMethodClosure(), args);

		if(structKeyExists(args.result, "result"))
		{
			return createObject("component", "Method").init(args.result.result, classMeta);
		}

		createObject("component", "coldspring.core.reflect.exception.MethodNotFoundException").init(arguments.className, arguments.function);
    </cfscript>
</cffunction>

<cffunction name="getCFCMetaUtil" access="private" returntype="coldspring.util.CFCMetaUtil" output="false">
	<cfreturn instance.cfcMetaUtil />
</cffunction>

<cffunction name="setCFCMetaUtil" access="private" returntype="void" output="false">
	<cfargument name="cfcMetaUtil" type="coldspring.util.CFCMetaUtil" required="true">
	<cfset instance.cfcMetaUtil = arguments.cfcMetaUtil />
</cffunction>

<cffunction name="getMethodCache" access="private" returntype="struct" output="false"
	colddoc:generic="string,Method">
	<cfreturn instance.methodCache />
</cffunction>

<cffunction name="setMethodCache" access="private" returntype="void" output="false">
	<cfargument name="methodCache" type="struct" required="true" colddoc:generic="string,Method">
	<cfset instance.methodCache = arguments.methodCache />
</cffunction>

<cffunction name="getFindMethodClosure" access="private" returntype="coldspring.util.Closure" output="false">
	<cfreturn instance.findMethodClosure />
</cffunction>

<cffunction name="setFindMethodClosure" access="private" returntype="void" output="false">
	<cfargument name="findMethodClosure" type="coldspring.util.Closure" required="true">
	<cfset instance.findMethodClosure = arguments.findMethodClosure />
</cffunction>

<!--- closure methods --->

<cffunction name="findMethod" hint="finds the method by a given name" access="private" returntype="boolean" output="false">
	<cfargument name="func" hint="the function meta data" type="struct" required="Yes">
	<cfargument name="functionName" hint="the function name to look for" type="string" required="Yes">
	<cfscript>
		if(arguments.func.name eq arguments.functionName)
		{
			arguments.result.result = arguments.func;
			return false;
		}

		return true;
    </cfscript>
</cffunction>

<!--- /closure methods --->

</cfcomponent>