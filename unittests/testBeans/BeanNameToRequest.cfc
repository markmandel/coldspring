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

<cfcomponent implements="coldspring.beans.factory.BeanNameAware" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="BeanNameToRequest" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="configure" hint="after di configure method" access="public" returntype="void" output="false">
	<cfscript>
		request[variables.beanName] = 1;
    </cfscript>
</cffunction>

<cffunction name="setBeanName" hint="Set the name of the bean in the bean factory that created this bean.<br/>
		Invoked after population of normal bean properties but before an a custom init-method." access="public" returntype="void" output="false">
	<cfargument name="name" type="string" required="yes" />
	<cfscript>
		variables.beanName = arguments.name;
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->
<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>