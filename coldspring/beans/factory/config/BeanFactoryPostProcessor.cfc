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
<cfinterface hint="Allows for custom modification of an application context's bean definitions, adapting the bean property values of the context's underlying bean factory.<br/>
					Application contexts can auto-detect BeanFactoryPostProcessor beans in their bean definitions and apply them before any other beans get created.<br/>
					Useful for custom config files targeted at system administrators that override bean properties configured in the application context.">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="postProcessBeanFactory" hint="Modify the application context's internal bean factory after its standard initialization.
			All bean definitions will have been loaded, but no beans will have been instantiated yet. This allows for overriding or adding properties even to eager-initializing beans."
			access="public" returntype="void" output="false">
	<cfargument name="beanFactory" hint="" type="coldspring.beans.AbstractBeanFactory" required="Yes">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->



</cfinterface>