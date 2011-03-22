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

<cfcomponent hint="FactoryBean implementation that builds an AOP proxy based on beans in ColdSpring BeanFactory." implements="coldspring.beans.factory.BeanFactoryAware,coldspring.beans.factory.FactoryBean" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ProxyFactoryBean" output="false">
	<cfscript>
		setSingleton(true);
		setProxyFactory(createObject("component", "ProxyFactory").init());
		setInterceptorsBuilt(false);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="Return a proxy.
	Invoked when clients obtain beans from this factory bean.
	Create an instance of the AOP proxy to be returned by this factory.
	The instance will be cached for a singleton, and create on each call to getObject() for a proxy. " access="public" returntype="any" output="false">
	<cfscript>
		if(NOT isInterceptorsBuilt())
		{
			buildInterceptors();
		}

		//store singleton
		if(isSingleton())
		{
			if(!hasProxySingleton())
			{
				setProxySingleton(getProxyFactory().getProxy(getTarget()));
			}

			return getProxySingleton();
		}

		return getProxyFactory().getProxy(getTarget());
    </cfscript>
</cffunction>

<cffunction name="getObjectType" access="public" returntype="string" output="false" hint="
	Return the type of the proxy. Will check the singleton instance if already created, else fall back to the proxy interface (in case of just a single one), the target bean type, or the TargetSource's target class.
	">
	<cfscript>
		if(hasTarget())
		{
			return getMetadata(getTarget()).name;
		}
		else if(hasTargetName() AND hasBeanFactory() AND getBeanFactory().containsBean(getTargetName()))
		{
			return getBeanFactory().getBeanDefinitionIncludingAncestor(getTargetName()).getClassName();
		}

		return "";
    </cfscript>
</cffunction>

<cffunction name="isSingleton" access="public" returntype="boolean" output="false" hint="
	Is the object managed by this factory a singleton? That is, will getObject() always return the same object (a reference that can be cached)?<br/>
	NOTE: If a FactoryBean indicates to hold a singleton object, the object returned from getObject() might get cached by the owning BeanFactory. Hence, do not return true unless the FactoryBean always exposes the same reference.<br/>
	The singleton status of the FactoryBean itself will generally be provided by the owning BeanFactory; usually, it has to be defined as singleton there.<br/>
	">
	<cfreturn instance.isSingleton />
</cffunction>

<cffunction name="setSingleton" access="public" hint="Set the value of the singleton property.
	Governs whether this factory should always return the same proxy instance (which implies the same target) or whether it should return a new prototype instance,
	which implies that the target and interceptors may be new instances also, if they are obtained from prototype bean definitions.
	This allows for fine control of independence/uniqueness in the object graph."
	returntype="void" output="false">
	<cfargument name="isSingleton" type="boolean" required="true">
	<cfset instance.isSingleton = arguments.isSingleton />
</cffunction>

<cffunction name="setBeanFactory" access="public" hint="Callback that supplies the owning factory to a bean instance.
		Invoked after the population of normal bean properties but before an initialization callback such as
		a custom init-method." returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="yes" />
	<cfset instance.beanFactory = arguments.beanFactory />
</cffunction>

<cffunction name="getTarget" access="public" returntype="any" output="false">
	<cfscript>
		var target = 0;

		//target will only get stored if this is singleton
		if(hasTarget())
		{
			return instance.target;
		}

		target = getBeanFactory().getBean(getTargetName());

		if(isSingleton())
		{
			setTarget(target);
		}

		return target;
    </cfscript>
</cffunction>

<cffunction name="getInterceptorNames" access="public" returntype="array" output="false">
	<cfreturn instance.interceptorNames />
</cffunction>

<cffunction name="setInterceptorNames" hint="Set the list of Advice/Advisor bean names. This can be set, as either a string list, or as an array,
	must always be set to use this factory bean in a bean factory.<br/>
	The referenced beans should be of type Advisor or Advice."
	access="public" returntype="void" output="false">
	<cfargument name="interceptorNames" type="any" required="true">

	<cfscript>
		if(isSimpleValue(arguments.interceptorNames))
		{
			arguments.interceptorNames = listToArray(arguments.interceptorNames);
		}

		instance.interceptorNames = arguments.interceptorNames;
    </cfscript>
