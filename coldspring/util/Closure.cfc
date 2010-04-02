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

<cfcomponent hint="A closure context" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Closure" output="false">
	<cfargument name="function" hint="the function / the name of the function that will be called in this closure context" type="any" required="No">
	<cfscript>
		__setCurryArguments(StructNew());

		if(isSimpleValue(arguments.function))
		{
			__setFunction(variables[arguments.function]);
		}
		else
		{
			__setFunction(arguments.function);
		}

		return this;
	</cfscript>
</cffunction>

<cffunction name="call" hint="call the closure method" access="public" returntype="any" output="false">
	<cfscript>
		var call = __getFunction();
		var args = __getCurryArguments();

		structAppend(arguments, args, false);

		return call(argumentCollection=arguments);
    </cfscript>
</cffunction>

<cffunction name="curry" hint="curry arguments for this function, either by passing in name value pairs, or by passing in a struct" access="public" returntype="void" output="false">
	<cfscript>
		if(isStruct(arguments[1]))
		{
			structAppend(getCurryArguments(), arguments[1], true);
		}
		else
		{
			structInsert(__getCurryArguments(), arguments[1], arguments[2], true);
		}
    </cfscript>
</cffunction>

<cffunction name="bind" hint="bind variables to this Closure, either by name value pair, or by passing in a struct" access="public" returntype="void" output="false">
	<cfscript>
		if(isStruct(arguments[1]))
		{
			structAppend(variables, arguments[1], true);
		}
		else
		{
			structInsert(variables, arguments[1], arguments[2], true);
		}
    </cfscript>
</cffunction>

<cffunction name="bound" hint="return a bound variable" access="public" returntype="any" output="false">
	<cfargument name="name" hint="the name of the bound variable" type="string" required="Yes">
	<cfscript>
		return variables[arguments.name];
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="__getFunction" hint="return the function that is being executed in this closure context" access="private" returntype="any" output="false">
	<cfreturn __closure.function />
</cffunction>

<cffunction name="__setFunction" hint="Set the function that is being executed in this closure context" access="private" returntype="void" output="false">
	<cfargument name="function" type="any" required="true">
	<cfset __closure.function = arguments.function />
</cffunction>

<cffunction name="__getCurryArguments" access="private" returntype="struct" output="false">
	<cfreturn __closure.curryArguments />
</cffunction>

<cffunction name="__setCurryArguments" access="private" returntype="void" output="false">
	<cfargument name="curryArguments" type="struct" required="true">
	<cfset __closure.curryArguments = arguments.curryArguments />
</cffunction>

</cfcomponent>