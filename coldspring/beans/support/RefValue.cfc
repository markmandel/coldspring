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
	<cfargument name="beanFactory" hint="The bean factor that is used to create this bean instance" type="coldspring.beans.BeanFactory" required="true">
	<cfscript>
		setBeanName(arguments.beanName);
		setBeanFactory(arguments.beanFactory);

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

<cffunction name="getValue" hint="The value this object is, returned from the referenced bean definition" access="public" returntype="any" output="false">
	<cfscript>
		return getBeanFactory().getBean(getBeanName());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<cffunction name="setBeanFactory" access="private" returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.BeanFactory" required="true">
	<cfset instance.beanFactory = arguments.beanFactory />
</cffunction>

<cffunction name="getBeanFactory" access="private" returntype="coldspring.beans.BeanFactory" output="false">
	<cfreturn instance.beanFactory />
</cffunction>

</cfcomponent>