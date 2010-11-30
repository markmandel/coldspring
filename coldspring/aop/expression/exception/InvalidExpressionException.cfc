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

<cfcomponent hint="Exception for when an expression provided has an error in it" extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="InvalidExpressionException" output="false">
	<cfargument name="expression" hint="the expression in question" type="string" required="Yes">
	<cfargument name="line" hint="the line the error happened on" type="numeric" required="Yes">
	<cfargument name="char" hint="the character position in the line the error occured near" type="numeric" required="Yes">
	<cfargument name="message" hint="the message to provide to with the error," type="string" required="Yes">
	<cfscript>
		var errorMessage = "Invalid expression syntax found near '#resolveErrorNear(arguments.expression, arguments.line, arguments.char)#'";
		var detail = "At line #arguments.line#, #arguments.char# an error occured: #arguments.message#";

		super.init(errorMessage, detail);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="resolveErrorNear" hint="returns the word the error is near" access="private" returntype="string" output="false">
	<cfargument name="string" hint="the string which has produced the error" type="string" required="Yes">
	<cfargument name="line" hint="the line number" type="numeric" required="Yes">
	<cfargument name="charPosition" hint="the character position in the line" type="string" required="Yes">
	<cfscript>
		//use character 10, as it comes at the beginning
		var lines = ListToArray(arguments.string, #chr(10)#);
		var nearLine = "";
		var EOF = false;
		var c = "";
		var errorToken = "";

		if(arguments.line gt 0 AND arguments.line lte ArrayLen(lines))
		{
			nearLine = lines[arguments.line];
			if(arguments.charPosition lt Len(nearLine))
			{
				c = nearLine.charAt(JavaCast("int", arguments.charPosition));
			}
			errorToken = c;
		}

		while(NOT EOF)
		{
			arguments.charPosition = arguments.charPosition + 1;

			if(arguments.charPosition gte Len(nearLine))
			{
				EOF = true;
			}
			else
			{
				c = nearLine.charAt(JavaCast("int", arguments.charPosition));
				if(c eq " ")
				{
					EOF = true;
				}
				else
				{
					errorToken = errorToken & c;
				}
			}
		}

		return errorToken;
	</cfscript>
</cffunction>

</cfcomponent>