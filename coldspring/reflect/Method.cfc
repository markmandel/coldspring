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

<cfcomponent hint="A Method provides information about, and access to, a single method on a class or interface. The reflected method may be a class method or an instance method." output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Method" output="false">
	<cfargument name="methodMeta" hint="the meta data for this particular method" type="struct" required="Yes">
	<cfargument name="classMeta" hint="the meta data for a particular CFC" type="struct" required="Yes">
	<cfscript>
		setMethodName(arguments.methodMeta.name);

		//do some clean up for convenience
		if(!structKeyExists(arguments.methodMeta, "returntype"))
		{
			arguments.methodMeta.returntype = "any";
		}

		if(!structKeyExists(arguments.methodMeta, "access"))
		{
			arguments.methodMeta.access = "public";
		}

		setMethodMeta(arguments.methodMeta);
		setClassMeta(arguments.classMeta);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getMethodName" access="public" returntype="string" output="false">
	<cfreturn instance.methodName />
</cffunction>

<cffunction name="getMethodMeta" hint="Returns the meta data for a this particular function<br/>A method meta returned from a Method will always have: returntype and access."
	access="public" returntype="struct" output="false">
	<cfreturn instance.methodMeta />
</cffunction>

<cffunction name="getClassMeta" access="public" returntype="struct" output="false">
	<cfreturn instance.ClassMeta />
</cffunction>

<cffunction name="invokeMethod" hint="invoke this method on a given object. (Usually an object of the same class as where this method comes from)" access="public" returntype="any" output="false">
	<cfargument name="object" hint="the object to invoke the method on" type="any" required="Yes">
	<cfargument name="args" hint="the arguments to pass through" type="struct" required="No" default="#structNew()#">
	<cfscript>
		var local = {};
    </cfscript>
	<cfinvoke component="#arguments.object#" method="#getMethodName()#" argumentcollection="#arguments.args#" returnvariable="local.return">
	<cfscript>
		if(structKeyExists(local, "return"))
		{
			return local.return;
		}
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setMethodName" access="private" returntype="void" output="false">
	<cfargument name="methodName" type="string" required="true">
	<cfset instance.methodName = arguments.methodName />
</cffunction>

<cffunction name="setMethodMeta" access="private" returntype="void" output="false">
	<cfargument name="methodMeta" type="struct" required="true">
	<cfset instance.methodMeta = arguments.methodMeta />
</cffunction>

<cffunction name="setClassMeta" access="private" returntype="void" output="false">
	<cfargument name="ClassMeta" type="struct" required="true">
	<cfset instance.ClassMeta = arguments.ClassMeta />
</cffunction>

</cfcomponent>