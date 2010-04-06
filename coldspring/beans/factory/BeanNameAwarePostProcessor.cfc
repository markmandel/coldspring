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

<cfcomponent hint="Post processor for setting beans that are bean name aware with their id" implements="coldspring.beans.factory.config.BeanPostProcessor" output="false">

<cfscript>
	instance.static.BEAN_NAME_AWARE_CLASS = "coldspring.beans.factory.BeanNameAware";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanNameAwarePostProcessor" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeforeInitialization" hint="sets the BeanName if the object implements BeanNameAware" access="public" returntype="any" output="false">
	<cfargument name="bean" type="any" required="yes" />
	<cfargument name="beanName" type="string" required="yes" />
	<cfscript>
		if(isInstanceOf(arguments.bean, instance.static.BEAN_NAME_AWARE_CLASS))
		{
			arguments.bean.setBeanName(arguments.beanName);
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

</cfcomponent>