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

<cfcomponent hint="Factory for generating dyanamic proxies of beans" output="false">

<cfscript>
	instance.static.PROXY_KEY = "__$proxy";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="DynamicProxyFactory" output="false">
	<cfscript>
		setProxyPrototypeCache(StructNew());
		setMethodInjector(createObject("component", "MethodInjector").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="createProxy" hint="creates a dynamic proxy for a specific type of component.
			<br/>Dynamic proxies cannot be created for any CFCs that have code in the pseudo constructor that could fail when createObject is called"
			access="public" returntype="any" output="false">
	<cfargument name="className" hint="the name of the class to create a proxy for" type="string" required="Yes">
	<cfargument name="handler" hint="the Invocation handler that is associated with this dynamic proxy" type="any" required="Yes" colddoc:generic="InvocationHandler">
	<cfscript>
		var cache = getProxyPrototypeCache();
		var proxy = 0;

		if(NOT structKeyExists(cache, arguments.className))
		{
			buildProxy(argumentCollection=arguments);
		}

		proxy = duplicate(structFind(cache, arguments.className));

		proxy.__$setInvocationHandler(arguments.handler);

		return proxy;
    </cfscript>
</cffunction>

<cffunction name="isProxy" hint="is the object passed in a dynamic proxy?" access="public" returntype="boolean" output="false">
	<cfargument name="object" hint="the object in question" type="any" required="Yes">
	<cfscript>
		return structKeyExists(arguments.object, instance.static.PROXY_KEY);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildProxy" hint="builds a prototype for the proxy, and places it in the prototype cacahe" access="private" returntype="void" output="false">
	<cfargument name="className" hint="the name of the class to create a proxy for" type="string" required="Yes">
	<cfscript>
		//we don't call init, because we only want an intance we can manipulate
		var proxy = createObject("component", arguments.className);
		var injector = getMethodInjector();

		injector.start(proxy);

		injector.injectMethod(proxy, clean, "public");

		proxy.clean();

		//start again, as proxy has just been cleaned
		injector.start(proxy);

		injector.injectMethod(proxy, onMissingMethod, "public");
		injector.injectMethod(proxy, __$setInvocationHandler, "public");
		injector.injectMethod(proxy, __$getInvocationHandler, "public");

		injector.stop(proxy);

		//set the proxy key, so we can check if something is a proxy
		proxy[instance.static.PROXY_KEY] = 1;

		//not going to bother locking, as it's no bg deal if we end up doing this more than once.
		structInsert(getProxyPrototypeCache(), arguments.className, proxy, true);
    </cfscript>
</cffunction>

<!--- mixins --->

<cffunction	name="onMissingMethod" access="private" returntype="any" output="false" hint="Mixin: used to provide the method interception on the proxy">
	<cfargument	name="missingMethodName" type="string"	required="true"	hint=""	/>
	<cfargument	name="missingMethodArguments" type="struct" required="true"	hint=""/>
	<cfscript>
		var args = {
			proxy = this
			,method = arguments.missingMethodName
			,args = arguments.missingMethodArguments
		};

		return __$getInvocationHandler().invokeMethod(argumentCollection=args);
    </cfscript>
</cffunction>

<cffunction name="clean" hint="clean the CFC out of all it's previous stuff - UDFs, variables, etc" access="private" returntype="void" output="false">
	<cfscript>
		//var thisScope = variables.this;

		structClear(variables);
		structClear(this);

		variables.this = this;
    </cfscript>
</cffunction>

<cffunction name="__$getInvocationHandler" access="private" returntype="any" output="false" colddoc:generic="InvocationHandler">
	<cfreturn instance.__$invocationHandler />
</cffunction>

<cffunction name="__$setinvocationHandler" access="private" returntype="void" output="false">
	<cfargument name="__$invocationHandler" type="any" required="true" colddoc:generic="InvocationHandler">
	<cfset instance.__$invocationHandler = arguments.__$invocationHandler />
</cffunction>

<!--- /mixins --->

<cffunction name="getProxyPrototypeCache" access="private" returntype="struct" output="false" colddoc:generic="string,component">
	<cfreturn instance.proxyPrototypeCache />
</cffunction>

<cffunction name="setProxyPrototypeCache" access="private" returntype="void" output="false">
	<cfargument name="proxyPrototypeCache" type="struct" required="true" colddoc:generic="string,component">
	<cfset instance.proxyPrototypeCache = arguments.proxyPrototypeCache />
</cffunction>

<cffunction name="getMethodInjector" access="private" returntype="MethodInjector" output="false">
	<cfreturn instance.methodInjector />
</cffunction>
<cffunction name="setMethodInjector" access="private" returntype="void" output="false">
	<cfargument name="methodInjector" type="MethodInjector" required="true">
	<cfset instance.methodInjector = arguments.methodInjector />
</cffunction>



</cfcomponent>