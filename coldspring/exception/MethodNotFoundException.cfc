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

<cfcomponent hint="Exception for method not being found" extends="Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="component" hint="the component that the method is attempting to be called on" type="any" required="Yes">
	<cfargument name="methodName" hint="the name of the method" type="string" required="Yes">

	<cfscript>
		super.init("The method '#arguments.methodName#' in '#getMetaData(arguments.component).name#' could not be found.",
					"This method could not be found. Please ensure that it was spelled correctly"
					);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>