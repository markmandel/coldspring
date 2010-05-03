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

<cfcomponent hint="A reference to another BeanDefinition" extends="AbstractValue" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RefValue" output="false">
	<cfargument name="beanName" hint="the name of the bean this references" type="string" required="Yes">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfscript>
		setBeanName(arguments.beanName);
		setBeanDefinitionRegistry(arguments.beanDefinitionRegistry);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getBeanName" access="public" returntype="string" output="false">
	<cfreturn instance.beanName />
</cffunction>

<cffunction name="setBeanName" access="public" returntype="void" output="false">
	<cfargument name="beanName" type="string" required="true">
	<cfset instance.beanName = arguments.beanName />
</cffunction>

<cffunction name="getBeanDefinition" access="public" returntype="coldspring.beans.support.AbstractBeanDefinition" output="false">
	<cfreturn instance.beanDefinition />
</cffunction>

<cffunction name="hasBeanDefinition" hint="whether this object has a beanDefinition" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "beanDefinition") />
</cffunction>

<cffunction name="getValue" hint="The value this object is, returned from the referenced bean definition" access="public" returntype="any" output="false">
	<cfscript>
		if(NOT hasBeanDefinition())
		{
			setBeanDefinition(getBeanDefinitionRegistry().getBeanDefinition(getBeanName()));
		}

		return getBeanDefinition().getInstance();
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setBeanDefinition" hint="The actual bean definition" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" type="coldspring.beans.support.AbstractBeanDefinition" required="true">
	<cfset instance.beanDefinition = arguments.beanDefinition />
</cffunction>

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<cffunction name="getBeanDefinitionRegistry" access="private" returntype="coldspring.beans.BeanDefinitionRegistry" output="false">
	<cfreturn instance.beanDefinitionRegistry />
</cffunction>

<cffunction name="setBeanDefinitionRegistry" access="private" returntype="void" output="false">
	<cfargument name="beanDefinitionRegistry" type="coldspring.beans.BeanDefinitionRegistry" required="true">
	<cfset instance.beanDefinitionRegistry = arguments.beanDefinitionRegistry />
</cffunction>

</cfcomponent>