﻿<!---
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

<cfcomponent hint="Factory for AOP proxies for programmatic use, rather than via a bean factory.<br/>
	This class provides a simple way of obtaining and configuring AOP proxies in code." output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ProxyFactory" output="false">
	<cfscript>
		//don't need to worry about concurency, and don't want to pass by value
		setDynamicProxyFactory(createObject("component", "coldspring.util.DynamicProxyFactory").init());
		setMethodFactory(createObject("component", "coldspring.reflect.MethodFactory").init());
		setHandlerCache(structNew());
		setAdvisors(createObject("java", "java.util.ArrayList").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="getProxy" hint="create a new proxy for this target, based on the factory settings" access="public" returntype="any" output="false">
	<cfargument name="target" hint="the target to create the proxy for" type="any" required="Yes">
	<cfscript>
		var handler = buildHandler(arguments.target);

		var proxy = getDynamicProxyFactory().createProxy(getMetaData(arguments.target).name, handler);

		return proxy;
    </cfscript>
</cffunction>

<cffunction name="addAdvisor" hint="adds an advisor to the end of the fiter chain.<br/>In ColdSpring, that means a PointcutAdvisor, but leaves us open to other types of advisors" access="public" returntype="void" output="false">
	<cfargument name="advisor" hint="the advisor to add to this proxy factory to be added to all beans being proxied" type="coldspring.aop.Advisor" required="Yes">
	<cfscript>
		arrayAppend(getAdvisors(), arguments.advisor);
    </cfscript>
</cffunction>

<cffunction name="getAdvisors" access="public" returntype="array" output="false" colddoc:generic="coldspring.aop.Advisor">
	<cfreturn instance.advisors />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildHandler" hint="build the AOP Proxy handler, if a version is not cached" access="public" returntype="ProxyInvocationHandler" output="false">
	<cfargument name="target" hint="the target to create the proxy for" type="any" required="Yes">
	<cfscript>
		var cache = getHandlerCache();
		var className = getMetadata(arguments.target).name;
		var handler = 0;

		if(!structKeyExists(cache, className))
		{
			//prep a version in the cache.
			handler = createObject("component", "ProxyInvocationHandler").init(className, getAdvisors(), getMethodFactory());
			cache[className] = handler;
		}

		handler = cache[className].clone();

		handler.setTarget(arguments.target);

		return handler;
    </cfscript>
</cffunction>

<cffunction name="setAdvisors" access="private" returntype="void" output="false">
	<cfargument name="advisors" type="array" required="true" colddoc:generic="coldspring.aop.Advisor">
	<cfset instance.advisors = arguments.advisors />
</cffunction>

<cffunction name="getDynamicProxyFactory" access="private" returntype="coldspring.util.DynamicProxyFactory" output="false">
	<cfreturn instance.dynamicProxyFactory />
</cffunction>

<cffunction name="setDynamicProxyFactory" access="private" returntype="void" output="false">
	<cfargument name="dynamicProxyFactory" type="coldspring.util.DynamicProxyFactory" required="true">
	<cfset instance.dynamicProxyFactory = arguments.dynamicProxyFactory />
</cffunction>

<cffunction name="getMethodFactory" access="private" returntype="coldspring.reflect.MethodFactory" output="false">
	<cfreturn instance.methodFactory />
</cffunction>

<cffunction name="setMethodFactory" access="private" returntype="void" output="false">
	<cfargument name="methodFactory" type="coldspring.reflect.MethodFactory" required="true">
	<cfset instance.methodFactory = arguments.methodFactory />
</cffunction>

<cffunction name="getHandlerCache" access="private" returntype="struct" output="false">
	<cfreturn instance.handlerCache />
</cffunction>

<cffunction name="setHandlerCache" access="private" returntype="void" output="false">
	<cfargument name="handlerCache" type="struct" required="true">
	<cfset instance.handlerCache = arguments.handlerCache />
</cffunction>

</cfcomponent>