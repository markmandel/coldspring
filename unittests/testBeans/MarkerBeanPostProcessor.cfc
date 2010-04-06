<cfcomponent hint="Puts a tag on this scope as beans come through" implements="coldspring.beans.factory.config.BeanPostProcessor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MarkerBeanPostProcessor" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeforeInitialization" hint="add the bean name to this.beforeName" access="public" returntype="any" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfif isObject(arguments.bean)>
		<cfset arguments.bean.beforeName = arguments.beanName>
	</cfif>
	<cfreturn arguments.bean />
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="add the bean name to this.afterName" access="public" returntype="any" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfif isObject(arguments.bean)>
		<cfset arguments.bean.afterName = arguments.beanName>
	</cfif>
	<cfreturn arguments.bean />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>