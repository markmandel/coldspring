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

<cfinterface hint="After returning advice is invoked only on normal method return, not if an exception is thrown.
	<br/>Such advice can see the return value, but cannot change it."
	extends="AfterAdvice">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="afterReturning" hint="Callback after a given method successfully returned. " access="public" returntype="void" output="false">
	<cfargument name="returnValue" hint="the value returned by the method, if any" type="any" required="No">
	<cfargument name="method" hint="method being invoked" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="args" hint="the arguments for the method" type="struct" required="Yes">
	<cfargument name="target" hint="target of the method invocation" type="any" required="Yes">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>