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

<cfcomponent hint="Exception for when validation fails on XML" extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="path" hint="the file path to the XML config file" type="string" required="Yes">
	<cfargument name="xmlContent" hint="The XML String" type="string" required="Yes">
	<cfargument name="lineNumber" hint="the line number of the error" type="numeric" required="Yes">
	<cfargument name="column" hint="the column the error is on" type="numeric" required="Yes">
	<cfargument name="parseError" hint="the parse error message." type="string" required="Yes">
	<cfscript>
		var lines = xmlContent.split("\n");

		super.init("Invalid XML found in XML file '#arguments.path#', line #arguments.lineNumber#, column #arguments.column#",
		"Error found on line: '#lines[arguments.lineNumber]#'.#chr(10)##chr(13)#  #arguments.parseError#"
		);

	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>