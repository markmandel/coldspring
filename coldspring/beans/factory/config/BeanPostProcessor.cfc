<cfinterface hint="Factory hook that allows for custom modification of new bean instances, e.g. checking for marker interfaces or wrapping them with proxies.<br/>
				Typically, post-processors that populate beans via marker interfaces or the like will implement postProcessBeforeInitialization(bean, beanName), while post-processors that wrap beans with proxies will normally implement postProcessAfterInitialization(bean, beanName). ">

<cffunction name="postProcessBeforeInitialization" hint="Apply this BeanPostProcessor to the given new bean instance <em>before</em> any bean initialization callbacks (like a custom init-method).
														The bean will already be populated with property values. The returned bean instance may be a wrapper around the original.
														returns the bean instance to use, either the original or a wrapped one;"
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="Apply this BeanPostProcessor to the given new bean instance <em>after</em> any bean initialization callbacks (like a custom init-method).
														The bean will already be populated with property values. The returned bean instance may be a wrapper around the original.
														returns the bean instance to use, either the original or a wrapped one;"
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
</cffunction>

</cfinterface>