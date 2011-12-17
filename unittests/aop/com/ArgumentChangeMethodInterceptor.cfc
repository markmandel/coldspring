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

<cfcomponent hint="around advice that reverses return strings" implements="coldspring.aop.MethodInterceptor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ArgumentChangeMethodInterceptor" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="Implement this method to perform extra treatments before and after the invocation.<br/>Polite implementations would certainly like to invoke Joinpoint.proceed()." access="public" returntype="any" output="false">
	<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation"  required="yes" />
	<cfscript>
		var args = arguments.methodInvocation.getArguments();

		if(structKeyExists(args, "1") && isSimpleValue(args[1]))
		{
			args[1] = "_" & args[1];
		}

		return arguments.methodInvocation.proceed();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>