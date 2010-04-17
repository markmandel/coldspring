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

<cfcomponent hint="Manages the various different scopes for Beans. Supports: singleton, prototype, request and session" output="false">

<cfscript>
	//set some constrants
	instance.static.SCOPE_KEY = "coldspring.#createUUID()#";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanCache" output="false">
	<cfargument name="javaLoader" hint="accesss to loaded java libraries" type="coldspring.util.java.JavaLoader" required="true">
	<cfscript>
		setJavaLoader(arguments.javaLoader);

		setSingletonCache(StructNew());
		setPrototypeCache(getJavaLoader().create("org.coldspring.util.DummyMap").init());

		setSystem(createObject("java", "java.lang.System"));
		setThread(createObject("java", "java.lang.Thread"));

		initCacheCommandMap();
		initLockNameCommandMap();

		return this;
	</cfscript>
</cffunction>

<cffunction name="getCache" hint="gets a cache (struct) for a given scope. We use a simple struct for performance" access="public" returntype="struct" output="false"
	colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfargument name="scope" hint="the bean scope" type="string" required="Yes">
	<cfscript>
		var call = structFind(getCacheCommandMap(), arguments.scope);

		return call();
    </cfscript>
</cffunction>

<cffunction name="getLockName" hint="returns the required lock name for creating a cached version of a given bean" access="public" returntype="string" output="false">
	<cfargument name="beanDef" hint="the bean Definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		var call = StructFind(getLockNameCommandMap(), arguments.beanDef.getScope());

		return call(argumentCollection=arguments);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initLockNameCommandMap" hint="initialises the lock name command map" access="public" returntype="void" output="false">
	<cfscript>
		var map = {
			singleton = getSingletonLockName
			,prototype = getPrototypeLockName
			,request = getRequestLockName
			,session = getSessionLockName
		};

		setLockNameCommandMap(map);
    </cfscript>
</cffunction>

<cffunction name="initCacheCommandMap" hint="initialises the cache command map" access="private" returntype="void" output="false">
	<cfscript>
		var map = {
			singleton = getSingletonCache
			,prototype = getPrototypeCache
			,request = getRequestCache
			,session = getSessionCache
		};

		setCacheCommandMap(map);
    </cfscript>
</cffunction>

<cffunction name="getSessionCache" hint="gets a cache for the session scope" access="private" returntype="struct" output="false"
			colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfif NOT StructKeyExists(session, instance.static.SCOPE_KEY)>
    	<cflock name="coldspring.beans.beancache.getsessioncache.#getSystem().identityHashCode(session)#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(NOT StructKeyExists(session, instance.static.SCOPE_KEY))
    		{
				session[instance.static.SCOPE_KEY] = {};
			}
    	</cfscript>
    	</cflock>
    </cfif>
	<cfreturn session[instance.static.SCOPE_KEY] />
</cffunction>

<cffunction name="getSessionLockName" hint="gets the locking name for a session scoped bean" access="private" returntype="string" output="false">
	<cfargument name="beanDef" hint="the bean Definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		return "coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getSystem().identityHashCode(session)#";
    </cfscript>
</cffunction>

<cffunction name="getRequestCache" hint="gets a cache for the request scope" access="private" returntype="struct" output="false"
			colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfif NOT StructKeyExists(request, instance.static.SCOPE_KEY)>
    	<cflock name="coldspring.beans.beancache.getrequestcache.#getSystem().identityHashCode(request)#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(NOT StructKeyExists(request, instance.static.SCOPE_KEY))
    		{
				request[instance.static.SCOPE_KEY] = {};
			}
    	</cfscript>
    	</cflock>
    </cfif>
	<cfreturn request[instance.static.SCOPE_KEY] />
</cffunction>

<cffunction name="getRequestLockName" hint="gets the locking name for a request scoped bean" access="private" returntype="string" output="false">
	<cfargument name="beanDef" hint="the bean Definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		return "coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getSystem().identityHashCode(request)#";
    </cfscript>
</cffunction>

<cffunction name="getPrototypeCache" hint="returns the cache for the prototype cache, which caches nothing" access="private" returntype="struct" output="false"
			colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfscript>
		return instance.prototypeCache;
    </cfscript>
</cffunction>

<cffunction name="getPrototypeLockName" hint="gets the locking name for a prototype scoped bean" access="private" returntype="string" output="false">
	<cfargument name="beanDef" hint="the bean Definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		return "coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getThread().currentThread().getName()#";
    </cfscript>
</cffunction>

<cffunction name="getSingletonCache" access="private" returntype="struct" output="false"
			colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfreturn instance.singletonCache />
</cffunction>

<cffunction name="getSingletonLockName" hint="gets the locking name for a singleton scoped bean" access="private" returntype="string" output="false">
	<cfargument name="beanDef" hint="the bean Definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		//do identity hash code on this, so multiple CS's with the same bean name don't clash
		return "coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getSystem().identityHashCode(this)#";
    </cfscript>
</cffunction>

<cffunction name="setSingletonCache" access="private" returntype="void" output="false">
	<cfargument name="singletonCache" type="struct" required="true"
				colddoc:generic="string,coldspring.beans.support.AbstractBeanDefinition">
	<cfset instance.singletonCache = arguments.singletonCache />
</cffunction>

<cffunction name="setPrototypeCache" access="private" returntype="void" output="false">
	<cfargument name="prototypeCache" type="struct" required="true">
	<cfset instance.prototypeCache = arguments.prototypeCache />
</cffunction>

<cffunction name="getSystem" access="private" returntype="any" output="false">
	<cfreturn instance.system />
</cffunction>

<cffunction name="setSystem" access="private" returntype="void" output="false">
	<cfargument name="system" type="any" required="true">
	<cfset instance.system = arguments.system />
</cffunction>

<cffunction name="getThread" access="private" returntype="any" output="false">
	<cfreturn instance.Thread />
</cffunction>

<cffunction name="setThread" access="private" returntype="void" output="false">
	<cfargument name="Thread" type="any" required="true">
	<cfset instance.Thread = arguments.Thread />
</cffunction>

<cffunction name="getCacheCommandMap" access="private" returntype="struct" output="false">
	<cfreturn instance.cacheCommandMap />
</cffunction>

<cffunction name="setCacheCommandMap" access="private" returntype="void" output="false">
	<cfargument name="cacheCommandMap" type="struct" required="true">
	<cfset instance.cacheCommandMap = arguments.cacheCommandMap />
</cffunction>

<cffunction name="getLockNameCommandMap" access="private" returntype="struct" output="false">
	<cfreturn instance.lockNameCommandMap />
</cffunction>

<cffunction name="setLockNameCommandMap" access="private" returntype="void" output="false">
	<cfargument name="lockNameCommandMap" type="struct" required="true">
	<cfset instance.lockNameCommandMap = arguments.lockNameCommandMap />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldspring.util.java.JavaLoader" output="false">
	<cfreturn instance.javaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="javaLoader" type="coldspring.util.java.JavaLoader" required="true">
	<cfset instance.javaLoader = arguments.javaLoader />
</cffunction>

</cfcomponent>