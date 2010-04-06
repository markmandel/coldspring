<cfcomponent hint="contains how many beans tehre are" implements="coldspring.beans.BeanDefinitionRegistryPostProcessor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanCountRegistryPostProcessor" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeanDefinitionRegistry" hint="How many beans are in there?" access="public" returntype="void" output="false">
	<cfargument name="registry" type="coldspring.beans.BeanDefinitionRegistry" required="yes" />
	<cfscript>
		setCount(arguments.registry.getBeanDefinitionCount());
    </cfscript>
</cffunction>

<cffunction name="getCount" access="public" returntype="numeric" output="false">
	<cfreturn instance.Count />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCount" access="private" returntype="void" output="false">
	<cfargument name="Count" type="numeric" required="true">
	<cfset instance.Count = arguments.Count />
</cffunction>

</cfcomponent>