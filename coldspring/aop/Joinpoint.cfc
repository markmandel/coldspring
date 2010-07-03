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

<cfcomponent hint="This abstract class represents a generic runtime joinpoint (in the AOP terminology).
<br/>A runtime joinpoint is an event that occurs on a static joinpoint (i.e. a location in a the program). For instance, an invocation is the runtime joinpoint on a method (static joinpoint).
<br/>In the context of an interception framework, a runtime joinpoint is then the reification of an access to an accessible object (a method, a constructor), i.e. the static part of the joinpoint. <br/>
	It is passed to the interceptors that are installed on the static joinpoint."
	colddoc:abstract="false"
	output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getThis" access="public" hint="Returns the ColdSpring AOP Proxy"
	returntype="any" output="false">
	<cfreturn instance.this />
</cffunction>

<cffunction name="proceed" hint="Abstract method: Proceeds to the next interceptor in the chain.
	The implementation and the semantics of this method depends on the actual joinpoint type (see the children)."
	access="public" returntype="any" output="false"
	colddoc:abstract="true">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init(this, "proceed")>
</cffunction>

<cffunction name="getTarget" hint="Returns the original object that the AOP proxy wraps" access="public" returntype="any" output="false">
	<cfreturn instance.target />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfargument name="target" hint="the original object" type="any" required="Yes">
	<cfargument name="proxy" hint="the AOP proxy for the target" type="any" required="Yes">
	<cfscript>
		setTarget(arguments.target);
		setThis(arguments.proxy);
	</cfscript>
</cffunction>

<cffunction name="setThis" access="private" returntype="void" output="false">
	<cfargument name="this" type="any" required="true">
	<cfset instance.this = arguments.this />
</cffunction>

<cffunction name="setTarget" access="private" returntype="void" output="false">
	<cfargument name="target" type="any" required="true">
	<cfset instance.target = arguments.target />
</cffunction>

</cfcomponent>