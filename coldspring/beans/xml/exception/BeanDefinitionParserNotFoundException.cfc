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

<cfcomponent extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="namespace" hint="the namespace that is in the current context" type="string" required="Yes">
	<cfargument name="name" hint="the name of the element we are looking at" type="string" required="Yes">
	<cfscript>
		super.init("A BeanDefinitionParser could not be found.", "A BeanDefinitionParser could not found for element '#arguments.name#' in namespace '#arguments.namespace#'");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>