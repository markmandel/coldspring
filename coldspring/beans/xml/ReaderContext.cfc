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

<cfcomponent hint="The context for reading a given XML document" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ReaderContext" output="false">
	<cfargument name="document" hint="the configuration XML org.w3c.dom.Document for this context's XML config file" type="any" required="Yes">
	<cfargument name="xmlFileReader" hint="The xml file reader for the current xml document" type="coldspring.io.XMLFileReader" required="true">
	<cfargument name="xmlParser" hint="The XML Parser used by ColdSpring" type="XmlParser" required="true">
	<cfscript>
		setDocument(arguments.document);
		setXmlFileReader(arguments.xmlFileReader);
		setXmlParser(arguments.xmlParser);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getDocument" hint="the configuration XML org.w3c.dom.Document for this context's XML config file"
	access="public" returntype="any" output="false">
	<cfreturn instance.document />
</cffunction>

<cffunction name="getXmlFileReader" hint="The xml file reader for the current xml document"
	access="public" returntype="coldspring.io.XMLFileReader" output="false">
	<cfreturn instance.xmlFileReader />
</cffunction>

<cffunction name="getXmlParser" access="public" returntype="XmlParser" output="false">
	<cfreturn instance.xmlParser />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setXmlParser" access="private" returntype="void" output="false">
	<cfargument name="xmlParser" type="XmlParser" required="true">
	<cfset instance.xmlParser = arguments.xmlParser />
</cffunction>

<cffunction name="setXmlFileReader" access="private" returntype="void" output="false">
	<cfargument name="xmlFileReader" type="coldspring.io.XMLFileReader" required="true">
	<cfset instance.xmlFileReader = arguments.xmlFileReader />
</cffunction>

<cffunction name="setDocument" access="private" returntype="void" output="false">
	<cfargument name="document" type="any" required="true">
	<cfset instance.document = arguments.document />
</cffunction>


</cfcomponent>