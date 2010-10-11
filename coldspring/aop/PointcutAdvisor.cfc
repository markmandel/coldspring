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

<cfcomponent hint="Base class for Pointcuts that are driven by an advisor" implements="Advisor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="PointcutAdvisor" output="false">
	<cfargument name="pointcut" hint="the pointcuts to apply this advice to" type="Pointcut" required="Yes">
	<cfargument name="advice" hint="the advice to apply" type="Advice" required="no">
	<cfscript>
		setPointcut(arguments.pointcut);

		if(structKeyExists(arguments, "advice"))
		{
			setAdvice(arguments.advice);
		}

		return this;
	</cfscript>
</cffunction>

<cffunction name="getAdvice" access="public" returntype="Advice" output="false">
	<cfreturn instance.advice />
</cffunction>

<cffunction name="setAdvice" access="public" returntype="void" output="false">
	<cfargument name="advice" type="Advice" required="true">
	<cfset instance.advice = arguments.advice />
</cffunction>

<cffunction name="getPointcut" access="public" returntype="pointcut" output="false">
	<cfreturn instance.pointcut />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


<cffunction name="setPointcut" access="private" returntype="void" output="false">
	<cfargument name="pointcut" type="pointcut" required="true">
	<cfset instance.pointcut = arguments.pointcut />
</cffunction>

</cfcomponent>