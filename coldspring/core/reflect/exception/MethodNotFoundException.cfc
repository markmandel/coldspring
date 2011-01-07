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

<cfcomponent hint="Exception for when a method could not be found on a component meta data" extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfargument name="methodName" hint="the name of the method that does not exist on this class" type="string" required="Yes">
	<cfargument name="onlyDeclared" hint="whethere or not the search path only includes declared methods" type="boolean" required="No" default="false">
	<cfscript>
		if(arguments.onlyDeclared)
		{
			super.init("Declared method '#arguments.methodName#' could not be found on class '#arguments.className#'"
			, "The method '#arguments.methodName#' is not declared on class '#arguments.className#', but it may exist on its super classes. You may want to try getMethod().");
		}
		else
		{
			super.init("Public method '#arguments.methodName#' could not be found on class '#arguments.className#'"
			, "The public method '#arguments.methodName#' does not exist on class '#arguments.className#' or any of its parent classes");
		}
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>