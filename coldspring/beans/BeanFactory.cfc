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

<cfinterface hint="Interface to a Bean Factory, that can be used to dependency inject a series of bean definitions">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getBean" hint="gets a bean by a given id" access="public" returntype="any" output="false">
	<cfargument name="name" hint="the name of the bean to get" type="string" required="Yes">
</cffunction>

<cffunction name="containsBean" hint="Does this bean factory contain a bean with the given name? More specifically, is getBean(java.lang.String) able to obtain a bean instance for the given name?<br/>
	Translates aliases back to the corresponding canonical bean name. Will ask the parent factory if the bean cannot be found in this factory instance. "
	access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
</cffunction>

<cffunction name="containsBeanDefinition" hint="Check if this bean factory contains a bean definition with the given name.<br/>
		Does not consider any hierarchy this factory may participate in, and ignores any singleton beans that have been registered by other means than bean definitions."
		access="public" returntype="boolean" output="false">
	<cfargument name="name" hint="the name of the bean to check for" type="string" required="Yes" />
</cffunction>

<cffunction name="getBeanDefinitionCount" hint="Return the number of beans defined in this bean factory." access="public" returntype="numeric" output="false">
</cffunction>

<cffunction name="getBeanDefinitionNames" hint="Return the names of all beans defined in this bean factory" access="public" returntype="array" output="false"
			colddoc:generic="string">
</cffunction>

<cffunction name="getBeanNamesForType" hint="Return the names of beans matching the given type (including subclasses),
			judging from either bean definitions or the value of getObjectType in the case of FactoryBeans.<br/>
			Does consider objects created by FactoryBeans, which means that FactoryBeans will get initialized.
			"
			access="public" returntype="array" output="false">
	<cfargument name="className" hint="the class type" type="string" required="Yes">
</cffunction>

<cffunction name="getAliases"
	hint="Return the aliases for the given bean name, if any. All of those aliases point to the same bean when used in a getBean(java.lang.String) call.<br/>
	If the given name is an alias, the corresponding original bean name and other aliases (if any) will be returned, with the original bean name being the first element in the array.<br/>
	Will ask the parent factory if the bean cannot be found in this factory instance."
	access="public" returntype="array" output="false">
	<cfargument name="name" hint="name - the bean name to check for aliases " type="string" required="Yes">
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>