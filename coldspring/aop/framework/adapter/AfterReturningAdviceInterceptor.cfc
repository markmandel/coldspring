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

<cfcomponent hint="Interceptor to wrap AfterReturningAdvice. Used internally by the AOP framework; application developers should not need to use this class directly." implements="coldspring.aop.MethodInterceptor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AfterReturningAdviceInterceptor" output="false">
	<cfargument name="afterReturningAdvice" hint="the AfterReturningAdvice to wrap" type="coldspring.aop.AfterReturningAdvice" required="Yes">
	<cfscript>
		setAfterReturningAdvice(arguments.afterReturningAdvice);

		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="Implement this method to perform extra treatments before and after the invocation.<br/>Polite implementations would certainly like to invoke Joinpoint.proceed()." access="public" returntype="any" output="false">
	<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="yes" />
	<cfscript>
		var args = {
				method = arguments.methodInvocation.getMethod()
				,args = arguments.methodInvocation.getArguments()
				,target = arguments.methodInvocation.getTarget()
			};

		args.returnValue = arguments.methodInvocation.proceed();

		getAfterReturningAdvice().afterReturning(argumentCollection=args);

		if(structKeyExists(args, "returnValue"))
		{
			return args.returnValue;
		}
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getAfterReturningAdvice" access="private" returntype="coldspring.aop.AfterReturningAdvice" output="false">
	<cfreturn instance.afterReturningAdvice />
</cffunction>

<cffunction name="setAfterReturningAdvice" access="private" returntype="void" output="false">
	<cfargument name="afterReturningAdvice" type="coldspring.aop.AfterReturningAdvice" required="true">
	<cfset instance.afterReturningAdvice = arguments.afterReturningAdvice />
</cffunction>

</cfcomponent>