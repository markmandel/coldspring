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

<cfcomponent hint="Exception for when something goes wrong with Bean creation" extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean defintion for which the creation failed" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfargument name="exception" hint="the cfcatch exception" type="any" required="Yes">
	<cfscript>
		var detail = 0;
    </cfscript>
	<cfsavecontent variable="detail">
		<cfdump var="#arguments.exception#" format="text">
	</cfsavecontent>

	<cfscript>
		super.init("Error creating bean '#arguments.beanDefinition.getID()#'", detail);

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>