</cffunction>

<cffunction name="hasInterceptorNames" hint="whether this object has interceptor names set against it (also returns false on an empty array)" access="public" returntype="boolean" output="false">
	<cfscript>
		if(!StructKeyExists(instance, "interceptorNames"))
		{
			return false;
		}

		return !arrayIsEmpty(getInterceptorNames());
    </cfscript>
</cffunction>

<cffunction name="setTarget" access="public" returntype="void" output="false">
	<cfargument name="target" type="any" required="true">
	<cfset instance.target = arguments.target />
</cffunction>

<cffunction name="hasTarget" hint="whether this object has a target" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "target") />
</cffunction>

<cffunction name="getTargetName" access="public" returntype="string" output="false">
	<cfreturn instance.targetName />
</cffunction>

<cffunction name="setTargetName" access="public" returntype="void" output="false">
	<cfargument name="targetName" type="string" required="true">
	<cfset instance.targetName = arguments.targetName />
</cffunction>

<cffunction name="hasTargetName" hint="whether this object has a target name" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "targetName") />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildInterceptors" hint="add all the interceptor named Advice/Advisor to the ProxyFactory" access="public" returntype="void" output="false">
	<cfscript>
		var interceptor = 0;
		var name = 0;
    </cfscript>
	<cflock name="coldspring.aop.framework.proxyFactoryBean.buildInterceptors" timeout="60" throwontimeout="true">
		<cfif NOT isInterceptorsBuilt()>
			<cfloop array="#getInterceptorNames()#" index="name">
				<cfscript>
					interceptor = getBeanFactory().getBean(name);

					if(isInstanceOf(interceptor, "coldspring.aop.Advisor"))
					{
						getProxyFactory().addAdvisor(interceptor);
					}
					else if(isInstanceOf(interceptor, "coldspring.aop.Advice"))
					{
						getProxyFactory().addAdvice(interceptor);
					}
					else
					{
						createObject("component", "coldspring.aop.framework.exception.InvalidInterceptorException").init(name, interceptor);
					}
                </cfscript>
			</cfloop>
		</cfif>
	</cflock>
</cffunction>

<cffunction name="getBeanFactory" access="private" returntype="coldspring.beans.BeanFactory" output="false">
	<cfreturn instance.beanFactory />
</cffunction>

<cffunction name="hasBeanFactory" hint="whether this object has a beanFactory" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "beanFactory") />
</cffunction>

<cffunction name="getProxySingleton" access="private" returntype="any" output="false">
	<cfreturn instance.proxySingleton />
</cffunction>

<cffunction name="setProxySingleton" access="private" returntype="void" output="false">
	<cfargument name="proxySingleton" type="any" required="true">
	<cfset instance.proxySingleton = arguments.proxySingleton />
</cffunction>

<cffunction name="hasProxySingleton" hint="whether this object has a proxy Singleton" access="private" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "proxySingleton") />
</cffunction>

<cffunction name="getProxyFactory" access="private" returntype="coldspring.aop.framework.ProxyFactory" output="false">
	<cfreturn instance.proxyFactory />
</cffunction>

<cffunction name="setProxyFactory" access="private" returntype="void" output="false">
	<cfargument name="proxyFactory" type="coldspring.aop.framework.ProxyFactory" required="true">
	<cfset instance.proxyFactory = arguments.proxyFactory />
</cffunction>

<cffunction name="isInterceptorsBuilt" access="private" returntype="boolean" output="false">
	<cfreturn instance.interceptorsBuilt />
</cffunction>

<cffunction name="setInterceptorsBuilt" access="private" returntype="void" output="false">
	<cfargument name="interceptorsBuilt" type="boolean" required="true">
	<cfset instance.interceptorsBuilt = arguments.interceptorsBuilt />
</cffunction>

</cfcomponent>