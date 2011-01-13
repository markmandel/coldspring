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

<cfcomponent hint="Implementation of Observable for BeanPostProcessors, the intelligently dispathes events, depending on the type of BeanPostProcessor is in each collection" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	//constants
	instance.static = {};
	instance.static.INSTANTIATION_AWARE_CLASS = "coldspring.beans.factory.config.InstantiationAwareBeanPostProcessor";
</cfscript>

<cffunction name="init" hint="Constructor" access="public" returntype="BeanPostProcessorObservable" output="false">
	<cfscript>
		setBaseObservable(createObject("component", "coldspring.util.Observable").init(baseProcessorNotifyCallback, true));
		setBeforeInstantiationObservable(createObject("component", "coldspring.util.Observable").init(beforeInstantiationCallback));
		setAfterInstantiationObservable(createObject("component", "coldspring.util.Observable").init(afterInstantiationCallback));

		return this;
	</cfscript>
</cffunction>

<cffunction name="addObserver" hint="Adds an observer" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to be added" type="coldspring.beans.factory.config.BeanPostProcessor" required="Yes">
	<cfscript>
		if(isInstanceOf(arguments.observer, instance.static.INSTANTIATION_AWARE_CLASS))
		{
			getBeforeInstantiationObservable().addObserver(arguments.observer);
			getAfterInstantiationObservable().addObserver(arguments.observer);
		}

		getBaseObservable().addObserver(arguments.observer);
    </cfscript>
</cffunction>

<cffunction name="postProcessBeforeInstantiation" hint="Fires postProcessBeforeInstantiation() on all InstantiationAwareBeanPostProcessors.<br/>
			If a non-null object is returned by this method, the observer notification process will be stopped." access="public" returntype="any" output="false">
	<cfargument name="beanMetaData" hint="The class and/or meta data information of the bean about to be instantiated.
				For CFCs this will be coldspring.core.reflect.Class, for Java objects it will be an instance of java.lang.Class"
				type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn getBeforeInstantiationObservable().postProcessBeforeInstantiation(arguments.beanMetaData, arguments.beanName) />
</cffunction>

<cffunction name="postProcessAfterInstantiation" hint="Fires postProcessAfterInstantiation() on all InstantiationAwareBeanPostProcessors.<br/>
			If false is returned, the observer notification process will be stopped"
			access="public" returntype="boolean" output="false">
	<cfargument name="bean" hint="the bean instance created, with properties not having been set yet" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfscript>
		var local = {};
		local.return = getAfterInstantiationObservable().postProcessAfterInstantiation(arguments.bean, arguments.beanName);

		if(!structKeyExists(local, "return"))
		{
			return true;
		}

		return local.return;
    </cfscript>
</cffunction>

<cffunction name="postProcessBeforeInitialization" hint="Fires postProcessBeforeInitialization() on all BeanPostProcessors. Stops processing if null is returned from a processor."
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn getBaseObservable().postProcessBeforeInitialization(arguments.bean, arguments.beanName) />
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="Fires postProcessAfterInitialization() on all BeanPostProcessors. Stops processing if null is returned from a processor."
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn getBaseObservable().postProcessAfterInitialization(arguments.bean, arguments.beanName) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- observable callbacks --->

<cffunction name="baseProcessorNotifyCallback" hint="if null is returned, stop processing" access="private" returntype="any" output="false">
	<cfargument name="methodName" hint="the notify method being called" type="string" required="Yes">
	<cfargument name="methodArguments" hint="the method arguments" type="struct" required="Yes">
	<cfargument name="observer" hint="the observer" type="any" required="Yes">
	<cfargument name="return" hint="the returning value, if there is one" type="any" required="No">
	<cfscript>
		if(structKeyExists(arguments, "return"))
		{
			return true;
		}

		return false;
    </cfscript>
</cffunction>

<cffunction name="beforeInstantiationCallback" hint="If a non-null object is returned, stop processing" access="private" returntype="boolean" output="false">
	<cfargument name="methodName" hint="the notify method being called" type="string" required="Yes">
	<cfargument name="methodArguments" hint="the method arguments" type="struct" required="Yes">
	<cfargument name="observer" hint="the observer" type="any" required="Yes">
	<cfargument name="return" hint="the returning value, if there is one" type="any" required="No">
	<cfscript>
		if(!structKeyExists(arguments, "return"))
		{
			return true;
		}

		return false;
    </cfscript>
</cffunction>

<cffunction name="afterInstantiationCallback" hint="If false is returned, stop processing" access="private" returntype="boolean" output="false">
	<cfargument name="methodName" hint="the notify method being called" type="string" required="Yes">
	<cfargument name="methodArguments" hint="the method arguments" type="struct" required="Yes">
	<cfargument name="observer" hint="the observer" type="any" required="Yes">
	<cfargument name="return" hint="the returning value, if there is one" type="any" required="No">
	<cfscript>
		return arguments.return;
    </cfscript>
</cffunction>

<!--- /observable callbacks --->

<cffunction name="getBaseObservable" access="private" returntype="coldspring.util.Observable" output="false">
	<cfreturn instance.baseObservable />
</cffunction>

<cffunction name="setBaseObservable" access="private" returntype="void" output="false">
	<cfargument name="baseObservable" type="coldspring.util.Observable" required="true">
	<cfset instance.baseObservable = arguments.baseObservable />
</cffunction>

<cffunction name="getBeforeInstantiationObservable" access="private" returntype="coldspring.util.Observable" output="false">
	<cfreturn instance.beforeInstantiationObservable />
</cffunction>

<cffunction name="setBeforeInstantiationObservable" access="private" returntype="void" output="false">
	<cfargument name="beforeInstantiationObservable" type="coldspring.util.Observable" required="true">
	<cfset instance.beforeInstantiationObservable = arguments.beforeInstantiationObservable />
</cffunction>

<cffunction name="getAfterInstantiationObservable" access="private" returntype="coldspring.util.Observable" output="false">
	<cfreturn instance.afterInstantiationObservable />
</cffunction>

<cffunction name="setAfterInstantiationObservable" access="private" returntype="void" output="false">
	<cfargument name="afterInstantiationObservable" type="coldspring.util.Observable" required="true">
	<cfset instance.afterInstantiationObservable = arguments.afterInstantiationObservable />
</cffunction>


</cfcomponent>