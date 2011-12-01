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

<cfcomponent hint="Abstract base class for reading and parsing XML data" output="false" colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="parseToDocument" hint="Parses the given XML to org.w3c.dom.Document" access="public" returntype="any" output="false">
	<cfscript>
		var factory = createObject("java", "javax.xml.parsers.DocumentBuilderFactory").newInstance();
		var builder = 0;
		var document = 0;
		var local = {}; //just for error handling.

		factory.setValidating(true);
		factory.setNamespaceAware(true);
		factory.setIgnoringComments(true);
		factory.setIgnoringElementContentWhitespace(true);

		//enable schema checking
		factory.setAttribute("http://java.sun.com/xml/jaxp/properties/schemaLanguage", "http://www.w3.org/2001/XMLSchema");

		builder = factory.newDocumentBuilder();

		builder.setEntityResolver(getJavaLoader().create("org.coldspring.beans.xml.MappedEntityResolver").init(getSchemaMap()));
		builder.setErrorHandler(getJavaLoader().create("org.coldspring.beans.xml.DefaultErrorHandler").init());

		try
		{
			document = buildDocument(builder);
		}
		catch(org.xml.sax.SAXParseException exc)
		{
			local.lineNumber = -1;
			local.columnNumber = 0;

			if(structKeyExists(exc, 'lineNumber'))
			{
				local.lineNumber = exc.lineNumber;
			}
			if(structKeyExists(exc, 'columnNumber'))
			{
				local.columnNumber = exc.columnNumber;
			}

			createObject("component", "coldspring.core.io.exception.InvalidXMLException").init(getXMLErrorDescriptor(),
																								getContent(),
																								local.lineNumber,
																								local.columnNumber,
																								exc.message);
		}

		return document;
    </cfscript>
</cffunction>

<cffunction name="getContent" hint="Abstract: returns the string value of the XML content" access="public" returntype="string" output="false" colddoc:abstract="true">
    <cfset createObject("component", "coldspring.exception.AbstractMethodException").init(this, "getContent")/>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getXMLErrorDescriptor" hint="abstract: Error message for when the XML is invalid" access="private" returntype="string" output="false" colddoc:abstract="true">
    <cfset createObject("component", "coldspring.exception.AbstractMethodException").init(this, "getXMLErrorDescriptor")/>
</cffunction>

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
    <cfargument name="schemaMap" hint="map for XSDs to be mapped to local resources" type="struct" required="false" default="#StructNew()#">
    <cfscript>
        setJavaLoader(getComponentMetadata("coldspring.core.java.JavaLoader").singleton.instance);
        setSchemaMap(arguments.schemaMap);
    </cfscript>
</cffunction>

<cffunction name="buildDocument" hint="Abstract: Builder the org.w3c.dom.Document from the factory" access="private" returntype="any" output="false" colddoc:abstract="true">
    <cfargument name="builder" hint="The javax.xml.parsers.DocumentBuilder object" type="any" required="true">
    <cfset createObject("component", "coldspring.exception.AbstractMethodException").init(this, "getContent")/>
</cffunction>

<cffunction name="getSchemaMap" access="private" returntype="struct" output="false">
	<cfreturn instance.schemaMap />
</cffunction>

<cffunction name="setSchemaMap" access="private" returntype="void" output="false">
	<cfargument name="schemaMap" type="struct" required="true">
	<cfset instance.schemaMap = arguments.schemaMap />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldspring.core.java.JavaLoader" output="false">
	<cfreturn instance.javaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="javaLoader" type="coldspring.core.java.JavaLoader" required="true">
	<cfset instance.javaLoader = arguments.javaLoader />
</cffunction>

</cfcomponent>