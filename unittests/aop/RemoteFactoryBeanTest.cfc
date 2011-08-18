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

		basicProxyPath = expandPath("/unittests/HelloProxy.cfc");
		onMMProxyPath = expandPath("/unittests/HelloProxyOnMM.cfc");
		onMMAOPProxyPath = expandPath("/unittests/HelloProxyOnMMAOP.cfc");

		if(fileExists(basicProxyPath))
		{
			fileDelete(basicProxyPath);
		}
		if(fileExists(onMMProxyPath))
		{
			fileDelete(onMMProxyPath);
		}
		if(fileExists(onMMAOPProxyPath))
		{
			fileDelete(onMMAOPProxyPath);
		}

		initFactory();
    </cfscript>
</cffunction>

<cffunction name="teardown" hint="teardown" access="public" returntype="any" output="false">
	<cfscript>
		var file = createObject("java","java.io.File").init(basicProxyPath);

		file.setWritable(true);

		fileDelete(basicProxyPath);
		fileDelete(onMMProxyPath);
		fileDelete(onMMAOPProxyPath);
    </cfscript>
</cffunction>

<cffunction name="testSimpleReturnString" hint="test just returning a string" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.CONTEXT_PATH#/unittests/HelloProxy.cfc?method=sayHello&returnFormat=json";
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
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.CONTEXT_PATH#/unittests/HelloProxyOnMM.cfc?method=doThis&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals("Missing!", deserializeJSON(local.result.fileContent));
    </cfscript>

	<cfscript>
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.CONTEXT_PATH#/unittests/HelloProxyOnMM.cfc?method=doThat&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals("Missing!", deserializeJSON(local.result.fileContent));
    </cfscript>
</cffunction>

<cffunction name="testAddingInterceptors" hint="test applying interceptors" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.CONTEXT_PATH#/unittests/HelloProxyOnMMAOP.cfc?method=doThis&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals(reverse("Missing!"), deserializeJSON(local.result.fileContent));
    </cfscript>

	<cfscript>
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.CONTEXT_PATH#/unittests/HelloProxyOnMMAOP.cfc?method=doThat&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals(reverse("Missing!"), deserializeJSON(local.result.fileContent));
    </cfscript>

	<cfscript>
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.CONTEXT_PATH#/unittests/HelloProxyOnMMAOP.cfc?method=sayHello&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals(reverse("hello"), deserializeJSON(local.result.fileContent));
    </cfscript>

	<cfscript>
		str = "FooBar!";
		local.path = "http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT##CGI.CONTEXT_PATH#/unittests/HelloProxyOnMMAOP.cfc?method=sayHello&str=#urlEncodedFormat(str)#&returnFormat=json";
    </cfscript>
    <cfhttp url="#local.path#" method="get" result="local.result">

	<cfscript>
		debug(local.result);
		assertEquals(reverse(str), deserializeJSON(local.result.fileContent));
    </cfscript>
</cffunction>

<cffunction name="testTrustedSource" hint="test to see if trusted source regenerates the file or not" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.path = expandPath("/unittests/HelloProxy.cfc");
		local.file = createObject("java","java.io.File").init(basicProxyPath);
		local.catch = false;

		//gate
		assertFalse(factory.getBean("&helloProxy").isTrustedSource());

		//set it to be readable only
		local.file.setWritable(false);

		//create a new factory
		try
		{
			initFactory();
		}
		catch(any exc)
		{
			local.catch = true;
			assertTrue(exc.detail contains "The Delete cannot be performed.");
		}

		assertTrue(local.catch, "Should fail, as the file is read only, and it should attempt to overwrite it.");

		//below should pass, as we don't set the file to read only.
		initFactory(true);
		//gate
		assertTrue(factory.getBean("&helloProxy").isTrustedSource());

		//one more time for kicks.
		initFactory(true);
		//gate
		assertTrue(factory.getBean("&helloProxy").isTrustedSource());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initFactory" hint="handy method for init'ing the factory I want." access="private" returntype="void" output="false">
	<cfargument name="trusted" hint="whether or not it's trusted source" type="boolean" required="no" default="false">
	<cfscript>
		factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-remoteFactoryBean.xml"), arguments);
    </cfscript>
</cffunction>

</cfcomponent>