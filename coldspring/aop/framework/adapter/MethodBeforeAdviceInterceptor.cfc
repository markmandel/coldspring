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

<cfcomponent hint="Interceptor to wrap am MethodBeforeAdvice. Used internally by the AOP framework; application developers should not need to use this class directly." implements="coldspring.aop.MethodInterceptor" output="false">


<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MethodBeforeAdviceInterceptor" output="false">
	<cfargument name="methodBeforeAdvice" hint="the method before advice to implement" type="coldspring.aop.MethodBeforeAdvice" required="Yes">
	<cfscript>
		setMethodBeforeAdvice(arguments.methodBeforeAdvice);

		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="Implement this method to perform extra treatments before and after the invocation.<br/>Polite implementations would certainly like to invoke Joinpoint.proceed()."
	access="public" returntype="any" output="false">
	<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" required="yes" />
	<cfscript>
		getMethodBeforeAdvice().before(arguments.methodInvocation.getMethod(), arguments.methodInvocation.getArguments(), arguments.methodInvocation.getTarget());

		return arguments.methodInvocation.proceed();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getMethodBeforeAdvice" access="private" returntype="coldspring.aop.MethodBeforeAdvice" output="false">
	<cfreturn instance.methodBeforeAdvice />
</cffunction>

<cffunction name="setMethodBeforeAdvice" access="private" returntype="void" output="false">
	<cfargument name="methodBeforeAdvice" type="coldspring.aop.MethodBeforeAdvice" required="true">
	<cfset instance.methodBeforeAdvice = arguments.methodBeforeAdvice />
</cffunction>

</cfcomponent>