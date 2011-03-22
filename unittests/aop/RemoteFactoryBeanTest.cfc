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

<cfcomponent hint="test for the remote facetory bean" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		super.setup();
		factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-remoteFactoryBean.xml"));
    </cfscript>
</cffunction>

<cffunction name="testSimpleReturnString" hint="test just returning a string" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/unittests/HelloProxy.cfc?method=sayHello&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals("hello", deserializeJSON(local.result.fileContent));
    </cfscript>
</cffunction>

<cffunction name="testAddOnMissingMethod" hint="test adding onMissingMethod" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/unittests/HelloProxyOnMM.cfc?method=doThis&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals("Missing!", deserializeJSON(local.result.fileContent));
    </cfscript>

	<cfscript>
		var local = {};
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/unittests/HelloProxyOnMM.cfc?method=doThat&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals("Missing!", deserializeJSON(local.result.fileContent));
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>