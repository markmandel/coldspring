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

<cfinterface hint="Each dynamic proxy instance has an associated invocation handler.
	When a method is invoked on a proxy instance, the method invocation is encoded and dispatched to the invoke method of its invocation handler.">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="invokeMethod" hint="Processes a method invocation one a proxy instance and returns the result.
		This method will be invoked on an invocation handler when a method is invoked on a proxy instance that it is assosciated with."
		access="public" returntype="any" output="false">
	<cfargument name="proxy" hint="the proxy instance that the method was invoked on" type="any" required="Yes">
	<cfargument name="method" hint="the name of the method that got called on the proxy object" type="string" required="Yes">
	<cfargument name="args" hint="the struct of arguments that got passed into the method invocation on the proxy instance.
		It should be noted that these may/may not come through as numerically indexed arguments or name based arguments"
		type="struct" required="Yes">

</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfinterface>