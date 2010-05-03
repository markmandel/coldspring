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

<cfcomponent hint="Is a simple value, such as a string, or a number" extends="AbstractValue" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="SimpleValue" output="false">
	<cfargument name="value" hint="the simple value to pass in" type="string" required="Yes">
	<cfscript>
		if(NOT isSimpleValue(arguments.value))
		{
			createObject("component", "coldspring.beans.support.exception.NotSimpleValueException").init("#arguments.value#");
		}

		setValue(arguments.value);

		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>