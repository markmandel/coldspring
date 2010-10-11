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

<cfcomponent hint="A pointcut that allows multiple pointcuts to be joined into one super pointcut of doom"
			implements="coldspring.aop.Pointcut"
			output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CompositePointcut" output="false">
	<cfargument name="initialPointcut" hint="the initial pointcut to start off with" type="coldspring.aop.Pointcut" required="Yes">
	<cfargument name="negate" hint="whether to switch the matching of the initial pointcut, i.e. !initialPointcut.match()" type="boolean" required="No" default="false">
	<cfscript>
		setInitialPointcut(arguments.initialPointcut);
		setNegateInitialPointcut(arguments.negate);

		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Does given method, for the given class, match for this pointcut" access="public" returntype="boolean" output="false">
	<cfargument name="methodMetadata" type="struct" required="yes" />
	<cfargument name="classMetadata" type="struct" required="yes" />

	<cfscript>
		var match = getInitialPointcut().matches(arguments.methodMetadata, arguments.classMetadata);

		if(getNegateInitialPointcut())
		{
			match = !match;
		}

		return match;
    </cfscript>
</cffunction>

<cffunction name="getInitialPointcut" access="public" returntype="coldspring.aop.Pointcut" output="false">
	<cfreturn instance.initialPointcut />
</cffunction>

<cffunction name="setInitialPointcut" access="public" returntype="void" output="false">
	<cfargument name="initialPointcut" type="coldspring.aop.Pointcut" required="true">
	<cfset instance.initialPointcut = arguments.initialPointcut />
</cffunction>

<cffunction name="getNegateInitialPointcut" access="public" returntype="boolean" output="false">
	<cfreturn instance.negateInitialPointcut />
</cffunction>

<cffunction name="setNegateInitialPointcut" access="public" returntype="void" output="false">
	<cfargument name="negateInitialPointcut" type="boolean" required="true">
	<cfset instance.negateInitialPointcut = arguments.negateInitialPointcut />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>