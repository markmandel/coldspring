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

<cfinterface extends="coldspring.beans.factory.config.BeanPostProcessor"
	hint="Subinterface of BeanPostProcessor that adds a before-instantiation callback, and a callback after instantiation but before explicit properties are set or autowiring occurs.<br/>
	Typically used to suppress default instantiation for specific target beans, for example to create proxies with special TargetSources (pooling targets, lazily initializing targets, etc),
	or to implement additional injection strategies such as field injection.<br/>
	<strong>NOTE:</strong> This interface is a special purpose interface, mainly for internal use within the framework">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="postProcessBeforeInstantiation" hint="Apply this BeanPostProcessor before the target bean gets instantiated.
	The returned bean object may be a proxy to use instead of the target bean, effectively suppressing default instantiation of the target bean.<br/>
	If a non-null object is returned by this method, the bean creation process will be short-circuited.<br/>
	The only further processing applied is the BeanPostProcessor.postProcessAfterInitialization(java.lang.Object, java.lang.String) callback from the configured BeanPostProcessors.<br/>
	This callback will only be applied to bean definitions with a bean class. In particular, it will not be applied to beans with a 'factory-method'."
	access="public" returntype="any" output="false">
	<cfargument name="class" hint="The class meta data information of the bean about to be instantiated.
				For CFCs this will be a coldspring.core.reflect.Class, for Java objects it will be an instance of java.lang.Class"
				type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
</cffunction>

<cffunction name="postProcessAfterInstantiation" hint="Perform operations after the bean has been instantiated, via a constructor or factory method,
	but before ColdSpring property population (from explicit properties or autowiring) occurs.<br/>
    This is the ideal callback for performing field injection on the given bean instance.<br/>
	Return true if properties should be set on the bean; false if property population should be skipped.
	Normal implementations should return true. Returning false will also prevent any subsequent InstantiationAwareBeanPostProcessor instances being invoked on this bean instance."
	access="public" returntype="boolean" output="false">
	<cfargument name="bean" hint="the bean instance created, with properties not having been set yet" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>