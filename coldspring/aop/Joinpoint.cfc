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

<cfinterface hint="This interface represents a generic runtime joinpoint (in the AOP terminology).
<br/>A runtime joinpoint is an event that occurs on a static joinpoint (i.e. a location in a the program). For instance, an invocation is the runtime joinpoint on a method (static joinpoint).
<br/>In the context of an interception framework, a runtime joinpoint is then the reification of an access to an accessible object (a method, a constructor), i.e. the static part of the joinpoint. It is passed to the interceptors that are installed on the static joinpoint.">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getThis" access="public" hint="Returns the object that holds the current joinpoint's static part.<br/>
	For instance, the target object for an invocation."
	returntype="any" output="false">
</cffunction>

<cffunction name="proceed" hint="Proceeds to the next interceptor in the chain.
	The implementation and the semantics of this method depends on the actual joinpoint type (see the children interfaces)."
	access="public" returntype="any" output="false">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>