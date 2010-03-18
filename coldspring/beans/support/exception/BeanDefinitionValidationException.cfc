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


<cfcomponent hint="Exception thrown when the validation of a bean definition failed." extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean defnition for which an error has occured" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfargument name="message" hint="the message to passed with this exception" type="string" required="Yes">
	<cfscript>
		super.init("The Bean Definition with an id of '#arguments.beanDefinition.getID()#' is invalid.", arguments.message);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>