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

<cfcomponent hint="Component for reading and parsing XML data" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="XMLFileReader" output="false">
	<cfargument name="path" hint="the absolute path to the XML file" type="string" required="Yes">
	<cfargument name="javaloader" hint="The JavaLoader library" type="coldspring.util.java.JavaLoader" required="Yes">
	<cfargument name="schemaMap" hint="map for XSDs to be mapped to local resources" type="struct" required="false" default="#StructNew()#">
	<cfscript>
		setJavaLoader(arguments.javaloader);
		setSchemaMap(arguments.schemaMap);
		setPath(arguments.path);

		return this;
	</cfscript>
</cffunction>

<cffunction name="parseToDocument" hint="Parses the given XML to org.w3c.dom.Document" access="public" returntype="any" output="false">
	<cfscript>
		var factory = createObject("java", "javax.xml.parsers.DocumentBuilderFactory").newInstance();
		var builder = 0;

		factory.setValidating(true);
		factory.setNamespaceAware(true);
		factory.setIgnoringComments(true);
		factory.setIgnoringElementContentWhitespace(true);

		//enable schema checking
		factory.setAttribute("http://java.sun.com/xml/jaxp/properties/schemaLanguage", "http://www.w3.org/2001/XMLSchema");

		builder = factory.newDocumentBuilder();

		builder.setEntityResolver(getJavaLoader().create("org.coldspringframework.beans.xml.MappedEntityResolver").init(getSchemaMap()));
		builder.setErrorHandler(getJavaLoader().create("org.coldspringframework.beans.xml.DefaultErrorHandler").init());

		try
		{
			document = builder.parse(getPath());
		}
		catch(org.xml.sax.SAXParseException exc)
		{
			createObject("component", "coldspring.io.exception.InvalidXMLException").init(getPath(), getContent(), exc.lineNumber, exc.columnNumber, exc.message);
		}

		return document;
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

<cffunction name="setPath" access="private" returntype="void" output="false">
	<cfargument name="path" type="string" required="true">
	<cfset instance.path = arguments.path />
</cffunction>

<cffunction name="getSchemaMap" access="private" returntype="struct" output="false">
	<cfreturn instance.schemaMap />
</cffunction>

<cffunction name="setSchemaMap" access="private" returntype="void" output="false">
	<cfargument name="schemaMap" type="struct" required="true">
	<cfset instance.schemaMap = arguments.schemaMap />
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldspring.util.java.JavaLoader" output="false">
	<cfreturn instance.javaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="javaLoader" type="coldspring.util.java.JavaLoader" required="true">
	<cfset instance.javaLoader = arguments.javaLoader />
</cffunction>

</cfcomponent>