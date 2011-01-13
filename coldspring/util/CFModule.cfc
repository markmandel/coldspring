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
<cfcomponent hint="CFC for calling a custom tag, and returning the results.<br/>
	<strong>Note:</strong> If the custom tag is return a result, it should be named 'result', as this is var'd in this CFC, otherwise execute() won't be thread safe if placed in a shared scope'"
	output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CFModule" output="false">
	<cfargument name="template" hint="the relative or absolute path to the custom tag" type="string" required="no">
	<cfargument name="attributes" hint="the attributes to pass to the custom tag" type="struct" required="no">
	<cfscript>
		setAttributes(StructNew());
		if(structKeyExists(arguments, "template"))
		{
			setTemplate(arguments.template);
		}

		if(structKeyExists(arguments, "attributes"))
		{
			setAttributes(arguments.attributes);
		}

		return this;
	</cfscript>
</cffunction>

<cffunction name="getTemplate" access="public" returntype="string" output="false">
	<cfreturn instance.template />
</cffunction>

<cffunction name="setTemplate" access="public" returntype="void" output="false">
	<cfargument name="template" type="string" required="true">
	<cfset instance.template = arguments.template />
</cffunction>

<cffunction name="getAttributes" access="public" returntype="struct" output="false">
	<cfreturn instance.attributes />
</cffunction>

<cffunction name="addAttribute" hint="adds an individual attribute to the custom tag call" access="public" returntype="void" output="false">
	<cfargument name="name" hint="the name of the attribute" type="string" required="Yes">
	<cfargument name="value" hint="the value of the attribute being set" type="any" required="Yes">
	<cfscript>
		structInsert(getAttributes(), arguments.name, arguments.value, true);
    </cfscript>
</cffunction>

<cffunction name="setAttributes" hint="Attributes to pass to the custom tag" access="public" returntype="void" output="false">
	<cfargument name="attributes" type="struct" required="true">
	<cfset instance.attributes = arguments.attributes />
</cffunction>

<cffunction name="execute" hint="executes the custom tag. Any result returned from the custom tag named 'caller.result' is returned" access="public" returntype="any" output="false">
	<cfargument name="template" hint="the relative or absolute path to the custom tag" type="string" required="no" default="#getTemplate()#">
	<cfargument name="attributes" hint="the attributes to pass to the custom tag" type="struct" required="no" default="#getAttributes()#">
	<cfscript>
		var result = 0;
    </cfscript>

	<cfmodule template="#arguments.template#" attributecollection="#arguments.attributes#">

	<cfreturn result />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>
