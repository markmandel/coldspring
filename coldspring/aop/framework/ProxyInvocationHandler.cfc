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

<cfcomponent hint="Invocation Handler for AOP Proxies" implements="coldspring.core.proxy.InvocationHandler">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	meta = getMetaData(this);

	if(!StructKeyExists(meta, "const"))
	{
		const = {};
		const.ON_MISSING_METHOD = "onMissingMethod";

		meta.const = const;
	}
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="ProxyInvocationHandler" output="false">
	<cfargument name="className" hint="the class name of the object that is being proxied" type="string" required="Yes">
	<cfargument name="advisors" hint="array of ordered advisors to use to match against the target's methods" type="array" required="Yes"
				colddoc:generic="coldspring.aop.Advisor">
	<cfscript>
    	var reflectionService = getComponentMetadata("coldspring.core.reflect.ReflectionService").singleton.instance;
    	var pointCutClosure = createObject("component", "coldspring.util.Closure").init(applyPointcutAdvice);
    	var class = reflectionService.loadClass(arguments.className);

		setMethodAdvice(StructNew());

		pointCutClosure.bind("advisors", arguments.advisors);
		pointCutClosure.bind("methodAdvice", getMethodAdvice());

		class.getMethodsCollection().each(pointCutClosure);

		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="Processes a method invocation one a proxy instance and returns the result.
	This method will be invoked on an invocation handler when a method is invoked on a proxy instance that it is assosciated with." access="public" returntype="any" output="false">
	<cfargument name="proxy" type="any" required="yes" />
	<cfargument name="method" type="string" required="yes" />
	<cfargument name="args" type="struct" required="yes" />
	<cfscript>
		var local = {};
    </cfscript>

	<cfif structKeyExists(getMethodAdvice(), arguments.method)>
		<cfscript>
			//build method invocation, and pass through the filter chain for AOP
			local.method = getTargetClass().getMethod(arguments.method);

			local.filterChain = structFind(getMethodAdvice(), arguments.method).iterator();

			local.methodInvocation = createObject("component", "coldspring.aop.MethodInvocation").init(local.method, getTarget(), arguments.proxy, arguments.args, local.filterChain);

			return local.methodInvocation.proceed();
        </cfscript>
    <cfelseif !StructKeyExists(getTargetClass().getMethods(), arguments.method) && getTargetClass().hasOnMissingMethod() && StructKeyExists(getMethodAdvice(), meta.const.ON_MISSING_METHOD)>
    	<cfscript>
			local.method = getTargetClass().getMethod(arguments.method);

			//get the filter chain for onMM
			local.filterChain = structFind(getMethodAdvice(), meta.const.ON_MISSING_METHOD).iterator();

			local.methodInvocation = createObject("component", "coldspring.aop.MethodInvocation").init(local.method, getTarget(), arguments.proxy, arguments.args, local.filterChain);

			return local.methodInvocation.proceed();
        </cfscript>
	<cfelse>
		<cfinvoke component="#getTarget()#" method="#arguments.method#" argumentcollection="#arguments.args#" returnvariable="local.return">

		<cfif structKeyExists(local, "return")>
			<cfreturn local.return />
		</cfif>
	</cfif>
</cffunction>

<cffunction name="getTarget" hint="The target of the proxy" access="public" returntype="any" output="false">
	<cfreturn instance.target />
</cffunction>

<cffunction name="setTarget" hint="Set the target of the proxy" access="public" returntype="void" output="false">
	<cfargument name="target" type="any" required="true">
	<cfscript>
		var reflectionService = getComponentMetaData("coldspring.core.reflect.ReflectionService").singleton.instance;
		instance.target = arguments.target;
		setTargetClass(reflectionService.loadClass(getMetadata(arguments.target).name));
    </cfscript>
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="ProxyInvocationHandler" output="false">
	<cfscript>
		var cloneable = getComponentMetadata("coldspring.util.Cloneable").singleton.instance;

		return cloneable.clone(this);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		StructDelete(arguments.instance, "target");
		structDelete(arguments.instance, "targetClass");

		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<cffunction name="getMethodAdvice" access="private" returntype="struct" output="false" colddoc:generic="string,coldspring.aop.MethodInterceptor">
	<cfreturn instance.methodAdvice />
</cffunction>

<cffunction name="setMethodAdvice" access="private" returntype="void" output="false">
	<cfargument name="methodAdvice" type="struct" required="true" colddoc:generic="string,coldspring.aop.MethodInterceptor">
	<cfset instance.methodAdvice = arguments.methodAdvice />
</cffunction>

<cffunction name="getTargetClass" access="private" returntype="coldspring.core.reflect.Class" output="false">
	<cfreturn instance.targetClass />
</cffunction>

<cffunction name="setTargetClass" access="private" returntype="void" output="false">
	<cfargument name="targetClass" type="coldspring.core.reflect.Class" required="true">
	<cfset instance.targetClass = arguments.targetClass />
</cffunction>

<!--- closure methods --->

<cffunction name="applyPointcutAdvice" hint="closure methods for applying pointcut advice" access="public" returntype="void" output="false">
	<cfargument name="method" hint="the class method" type="coldspring.core.reflect.Method" required="Yes">
	<cfscript>
		var advisor = 0;
		var advice = 0;
		var interceptor = 0;

		//if you get non-method types of AOP, may want to do type checking on pointcuts and advice
    </cfscript>
	<cfloop array="#variables.advisors#" index="advisor">
		<cfscript>
			if(advisor.getPointcut().matches(arguments.method, arguments.method.$getClass()))
			{
				if(!structKeyExists(variables.methodAdvice, arguments.method.getName()))
				{
					variables.methodAdvice[arguments.method.getName()] = [];
				}

				advice = advisor.getAdvice();

				//depending on type, switch it out for the implementing MethodInterceptor
				if(isInstanceOf(advice, "coldspring.aop.AfterReturningAdvice"))
				{
					interceptor = createObject("component", "coldspring.aop.framework.adapter.AfterReturningAdviceInterceptor").init(advice);
				}
				else if(isInstanceOf(advice, "coldspring.aop.MethodBeforeAdvice"))
				{
					interceptor = createObject("component", "coldspring.aop.framework.adapter.MethodBeforeAdviceInterceptor").init(advice);
				}
				else if(isInstanceOf(advice, "coldspring.aop.ThrowsAdvice"))
				{
					interceptor = createObject("component", "coldspring.aop.framework.adapter.ThrowsAdviceInterceptor").init(advice);
				}
				else
				{
					interceptor = advice;
				}

				/*
					You have to go forward down the chain.
					Items that are added first have the highest priority - and should be hit
					first on the way in, and last on the way out.
				*/
				ArrayAppend(variables.methodAdvice[arguments.method.getName()], interceptor);
			}
        </cfscript>
	</cfloop>
</cffunction>

<!--- /closure methods --->

</cfcomponent>