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

<cfcomponent hint="Component for reading and parsing XML data in files" extends="AbstractXMLReader" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="XMLFileReader" output="false">
	<cfargument name="path" hint="the absolute path to the XML file" type="string" required="Yes">
	<cfargument name="schemaMap" hint="map for XSDs to be mapped to local resources" type="struct" required="false" default="#StructNew()#">
	<cfscript>
        super.init(arguments.schemaMap);
		setPath(arguments.path);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getPath" access="public" returntype="string" output="false">
	<cfreturn instance.path />
</cffunction>

<cffunction name="getContent" hint="returns the string value of the XML content" access="public" returntype="string" output="false">
	<cfreturn fileRead(getPath()) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getXMLErrorDescriptor" hint="abstract: Error message for when the XML is invalid" access="private" returntype="string" output="false" colddoc:abstract="true">
    <cfreturn "in file '#getPath()#'" />
</cffunction>

<cffunction name="buildDocument" hint="Abstract: Builder the org.w3c.dom.Document from the factory" access="private" returntype="any" output="false">
    <cfargument name="builder" hint="The javax.xml.parsers.DocumentBuilder object" type="any" required="true">
    <cfscript>
        return arguments.builder.parse(createobject("java", "java.io.File").init(getPath()));    
    </cfscript>
</cffunction>

<cffunction name="setPath" access="private" returntype="void" output="false">
	<cfargument name="path" type="string" required="true">
	<cfset instance.path = arguments.path />
</cffunction>

</cfcomponent>