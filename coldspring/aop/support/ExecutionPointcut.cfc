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

<cfcomponent hint="Pointcut that can match against a wide variety of execution joinpoints, including package, method name, return types, etc" implements="coldspring.aop.Pointcut" output="false">

<cfscript>
	meta = getMetadata(this);
	if(!StructKeyExists(meta, "const"))
	{
		const = {};
		const.ANY = "*";
		const.NONE = "";

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ExecutionPointcut" output="false">
	<cfscript>
		setInstanceType(meta.const.ANY);
		setSubPackage(meta.const.ANY);
		setPackage(meta.const.ANY);
		setMethodName(meta.const.ANY);
		setReturnType(meta.const.ANY);
		setArgumentTypes(createObject("java", "java.util.ArrayList").init());
		setMatchAnyArguments(true);

		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Can the current set of metadata match the execution pointcut that has been defined here?" access="public" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">

	<cfscript>
		return (matchInstanceType(arguments.method, arguments.class)
				AND
				matchSubPackage(arguments.method, arguments.class)
				AND
				matchPackage(arguments.method, arguments.class)
				AND
				matchMethodName(arguments.method, arguments.class)
				AND
				matchReturnType(arguments.method, arguments.class)
				AND
				matchArguments(arguments.method, arguments.class)
				);
    </cfscript>
</cffunction>

<cffunction name="getInstanceType" access="public" returntype="string" output="false">
	<cfreturn instance.instanceType />
</cffunction>

<cffunction name="setInstanceType" access="public" hint="The class/interface type that the class meta data must match to" returntype="void" output="false">
	<cfargument name="instanceType" type="string" required="true">
	<cfset instance.instanceType = arguments.instanceType />
</cffunction>

<cffunction name="getSubPackage" access="public" returntype="string" output="false">
	<cfreturn instance.subPackage />
</cffunction>

<cffunction name="setSubPackage" access="public" hint="Set the package that the class type must be part of, or of a sub package of" returntype="void" output="false">
	<cfargument name="subPackage" type="string" required="true">
	<cfset instance.subPackage = lcase(arguments.subPackage) />
</cffunction>

<cffunction name="getPackage" access="public" returntype="string" output="false">
	<cfreturn instance.package />
</cffunction>

<cffunction name="setPackage" hint="set the package that the class must match explicitly" access="public" returntype="void" output="false">
	<cfargument name="package" type="string" required="true">
	<cfset instance.package = arguments.package />
</cffunction>

<cffunction name="getMethodName" access="public" returntype="string" output="false">
	<cfreturn instance.methodName />
</cffunction>

<cffunction name="setMethodName" hint="set the method name that the method must match to. Allows the use of '*' as a wildcard in strings." access="public" returntype="void" output="false">
	<cfargument name="methodName" type="string" required="true">
	<!--- replace it with the regex for the wildcard --->
	<cfset instance.methodName = replace(arguments.methodName, "*", "(.*?)") />
</cffunction>

<cffunction name="getReturnType" access="public" returntype="string" output="false">
	<cfreturn instance.returnType />
</cffunction>

<cffunction name="setReturnType" access="public" returntype="void" output="false">
	<cfargument name="returnType" type="string" required="true">
	<cfset instance.returnType = arguments.returnType />
</cffunction>

<cffunction name="getMatchAnyArguments" access="public" returntype="boolean" output="false">
	<cfreturn instance.matchAnyArguments />
</cffunction>

<cffunction name="setMatchAnyArguments" hint="Whether or not to match any set of arguments on a given method. Defaults to true." access="public" returntype="void" output="false">
	<cfargument name="matchAnyArguments" type="boolean" required="true">
	<cfset instance.matchAnyArguments = arguments.matchAnyArguments />
</cffunction>

<cffunction name="getArgumentTypes" access="public" returntype="array" output="false">
	<cfreturn instance.argumentTypes />
</cffunction>

<cffunction name="setArgumentTypes" access="public" returntype="void" output="false">
	<cfargument name="argumentTypes" type="array" required="true">
	<cfset instance.argumentTypes = arguments.argumentTypes />
</cffunction>

<cffunction name="addArgumentType" hint="convenience class that adds an argument type, and sets the matchAnyArguments to false in one go" access="public" returntype="void" output="false">
	<cfargument name="argumentType" hint="the argument type, or '*' for a wildcard" type="string" required="Yes">
	<cfscript>
		setMatchAnyArguments(false);
		arrayAppend(getArgumentTypes(), arguments.argumentType);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="matchMethodName" hint="Does the current method match the method name, including regex's" access="private" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">

	<cfscript>
		if(getMethodName() == meta.const.NONE)
		{
			return false;
		}
		else if(getMethodName() == meta.const.ANY)
		{
			return true;
		}

		//use the underlying String object to match the whole string against the regex
		return arguments.method.getName().matches(getMethodName());
    </cfscript>
</cffunction>

<cffunction name="matchInstanceType" hint="Can the currently class instance type be assigned to the provided class / interface" access="private" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">

	<cfscript>
		var reflectionService = 0;
		var instanceClass = 0;

		if(getInstanceType() == meta.const.NONE)
		{
			return false;
		}
		else if(getInstanceType() == meta.const.ANY)
		{
			return true;
		}

		reflectionService = getComponentMetadata("coldspring.core.reflect.ReflectionService").singleton.instance;
		instanceClass = reflectionService.loadClass(getInstanceType());

		return instanceClass.isAssignableFrom(arguments.class.getName());
    </cfscript>
</cffunction>

<cffunction name="matchSubPackage" hint="Does the package that the class type must be part of, or of a sub package of match" access="private" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		var package = 0;
		if(getSubPackage() == meta.const.NONE)
		{
			return false;
		}
		else if(getSubPackage() == meta.const.ANY)
		{
			return true;
		}
		else
		{
			return Lcase(arguments.class.getPackage()).startsWith(getSubPackage());
		}
    </cfscript>
</cffunction>

<cffunction name="matchPackage" hint="Does the package that the class type match our set package?" access="private" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		var package = 0;
		if(getPackage() == meta.const.NONE)
		{
			return false;
		}
		else if(getPackage() == meta.const.ANY)
		{
			return true;
		}
		else
		{
			return arguments.class.getPackage() eq getPackage();
		}
    </cfscript>
</cffunction>

<cffunction name="matchReturnType" hint="Does the method data match the return type of the method?" access="private" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		var package = 0;
		if(getReturnType() == meta.const.NONE)
		{
			return false;
		}
		else if(getReturnType() == meta.const.ANY)
		{
			return true;
		}
		else
		{
			return getReturnType() eq arguments.method.getReturnType();
		}
    </cfscript>
</cffunction>

<cffunction name="matchArguments" hint="Does the current set of arguments on the method match up to the required set in the pointcut" access="private" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		var local = {};

		if(getMatchAnyArguments())
		{
			return true;
		}

		local.argumentTypes = getArgumentTypes();
		local.len = arraylen(local.argumentTypes);

		if(local.len != ArrayLen(arguments.method.getParameters()))
		{
			return false;
		}

		local.len = ArrayLen(local.argumentTypes);

        for(local.counter=1; local.counter <= local.len; local.counter++)
        {
        	local.type = local.argumentTypes[local.counter];
			local.param = arguments.method.getParameter(local.counter);

			if(local.type != meta.const.ANY)
			{
				if(local.type != local.param.getType())
				{
					return false;
				}
			}
        }

		return true;
    </cfscript>
</cffunction>

</cfcomponent>