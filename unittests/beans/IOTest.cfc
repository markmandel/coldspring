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
		instance.javaloader = createObject("component", "coldspring.util.java.JavaLoader").init("unittest");
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="basicXMLReaderTest" hint="test basic XML parsing with the XMLFileReader" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.entityMap = {};

		local.entityMap["http://coldspringframework.org/schema/coldspring-beans-2.0.xsd"] = expandPath("/coldspring/beans/xml/config/coldspring-beans-2.0.xsd");

		local.reader = createObject("component", "coldspring.io.XMLFileReader").init(expandPath("/unittests/testBeans/emptyBeans.xml"), instance.javaloader, local.entityMap);

		local.document = local.reader.parseToDocument();

		local.document.normalize();

		local.element = local.document.getDocumentElement();

		assertEquals("beans", local.element.getLocalName());
		assertEquals("http://www.coldspringframework.org/schema/beans", local.element.getNamespaceURI());
		assertEquals("byName", local.element.getAttribute("default-autowire"));
		assertEquals("false", local.element.getAttribute("default-lazy-init"));
    </cfscript>
</cffunction>

<cffunction name="invalidXMLReaderTest" hint="test erronous XML document" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.io.exception.InvalidXMLException">
	<cfscript>
		var local = {};

		local.reader = createObject("component", "coldspring.io.XMLFileReader").init(expandPath("/unittests/testBeans/errorXML/brokenBeans.xml"), instance.javaloader);

		local.document = local.reader.parseToDocument();
    </cfscript>
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>