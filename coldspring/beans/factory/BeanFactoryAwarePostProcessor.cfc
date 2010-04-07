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

<cfcomponent hint="Post processor for setting the beanFactory on beans that implement the BeanFactoryAware interface" implements="coldspring.beans.factory.config.BeanPostProcessor" output="false">

<cfscript>
	instance.static.BEAN_FACTORY_AWARE_CLASS = "coldspring.beans.factory.BeanFactoryAware";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanFactoryAwarePostProcessor" output="false">
	<cfargument name="beanFactory" hint="the bean factory to inject" type="coldspring.beans.AbstractBeanFactory" required="Yes">
	<cfscript>
		setBeanFactory(arguments.beanFactory);

		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeforeInitialization" hint="sets the BeanFactory if the object implements BeanFactoryAware" access="public" returntype="any" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfscript>
		if(isInstanceOf(arguments.bean, instance.static.BEAN_FACTORY_AWARE_CLASS))
		{
			arguments.bean.setBeanFactory(getBeanFactory());
		}

		return arguments.bean;
    </cfscript>
</cffunction>

<cffunction name="postProcessAfterInitialization" hint="Does nothing, just returns what it has" access="public" returntype="any" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfreturn arguments.bean />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getBeanFactory" access="private" returntype="coldspring.beans.AbstractBeanFactory" output="false">
	<cfreturn instance.beanFactory />
</cffunction>

<cffunction name="setBeanFactory" access="private" returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.AbstractBeanFactory" required="true">
	<cfset instance.beanFactory = arguments.beanFactory />
</cffunction>


</cfcomponent>