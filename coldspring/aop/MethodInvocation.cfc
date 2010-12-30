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

<cfcomponent hint="Description of an invocation to a method, given to an interceptor upon method-call.<br/>
	A method invocation is a joinpoint and can be intercepted by a method interceptor." extends="Invocation" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MethodInvocation" output="false">
	<cfargument name="method" hint="The method being called" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="target" hint="the original object" type="any" required="Yes">
	<cfargument name="proxy" hint="the AOP proxy for the target" type="any" required="Yes">
	<cfargument name="args" hint="the arguments to go through to the function" type="struct" required="Yes">
	<cfargument name="filterChain" hint="an iterator of MethodInterceptors, that constructs the AOP Advice to be called" type="any" required="Yes" colddoc:generic="MethodInterceptor">
	<cfscript>
		super.init(arguments.target, arguments.proxy, arguments.args);
		setMethod(arguments.method);
		setFilterChain(arguments.filterChain);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getMethod" access="public" returntype="coldspring.core.reflect.Method" output="false">
	<cfreturn instance.method />
</cffunction>

<cffunction name="proceed" hint="Proceeds to the next interceptor in the chain.
	The implementation and the semantics of this method depends on the actual joinpoint type (see the children interfaces)."
	access="public" returntype="any" output="false">
	<cfscript>
		var filterChain = getFilterChain();

		if(filterChain.hasNext())
		{
			return filterChain.next().invokeMethod(this);
		}

		return getMethod().invokeMethod(getTarget(), getArguments());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setMethod" access="private" returntype="void" output="false">
	<cfargument name="method" type="coldspring.core.reflect.Method" required="true">
	<cfset instance.method = arguments.method />
</cffunction>

<cffunction name="getFilterChain" access="private" returntype="any" output="false">
	<cfreturn instance.filterChain />
</cffunction>

<cffunction name="setFilterChain" access="private" returntype="void" output="false">
	<cfargument name="filterChain" type="any" required="true">
	<cfset instance.filterChain = arguments.filterChain />
</cffunction>


</cfcomponent>