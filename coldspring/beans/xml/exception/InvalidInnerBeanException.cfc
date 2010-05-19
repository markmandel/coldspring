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

<cfcomponent hint="Exception for when an XML element has been defined as an inner bean, when it shouldn't be there" extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="element" hint="the org.w3c.dom.Element that is invalid" type="any" required="Yes">
	<cfargument name="containingBeanDef" hint="the bean definition that wraps this custom element" type="any" required="Yes">
	<cfscript>
		super.init("Element '#arguments.element.getTagName()#' cannot be used as an inner bean.",
			"Cannot apply '#arguments.element.getTagName()#' as an inner bean to the bean definition id: '#arguments.containingBeanDef.getID()#'");
	</cfscript>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>