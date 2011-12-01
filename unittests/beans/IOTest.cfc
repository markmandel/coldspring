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

<cfcomponent extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="" access="public" returntype="void" output="false">
	<cfscript>
		instance.javaloader = createObject("component", "coldspring.core.java.JavaLoader").init("unittest");
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="basicXMLReaderTest" hint="test basic XML parsing with the XMLFileReader" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.entityMap = {};

		local.path = expandPath("/coldspring/beans/xml/config/coldspring-beans-2.0.xsd");

		local.entityMap["http://coldspringframework.org/schema/coldspring-beans-2.0.xsd"] = local.path;
		local.entityMap["http://www.coldspringframework.org/schema/coldspring-beans-2.0.xsd"] = local.path;

		local.reader = createObject("component", "coldspring.core.io.XMLFileReader").init(expandPath("/unittests/testBeans/emptyBeans.xml"), local.entityMap);

		local.document = local.reader.parseToDocument();

		local.document.normalize();

		local.element = local.document.getDocumentElement();

		assertEquals("beans", local.element.getLocalName());
		assertEquals("http://www.coldspringframework.org/schema/beans", local.element.getNamespaceURI());
		assertEquals("byName", local.element.getAttribute("default-autowire"));
		assertEquals("true", local.element.getAttribute("default-lazy-init"));
    </cfscript>
</cffunction>

<cffunction name="invalidXMLReaderTest" hint="test erronous XML document" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.core.io.exception.InvalidXMLException">
	<cfscript>
		var local = {};

		local.reader = createObject("component", "coldspring.core.io.XMLFileReader").init(expandPath("/unittests/testBeans/errorXML/brokenBeans.xml"), instance.javaloader);

		local.document = local.reader.parseToDocument();
    </cfscript>
</cffunction>

<cffunction name="invalidXMLStringTest" hint="test out an invlid XML string" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.core.io.exception.InvalidXMLException">
    <cfscript>
        var local = {};
        var xml = fileRead(expandPath("/unittests/testBeans/errorXML/brokenBeans.xml"));

        local.reader = createObject("component", "coldspring.core.io.XMLStringReader").init(xml, instance.javaloader);

        local.document = local.reader.parseToDocument();
   </cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>