<!---
   Copyright 2011 Mark Mandel

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

<cfcomponent hint="Utility class for building CFML functions as strings to use in templates." output="false">

<cfscript>
	meta = getMetaData(this);

	if(!structKeyExists(meta, "const"))
	{
		const = {};
		const.NL = createObject("java", "java.lang.System").getProperty("line.separator");

		//doing this to fix syntax highlighting, and I write it alot
		const.CFSCRIPT_OPEN = "<cfsc" & "ript>";
		const.CFSCRIPT_CLOSE = "</cfsc" & "ript>";
		const.CFFUNCTION = "cffun" & "ction";

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="FunctionBuilder" output="false">
	<cfscript>
		setStringBuilder(createObject("java", "java.lang.StringBuilder").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="writeFunctionOpen" hint="Writes the opening part of a CFFunction" access="public" returntype="void" output="false">
	<cfargument name="name" hint="The name of the function" type="string" required="Yes">
	<cfargument name="access" hint="The access of the funtion" type="string" required="Yes">
	<cfargument name="returnType" hint="The return Type of the function" type="string" required="Yes">
	<cfargument name="hint" hint="The hint for the function" type="string" required="no" default="">
	<cfscript>
		append("<");
		append(meta.const.CFFUNCTION);
		append(' name="#arguments.name#"');
		append(' access="#arguments.access#"');
		append(' returntype="#arguments.returnType#"');
		append(' hint="#arguments.hint#"');
		writeLine(' output="false">');
	</cfscript>
</cffunction>

<cffunction name="writeFunctionClose" hint="Writes the closing part of a cffunction" access="public" returntype="void" output="false">
	<cfscript>
		append("</");
		append(meta.const.CFFUNCTION);
		writeLine(">" & meta.const.NL);
	</cfscript>
</cffunction>

<cffunction name="writeArgument" hint="Writes an argument to the buffer" access="public" returntype="void" output="false">
	<cfargument name="name" hint="The name of the argument" type="string" required="Yes">
	<cfargument name="type" hint="The type of the argument" type="string" required="No" default="any">
	<cfargument name="hint" hint="the hint to add to the argument" type="string" required="No" default="">
	<cfargument name="required" hint="Whether the argument is required" type="boolean" required="No" default="no">
	<cfargument name="default" hint="Default value for the argument" type="string" required="No">

	<cfscript>
		append('<cfargument name="#arguments.name#"');
		append(' type="#arguments.type#"');
		append(' required="#arguments.required#"');
		append(' hint="#arguments.hint#"');

		//if there is a default, write it
		if(structKeyExists(arguments, 'default'))
		{
			append(' default="#arguments.default#"');
		}
		writeLine(">");
	</cfscript>
</cffunction>

<cffunction name="writeCopyOpenFunction" hint="copies the signtaure of a method" access="public" returntype="void" output="false">
	<cfargument name="method" hint="the method to copy the signature of" type="coldspring.core.reflect.Method" required="Yes">
	<cfscript>
		var params = arguments.method.getParameters();
		var param = 0;

		writeFunctionOpen(arguments.method.getName(), arguments.method.getAccess(), arguments.method.getReturnType());
    </cfscript>

    <cfloop array="#params#" index="param">
		<cfscript>
			//we will skip default, as it can come out '[runtime expression]' which can be bad.
			writeArgument(param.getName(), param.getType(), param.getHint(), param.isRequired());
        </cfscript>
    </cfloop>
</cffunction>

<cffunction name="cfScript" hint="Writes a cfscript" access="public" returntype="void" output="false">
	<cfargument name="open" hint="Is it open, or close?" type="boolean" required="Yes">
	<cfscript>
		if(arguments.open)
		{
			writeLine(meta.const.CFSCRIPT_OPEN);
		}
		else
		{
			writeLine(meta.const.CFSCRIPT_CLOSE);
		}
	</cfscript>
</cffunction>

<cffunction name="append" hint="Appends the string" access="public" returntype="void" output="false">
	<cfargument name="string" hint="The string to append" type="string" required="Yes">
	<cfscript>
		getStringBuilder().append(arguments.string);
	</cfscript>
</cffunction>

<cffunction name="writeLine" hint="Writes a line with a carriage return at the end" access="public" returntype="void" output="false">
	<cfargument name="text" hint="The text" type="string" required="Yes">
	<cfscript>
		append(arguments.text);
		append(meta.const.NL);
	</cfscript>
</cffunction>

<cffunction name="$toString" hint="Functions defined as a string" access="public" returntype="string" output="false">
	<cfreturn getStringBuilder().toString()>
</cffunction>

<cffunction name="getStringBuilder" hint="get the underlying StringBuilder" access="public" returntype="any" output="false">
	<cfreturn instance.stringBuilder />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setStringBuilder" access="private" returntype="void" output="false">
	<cfargument name="stringBuilder" type="any" required="true">
	<cfset instance.stringBuilder = arguments.stringBuilder />
</cffunction>

</cfcomponent>