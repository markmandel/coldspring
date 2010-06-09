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

<cfcomponent implements="coldspring.util.StringValueResolver" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ReverseResolver" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


<cffunction name="resolveStringValue" hint="Resolve the given String value, for example parsing placeholders.
<br/>Returns the resolves string value to replace the original. If no replacement is to be made, return nothing." access="public" returntype="any" output="false">
	<cfargument name="string" type="string" required="yes" />

	<cfscript>
		//do special case for 'singleton' as otherwise, it breaks
		if(arguments.string != "singleton")
		{
			return reverse(arguments.string);
		}
    </cfscript>
</cffunction>

</cfcomponent>