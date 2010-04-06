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

<cfinterface hint="Factory hook that allows for custom modification of new bean instances, e.g. checking for marker interfaces or wrapping them with proxies.<br/>
				Typically, post-processors that populate beans via marker interfaces or the like will implement postProcessBeforeInitialization(bean, beanName), while post-processors that wrap beans with proxies will normally implement postProcessAfterInitialization(bean, beanName). ">

<cffunction name="postProcessBeforeInitialization" hint="Apply this BeanPostProcessor to the given new bean instance <em>before</em> any bean initialization callbacks (like a custom init-method).
														The bean will already be populated with property values. The returned bean instance may be a wrapper around the original.
														returns the bean instance to use, either the original or a wrapped one; if null, no subsequent BeanPostProcessors will be invoked "
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="Apply this BeanPostProcessor to the given new bean instance <em>after</em> any bean initialization callbacks (like a custom init-method).
														The bean will already be populated with property values. The returned bean instance may be a wrapper around the original.
														returns the bean instance to use, either the original or a wrapped one; if null, no subsequent BeanPostProcessors will be invoked "
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
</cffunction>

</cfinterface>