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

    	setReflectionService(getComponentMetadata("coldspring.core.reflect.ReflectionService").singleton.instance);

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

<cffunction name="calculateDependencyInjection" hint="Calculates the autowiring by name properties" access="private" returntype="array" output="false"
	colddoc:generic="struct">
	<cfargument name="object" hint="the target object" type="any" required="Yes">
	<cfscript>
		var class = getReflectionService().loadClass(getMetaData(arguments.object).name);

		var closure = getCalculateDependencyClosure().clone();

		//pass by reference please
		var injectDetails = createObject("java", "java.util.ArrayList").init();

		closure.bind("injectDetails", injectDetails);

		class.getMethodsCollection().each(closure);

		return closure.bound("injectDetails");
    </cfscript>
</cffunction>

<!--- closure method --->

<cffunction name="isMethodInjectable" hint="is this method useful for autowiring?, if it is, adds the details to the injectDetails method"
			access="private" returntype="void" output="false">
	<cfargument name="method" hint="The method to test" type="coldspring.core.reflect.Method" required="Yes">
	<cfscript>
		var propertyName = 0;
		var detail = 0;

		if(Lcase(arguments.method.getName()).startsWith("set"))
		{
			propertyName = replaceNoCase(arguments.method.getName(), "set", "");

			if(beanFactory.containsBean(propertyName) AND beanFactory.isAutowireCandidate(propertyName))
			{
				if(ArrayLen(arguments.method.getParameters()) eq 1)
				{
					detail =
					{
						beanName = propertyName
						,methodName = arguments.method.getName()
						,argumentName = arguments.method.getParameter(1).getName()
					};

					arrayAppend(injectDetails, detail);
				}
			}
		}
    </cfscript>
</cffunction>

<!--- /closure method --->

<cffunction name="getReflectionService" access="private" returntype="coldspring.core.reflect.ReflectionService" output="false">
	<cfreturn instance.reflectionService />
</cffunction>

<cffunction name="setReflectionService" access="private" returntype="void" output="false">
	<cfargument name="reflectionService" type="coldspring.core.reflect.ReflectionService" required="true">
	<cfset instance.reflectionService = arguments.reflectionService />
</cffunction>

<cffunction name="getCalculateDependencyClosure" access="private" returntype="coldspring.util.Closure" output="false">
	<cfreturn instance.calculateDependencyClosure />
</cffunction>

<cffunction name="setCalculateDependencyClosure" access="private" returntype="void" output="false">
	<cfargument name="calculateDependencyClosure" type="coldspring.util.Closure" required="true">
	<cfset instance.calculateDependencyClosure = arguments.calculateDependencyClosure />
</cffunction>

</cfcomponent>