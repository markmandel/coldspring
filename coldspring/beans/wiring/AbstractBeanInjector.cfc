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
<cfcomponent hint="Abstract class bean injector for injecting dependencies into beans not managed by ColdSpring.
			 <br/>Credits to Brian Kotek for the original implementation for CS1.2"
			 implements="coldspring.beans.factory.BeanFactoryAware" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="wire" hint="inject all the dependencies for the target object" access="public" returntype="void" output="false">
	<cfargument name="object" hint="the object to dependency inject" type="any" required="Yes">
	<cfscript>
		var className = getMetadata(arguments.object).name;
		var cache = getBeanNameCache();
		var detail = 0;
		var injectDetails = 0;
		var bean = 0;
    </cfscript>

	<cfif NOT StructKeyExists(cache, className)>
    	<cflock name="coldspring.beans.wiring.AbstractBeanInjector.wire.#className#" throwontimeout="true" timeout="60">
	    	<cfif NOT StructKeyExists(cache, className)>
	    		<cfscript>
					injectDetails = calculateDependencyInjection(arguments.object);
					injectDetails = attemptInitialWire(arguments.object, injectDetails);

					cache[className] = injectDetails;
                </cfscript>
	    	</cfif>
    	</cflock>
    </cfif>

	<cfset injectDetails = cache[className]>
	<cfloop array="#injectDetails#" index="detail">
		<cfset bean = getBeanFactory().getBean(detail.beanName)>
		<cfinvoke component="#arguments.object#" method="#detail.methodName#">
			<cfinvokeargument name="#detail.argumentName#" value="#bean#">
		</cfinvoke>

		<cfif getDebugMode()>
			<cftrace type="information" text="Successfully injected bean '#detail.beanName#' into object of type '#className#'">
		</cfif>
	</cfloop>

</cffunction>

<cffunction name="setBeanFactory" access="public" hint="Callback that supplies the owning factory to a bean instance.
		Invoked after the population of normal bean properties but before an initialization callback such as
		a custom init-method." returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="yes" />
	<cfset instance.beanFactory = arguments.beanFactory />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor - abstract" access="private" returntype="void" output="false">
	<cfargument name="debugMode" hint="turns on extra debugging, that can be seeing in the trace view, if you can't work out why a bean isn't being injected"
				type="boolean" required="No" default="false">
	<cfscript>
		setBeanNameCache(StructNew());
		setDebugMode(arguments.debugMode);
	</cfscript>
</cffunction>

<cffunction name="calculateDependencyInjection" hint="abstract method: Needs to overwritten to determine the strategy used to wire the target object" access="private" returntype="array" output="false"
	colddoc:generic="struct">
	<cfargument name="object" hint="the target object" type="any" required="Yes">
	<cfset createObject("component", "coldspring.exception.AbstractMethodException").init("calculateDependencyInjection", this)>
</cffunction>

<cffunction name="attemptInitialWire" hint="attempt to wire up the bean with the passed in details. Returns only the details that injected successfully."
			access="private" returntype="array" output="false">
	<cfargument name="object" hint="the target object" type="any" required="Yes">
	<cfargument name="injectDetails" hint="the array of structs that represent the beans that will be injected" type="array" required="Yes" colddoc:generic="struct">
	<cfscript>
		var bean = 0;
		var detail = 0;
		var validDetails = [];
		var debug = 0;
    </cfscript>

	<cfloop array="#arguments.injectDetails#" index="detail">
		<cfset bean = getBeanFactory().getBean(detail.beanName)>

		<cftry>

			<cfinvoke component="#arguments.object#" method="#detail.methodName#">
				<cfinvokeargument name="#detail.argumentName#" value="#bean#">
			</cfinvoke>

			<cfset arrayAppend(validDetails, detail)>

			<cfcatch>
				<cfif getDebugMode()>
					<cfsavecontent variable="debug">
						<cfdump var="#cfcatch#">
					</cfsavecontent>
					<cftrace type="warning" text="#debug#">
				</cfif>
			</cfcatch>
		</cftry>
	</cfloop>

	<cfreturn validDetails />
</cffunction>

<cffunction name="getBeanFactory" access="private" returntype="coldspring.beans.BeanFactory" output="false">
	<cfreturn instance.beanFactory />
</cffunction>

<cffunction name="getBeanNameCache" access="private" returntype="struct" output="false" colddoc:generic="string,array">
	<cfreturn instance.beanNameCache />
</cffunction>

<cffunction name="setBeanNameCache" access="private" returntype="void" output="false" colddoc:generic="string,array">
	<cfargument name="beanNameCache" type="struct" required="true">
	<cfset instance.beanNameCache = arguments.beanNameCache />
</cffunction>

<cffunction name="getDebugMode" access="private" returntype="boolean" output="false">
	<cfreturn instance.debugMode />
</cffunction>

<cffunction name="setDebugMode" access="private" returntype="void" output="false">
	<cfargument name="debugMode" type="boolean" required="true">
	<cfset instance.debugMode = arguments.debugMode />
</cffunction>


</cfcomponent>