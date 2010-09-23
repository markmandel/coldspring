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

<cfcomponent hint="Bean Injector that autowires by setter property names" extends="AbstractBeanInjector" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AutowireByNameBeanInjector" output="false">
	<cfargument name="debugMode" hint="turns on extra debugging, that can be seeing in the trace view, if you can't work out why a bean isn't being injected"
				type="boolean" required="No" default="false">
	<cfscript>
		super.init(arguments.debugMode);

		setCFCMetaUtil(getComponentMetadata("coldspring.util.CFCMetaUtil").static.instance);

		setCalculateDependencyClosure(createObject("component", "coldspring.util.Closure").init(isMethodInjectable));

		return this;
	</cfscript>
</cffunction>

<cffunction name="setBeanFactory" access="public" hint="Callback that supplies the owning factory to a bean instance.
		Invoked after the population of normal bean properties but before an initialization callback such as
		a custom init-method." returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="yes" />
	<cfscript>
		super.setBeanFactory(arguments.beanFactory);

		//make the bean factory visible to the closure
		getCalculateDependencyClosure().bind("beanFactory", arguments.beanFactory);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="calculateDependencyInjection" hint="abstract method: Needs to overwritten to determine the strategy used to wire the target object" access="private" returntype="array" output="false"
	colddoc:generic="struct">
	<cfargument name="object" hint="the target object" type="any" required="Yes">
	<cfscript>
		var args = {};

		//pass by reference please
		args.injectDetails = createObject("java", "java.util.ArrayList").init();

		getCFCMetaUtil().eachMetaFunction(getMetadata(arguments.object), getCalculateDependencyClosure(), args);

		return args.injectDetails;
    </cfscript>
</cffunction>

<!--- closure method --->

<cffunction name="isMethodInjectable" hint="is this method useful for autowiring?, if it is, adds the details to the injectDetails method"
			access="private" returntype="void" output="false">
	<cfargument name="func" hint="the function meta data" type="struct" required="Yes">
	<cfargument name="injectDetails" hint="the injection details array" type="array" required="Yes" colddoc:generic="struct">
	<cfscript>
		var propertyName = 0;
		var detail = 0;

		if(Lcase(arguments.func.name).startsWith("set") AND arguments.func.access eq "public")
		{
			propertyName = replaceNoCase(arguments.func.name, "set", "");

			if(variables.beanFactory.containsBean(propertyName) AND variables.beanFactory.isAutowireCandidate(propertyName))
			{
				if(StructKeyExists(arguments.func, "parameters")
					AND ArrayLen(arguments.func.parameters) eq 1)
				{
					detail =
					{
						beanName = propertyName
						,methodName = arguments.func.name
						,argumentName = arguments.func.parameters[1].name
					};

					arrayAppend(arguments.injectDetails, detail);
				}
			}
		}
    </cfscript>
</cffunction>

<!--- /closure method --->

<cffunction name="getCFCMetaUtil" access="private" returntype="coldspring.util.CFCMetaUtil" output="false">
	<cfreturn instance.cfcMetaUtil />
</cffunction>

<cffunction name="setCFCMetaUtil" access="private" returntype="void" output="false">
	<cfargument name="cfcMetaUtil" type="coldspring.util.CFCMetaUtil" required="true">
	<cfset instance.cfcMetaUtil = arguments.cfcMetaUtil />
</cffunction>

<cffunction name="getCalculateDependencyClosure" access="private" returntype="coldspring.util.Closure" output="false">
	<cfreturn instance.calculateDependencyClosure />
</cffunction>

<cffunction name="setCalculateDependencyClosure" access="private" returntype="void" output="false">
	<cfargument name="calculateDependencyClosure" type="coldspring.util.Closure" required="true">
	<cfset instance.calculateDependencyClosure = arguments.calculateDependencyClosure />
</cffunction>

</cfcomponent>