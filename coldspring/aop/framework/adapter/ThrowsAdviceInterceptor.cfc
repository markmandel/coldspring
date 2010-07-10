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

<cfcomponent hint="Interceptor to wrap an after-throwing advice." implements="coldspring.aop.MethodInterceptor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ThrowsAdviceInterceptor" output="false">
	<cfargument name="throwsAdvice" hint="the throws advice to wrap" type="coldspring.aop.ThrowsAdvice" required="Yes">
	<cfscript>
		setThrowsAdvice(arguments.throwsAdvice);

		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="Implement this method to perform extra treatments before and after the invocation.
	<br/>Polite implementations would certainly like to invoke Joinpoint.proceed()." access="public" returntype="any" output="false">
	<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="yes" />
	<cftry>
		<cfreturn arguments.methodInvocation.proceed() />
	    <cfcatch type="Any">
	    	<!---
			we have to duplicate the cfcatch, as for whatever reason, it doesn't
			think it is a struct
			 --->
			<cfset getThrowsAdvice().afterThrowing(arguments.methodInvocation.getMethod(),
									arguments.methodInvocation.getArguments(),
									arguments.methodInvocation.getTarget(),
									duplicate(cfcatch))>
	    	<cfrethrow>
    	</cfcatch>
    </cftry>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getThrowsAdvice" access="private" returntype="coldspring.aop.ThrowsAdvice" output="false">
	<cfreturn instance.throwsAdvice />
</cffunction>

<cffunction name="setThrowsAdvice" access="private" returntype="void" output="false">
	<cfargument name="throwsAdvice" type="coldspring.aop.ThrowsAdvice" required="true">
	<cfset instance.throwsAdvice = arguments.throwsAdvice />
</cffunction>


</cfcomponent>