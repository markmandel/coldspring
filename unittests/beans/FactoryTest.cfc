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

<cfcomponent hint="test for the factory beans" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="the setup for the tests" access="public" returntype="void" output="false">
	<cfscript>
		instance.factory = createObject("component", "unittests.testBeans.BeanFactory").init();
    </cfscript>
</cffunction>

<cffunction name="beanCacheGetCacheTest" hint="tests for the bean cache" access="public" returntype="void" output="false">
	<cfscript>
		var jl = createObject("component", "coldspring.util.java.JavaLoader").init("unittests");
		var local = {};

		local.beanCache = createObject("component", "coldspring.beans.factory.BeanCache").init(jl);

		//singleton
		local.sCache1 = local.beanCache.getCache("singleton");
		local.sCache1.uuid = createUUID();

		local.sCache2 = local.beanCache.getCache("singleton");

		AssertEquals(local.sCache1.uuid, local.sCache2.uuid, "Singleton cache should be the same");

		//prototype
		local.sCache1 = local.beanCache.getCache("prototype");
		local.sCache1.uuid = createUUID();

		local.sCache2 = local.beanCache.getCache("prototype");

		AssertFalse(structKeyExists(local.sCache1, "uuid"));
		AssertFalse(structKeyExists(local.sCache2, "uuid"));

		local.sCache2 = local.beanCache.getCache("prototype");

		AssertFalse(structKeyExists(local.sCache2, "uuid"), "UUID should no longer be on the prototype cache");

		//request
		local.sCache1 = local.beanCache.getCache("request");
		local.sCache1.uuid = createUUID();

		local.sCache2 = local.beanCache.getCache("request");

		AssertEquals(local.sCache1.uuid, local.sCache2.uuid, "request cache should be the same");

		local.check = false;
		local.keys = structKeyArray(request);

		local.len = ArrayLen(local.keys);
        for(local.counter=1; local.counter lte local.len; local.counter++)
        {
        	local.key = local.keys[local.counter];

			if(local.key.startsWith("coldspring."))
			{
				local.check = true;
			}
        }

		AssertTrue(local.check,"could not find the coldspring cache in request");

		//session
		local.sCache1 = local.beanCache.getCache("session");
		local.sCache1.uuid = createUUID();

		local.sCache2 = local.beanCache.getCache("session");

		AssertEquals(local.sCache1.uuid, local.sCache2.uuid, "session cache should be the same");

		local.check = false;
		local.keys = structKeyArray(session);

		local.len = ArrayLen(local.keys);
        for(local.counter=1; local.counter lte local.len; local.counter++)
        {
        	local.key = local.keys[local.counter];

			if(local.key.startsWith("coldspring."))
			{
				local.check = true;
			}
        }

		AssertTrue(local.check,"could not find the coldspring cache in session");
    </cfscript>
</cffunction>

<cffunction name="beanCacheGetLockNameTest" hint="tests the lock names coming out of the beanCache" access="public" returntype="void" output="false">
	<cfscript>
		var jl = createObject("component", "coldspring.util.java.JavaLoader").init("unittests");
		var local = {};

		local.beanCache = createObject("component", "coldspring.beans.factory.BeanCache").init(jl);
		local.System = createObject("java", "java.lang.System");
		local.Thread = createObject("java", "java.lang.Thread");

		//singleton
		local.car = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("car", instance.factory.getBeanDefinitionRegistry());
		local.car.setClassName("unittests.testBeans.Car");

		local.lockname = local.beanCache.getLockName(local.car);

		//"coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getSystem().identityHashCode(this)#";
		AssertEquals("coldspring.beans.support.beandefinition.createInstance.#local.car.getID()#.#local.System.identityHashCode(local.beanCache)#", local.lockname);

		//prototype
		local.car.setScope("prototype");

		local.lockname = local.beanCache.getLockName(local.car);

		//"coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getThread().currentThread().getName()#";
		AssertEquals("coldspring.beans.support.beandefinition.createInstance.#local.car.getID()#.#local.Thread.currentThread().getName()#", local.lockname);

		//request
		local.car.setScope("request");

		local.lockname = local.beanCache.getLockName(local.car);

		//"coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getSystem().identityHashCode(request)#";
		AssertEquals("coldspring.beans.support.beandefinition.createInstance.#local.car.getID()#.#local.System.identityHashCode(request)#", local.lockname);

		//session
		local.car.setScope("session");

		local.lockname = local.beanCache.getLockName(local.car);

		//"coldspring.beans.support.beandefinition.createInstance.#arguments.beanDef.getID()#.#getSystem().identityHashCode(session)#";
		AssertEquals("coldspring.beans.support.beandefinition.createInstance.#local.car.getID()#.#local.System.identityHashCode(session)#", local.lockname);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>