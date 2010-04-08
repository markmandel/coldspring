<cfcomponent hint="contains how many beans tehre are" implements="coldspring.beans.BeanDefinitionRegistryPostProcessor,coldspring.beans.factory.config.BeanFactoryPostProcessor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanCountRegistryPostProcessor" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeanDefinitionRegistry" hint="How many beans are in there?" access="public" returntype="void" output="false">
	<cfargument name="registry" type="coldspring.beans.BeanDefinitionRegistry" required="yes" />
	<cfscript>
		setRegistryCount(arguments.registry.getBeanDefinitionCount());
    </cfscript>
</cffunction>

<cffunction name="postProcessBeanFactory" hint="Modify the application context's internal bean factory after its standard initialization.
			All bean definitions will have been loaded, but no beans will have been instantiated yet. This allows for overriding or adding properties even to eager-initializing beans."
			access="public" returntype="void" output="false">
	<cfargument name="beanFactory" hint="" type="coldspring.beans.AbstractBeanFactory" required="Yes">
	<cfscript>
		setBeanFactoryCount(arguments.beanFactory.getBeanDefinitionCount());
    </cfscript>
</cffunction>

<cffunction name="getRegistryCount" access="public" returntype="numeric" output="false">
	<cfreturn instance.rCount />
</cffunction>

<cffunction name="getFactoryCount" access="public" returntype="numeric" output="false">
	<cfreturn instance.fCount />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setRegistryCount" access="private" returntype="void" output="false">
	<cfargument name="Count" type="numeric" required="true">
	<cfset instance.rCount = arguments.Count />
</cffunction>

<cffunction name="setBeanFactoryCount" access="private" returntype="void" output="false">
	<cfargument name="Count" type="numeric" required="true">
	<cfset instance.fCount = arguments.Count />
</cffunction>

</cfcomponent>