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

<cfinterface extends="coldspring.aop.Advice" hint="Interface to be used when implementing Around Advice.<br/>
	Intercepts calls on an method on its way to the target. These are nested 'on top' of the target.<br/>
	The user should implement the invokeMethod(MethodInvocation) method to modify the original behavior.
	">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="invokeMethod" hint="Implement this method to perform extra treatments before and after the invocation.<br/>Polite implementations would certainly like to invoke methodInvocation.proceed()."
	access="public" returntype="any" output="false">
	<cfargument name="methodInvocation" hint="the method invocation joinpoint" type="coldspring.aop.MethodInvocation" required="Yes">
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>