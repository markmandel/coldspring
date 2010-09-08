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

<cffunction name="init" hint="Constructor" access="public" returntype="BeanPostProcessorObservable" output="false">
	<cfscript>
		setBaseObservable(createObject("component", "coldspring.util.Observable").init(baseProcessorNotifyCallback));

		return this;
	</cfscript>
</cffunction>

<cffunction name="addObserver" hint="Adds an observer" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to be added" type="coldspring.beans.factory.config.BeanPostProcessor" required="Yes">
	<cfscript>
		getBaseObservable().addObserver(arguments.observer);
    </cfscript>
</cffunction>

<cffunction name="postProcessBeforeInitialization" hint="Fires postProcessBeforeInitialization() on all BeanPostProcessors. Stops processing if null is returned from a processor."
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn getBaseObservable().postProcessBeforeInitialization(arguments.bean, arguments.beanName) />
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="Fires postProcessBeforeInitialization() on all BeanPostProcessors. Stops processing if null is returned from a processor."
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn getBaseObservable().postProcessAfterInitialization(arguments.bean, arguments.beanName) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="baseProcessorNotifyCallback" hint="notify method for each call to the observer" access="private" returntype="any" output="false">
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

<cffunction name="getBaseObservable" access="private" returntype="coldspring.util.Observable" output="false">
	<cfreturn instance.baseObservable />
</cffunction>

<cffunction name="setBaseObservable" access="private" returntype="void" output="false">
	<cfargument name="baseObservable" type="coldspring.util.Observable" required="true">
	<cfset instance.baseObservable = arguments.baseObservable />
</cffunction>

</cfcomponent>