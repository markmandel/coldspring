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

<cfcomponent hint="say hello" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Hello" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="sayHello" hint="" access="public" returntype="string" output="false">
	<cfargument name="str" hint="" type="string" required="no" default="hello">
	<cfreturn arguments.str />
</cffunction>

<cffunction	name="onMissingMethod" access="public" returntype="any" output="false" hint="invoked when a method could not be found">
	<cfargument	name="missingMethodName" type="string"	required="true"	hint=""	/>
	<cfargument	name="missingMethodArguments" type="struct" required="true"	hint=""/>
	<cfreturn "Hello" />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>