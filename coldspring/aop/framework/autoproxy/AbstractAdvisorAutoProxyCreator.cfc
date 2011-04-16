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

<cfcomponent hint="Generic auto proxy creator that builds AOP proxies for specific beans based on detected Advisors for each bean.<br/>
		Subclasses must implement the abstract findCandidateAdvisors() method to return a list of Advisors applying to any object"
		implements="coldspring.beans.factory.BeanFactoryAware,coldspring.beans.factory.config.InstantiationAwareBeanPostProcessor"
		output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="DefaultAdvisorAutoProxyCreator" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeforeInstantiation" hint="Generates the AOP proxy for the given bean, if any Advisors match this bean"
	access="public" returntype="any" output="false">
	<cfargument name="class" hint="The class and/or meta data information of the bean about to be instantiated.
				For CFCs this will be the results of getMetaData(), for Java objects it will be an instance of java.lang.Class"
				type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfscript>
    	var createProxyCache = getCreateProxyCache();
		var beanDef = getBeanFactory().getBeanDefinition(arguments.beanName);
		var className = beanDef.getClassName();
    </cfscript>

	<cfif !StructKeyExists(createProxyCache, className)>
    	<cflock name="coldspring.aop.framework.autoproxy.AdvisorAutoProxy.postProcessAfterInstantiation.#className#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(!StructKeyExists(createProxyCache, className))
    		{
				//if not done cache lookup, do it now
				createProxyCache[className] = checkIsAOPCandidate(beanDef);
    		}
    	</cfscript>
    	</cflock>
    </cfif>

	<cfscript>
		//if matches an AOP Advice, return a proxy
		if(createProxyCache[className])
		{
			return getProxyFactory().getProxy(beanDef.create());
		}
    </cfscript>
</cffunction>

<cffunction name="postProcessAfterInstantiation" hint="Always returns true"
	access="public" returntype="boolean" output="false">
	<cfargument name="bean" hint="the bean instance created, with properties not having been set yet" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfscript>
		return true;
    </cfscript>
</cffunction>

<cffunction name="postProcessBeforeInitialization" hint="Returns the current bean"
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn arguments.bean />
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="Returns the current bean"
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn arguments.bean />
</cffunction>

<cffunction name="setBeanFactory" access="public" hint="Callback that supplies the owning factory to a bean instance.
		Invoked after the population of normal bean properties but before an initialization callback such as
		a custom init-method." returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="yes" />
	<cfscript>
		instance.beanFactory = arguments.beanFactory;

		//initialise all the advisors
		initProxyFactory();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="findCandidateAdvisors" hint="abstract method: Find all candidate Advisors to use in auto-proxying." access="private" returntype="array" output="false"
	colddoc:generic="coldspring.aop.Advisor">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init(this, "findCandidateAdvisors")>
</cffunction>

<cffunction name="initProxyFactory" hint="initialises the proxy factory with all it's required advisors" access="public" returntype="void" output="false">
	<cfscript>
		var advisors = findCandidateAdvisors();
		var orderedComparator = getComponentMetadata("coldspring.core.OrderComparator").singleton.instance;

		setCreateProxyCache(StructNew());

		setProxyFactory(createObject("component", "coldspring.aop.framework.ProxyFactory").init());

    	//pass the advisorNames into a Collection for sorting
		advisors = orderedComparator.sort(advisors).getCollection();
		getProxyFactory().addAdvisors(advisors);
		setAdvisors(advisors);
    </cfscript>
</cffunction>

<cffunction name="checkIsAOPCandidate" hint="Check to see if this bean is an AOP candidate, against the given set of Advisors" access="public" returntype="boolean" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to check" type="coldspring.beans.support.BeanDefinition" required="Yes">

	<cfscript>
		var advisors = getAdvisors();
		var class = arguments.beanDefinition.$getClass();
		var methods = class.getMethods();
		var method = 0;
		var key = 0;
		var advisor = 0;
	</cfscript>

	<cfloop collection="#methods#" item="key">
		<cfset method = methods[key]>

		<cfloop array="#advisors#" index="advisor">
			<cfscript>
	            if(advisor.getPointcut().matches(method, class))
				{
					return true;
				}
            </cfscript>
		</cfloop>
	</cfloop>

	<cfscript>
		return false;
    </cfscript>
</cffunction>

<cffunction name="getBeanFactory" access="private" returntype="coldspring.beans.BeanFactory" output="false">
	<cfreturn instance.beanFactory />
</cffunction>

<cffunction name="getProxyFactory" access="private" returntype="coldspring.aop.framework.ProxyFactory" output="false">
	<cfreturn instance.proxyFactory />
</cffunction>
<cffunction name="setProxyFactory" access="private" returntype="void" output="false">
	<cfargument name="proxyFactory" type="coldspring.aop.framework.ProxyFactory" required="true">
	<cfset instance.proxyFactory = arguments.proxyFactory />
</cffunction>

<cffunction name="getAdvisors" access="private" returntype="array" output="false" colddoc:generic="coldspring.aop.Advisor">
	<cfreturn instance.advisors />
</cffunction>

<cffunction name="setAdvisors" access="private" returntype="void" output="false">
	<cfargument name="advisors" type="array" required="true" colddoc:generic="coldspring.aop.Advisor">
	<cfset instance.advisors = arguments.advisors />
</cffunction>

<cffunction name="getCreateProxyCache" access="private" returntype="struct" output="false" colddoc:generic="string,string">
	<cfreturn instance.createProxyCache />
</cffunction>

<cffunction name="setCreateProxyCache" access="private" returntype="void" output="false">
	<cfargument name="createProxyCache" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.createProxyCache = arguments.createProxyCache />
</cffunction>

</cfcomponent>