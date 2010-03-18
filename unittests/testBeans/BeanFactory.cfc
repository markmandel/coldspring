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

<cfcomponent hint="An extension of the abstractBeanFactory for testing purposes" extends="coldspring.beans.AbstractBeanFactory" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanFactory" output="false">
	<cfscript>
		super.init();

		refresh();

		return this;
	</cfscript>
</cffunction>

<cffunction name="addBeanDefinition" hint="add a bean definition to the registry" access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to add" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfset getBeanDefinitionRegistry().registerBeanDefinition(argumentCollection=arguments)>
</cffunction>

<cffunction name="getBeanDefinitionByName" hint="" access="public" returntype="any" output="false">
	<cfargument name="id" hint="the id of the bean to check for" type="string" required="Yes" />
	<cfreturn getBeanDefinitionRegistry().getBeanDefinition(argumentCollection=arguments) />
</cffunction>

<cffunction name="getBeanDefinitionRegistry" access="public" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn super.getBeanDefinitionRegistry() />
</cffunction>

<cffunction name="endRefresh" hint="finalises the refresh, and notifies the beans they are complete, and validates them. Should be called at the end of a refresh() method."
			access="public" returntype="void" output="false">
	<cfset super.endRefresh()>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>