<cfcomponent implements="coldspring.beans.factory.BeanNameAware" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanNameAwareBean" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="setBeanName" hint="Set the name of the bean in the bean factory that created this bean.<br/>
		Invoked after population of normal bean properties but before an a custom init-method." access="public" returntype="void" output="false">
	<cfargument name="name" type="string" required="yes" />
	<cfset instance.beanName = arguments.name>
</cffunction>

<cffunction name="getBeanName" access="public" returntype="string" output="false">
	<cfreturn instance.beanName />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>