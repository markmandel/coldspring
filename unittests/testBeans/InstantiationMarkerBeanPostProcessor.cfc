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

<cfcomponent hint="Places marks on beans to show that processing has occured" implements="coldspring.beans.factory.config.InstantiationAwareBeanPostProcessor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="InstantiationMarkerBeanPostProcessor" output="false">
	<cfscript>
		setKey("instance_#createUUID()#");

		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeforeInstantiation" hint="Apply this BeanPostProcessor before the target bean gets instantiated.
The returned bean object may be a proxy to use instead of the target bean, effectively suppressing default instantiation of the target bean.<br/>
If a non-null object is returned by this method, the bean creation process will be short-circuited.<br/>
The only further processing applied is the BeanPostProcessor.postProcessAfterInitialization(java.lang.Object, java.lang.String) callback from the configured BeanPostProcessors.<br/>
This callback will only be applied to bean definitions with a bean class. In particular, it will not be applied to beans with a 'factory-method'." access="public" returntype="any" output="false">
	<cfargument name="beanMetaData" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfscript>
		arguments.beanMetaData[getKey()& "_BeforeInstantiation"] = 1;
    </cfscript>
</cffunction>

<cffunction name="postProcessAfterInstantiation" hint="Perform operations after the bean has been instantiated, via a constructor or factory method,
but before ColdSpring property population (from explicit properties or autowiring) occurs.<br/>
This is the ideal callback for performing field injection on the given bean instance.<br/>
Return true if properties should be set on the bean; false if property population should be skipped.
Normal implementations should return true. Returning false will also prevent any subsequent InstantiationAwareBeanPostProcessor instances being invoked on this bean instance."
access="public" returntype="boolean" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfscript>
		if(isObject(arguments.bean))
		{
			arguments.bean[getKey() & "_afterInstantiation"] = 1;
		}

		return true;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeforeInitialization" hint="Apply this BeanPostProcessor to the given new bean instance <em>before</em> any bean initialization callbacks (like a custom init-method).
													The bean will already be populated with property values. The returned bean instance may be a wrapper around the original.
													returns the bean instance to use, either the original or a wrapped one; if null, no subsequent BeanPostProcessors will be invoked " access="public" returntype="any" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfscript>
		if(isObject(arguments.bean))
		{
			arguments.bean[getKey() & "_BeforeInitialization"] = 1;
		}

		return arguments.bean;
    </cfscript>
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="Apply this BeanPostProcessor to the given new bean instance <em>after</em> any bean initialization callbacks (like a custom init-method).
													The bean will already be populated with property values. The returned bean instance may be a wrapper around the original.
													returns the bean instance to use, either the original or a wrapped one; if null, no subsequent BeanPostProcessors will be invoked" access="public" returntype="any" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfscript>
		if(isObject(arguments.bean))
		{
			arguments.bean[getKey() & "_AfterInitialization"] = 1;
		}

		return arguments.bean;
    </cfscript>
</cffunction>

<cffunction name="getKey" access="public" returntype="string" output="false">
	<cfreturn instance.key />
</cffunction>

<cffunction name="setKey" access="private" returntype="void" output="false">
	<cfargument name="key" type="string" required="true">
	<cfset instance.key = arguments.key />
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>