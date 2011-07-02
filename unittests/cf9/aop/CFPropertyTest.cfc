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
<cfcomponent hint="test to make sure cfproperty still works" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup" access="public" returntype="void" output="false">
	<cfscript>
		factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-aspect.xml"));
    </cfscript>
</cffunction>

<cffunction name="testCFProperty" hint="test out that cfproperty works" access="public" returntype="void" output="false">
	<cfscript>
		var proxy = factory.getBean("hello");
		var storage = factory.getBean("storage");

		//should be nothing in there.
		assertTrue(isNull(proxy.getFoo()));
		assertTrue(isNull(proxy.__$getInvocationHandler().getTarget().getFoo()));

		proxy.setFoo("bar");

		assertEquals("bar", proxy.getFoo());
		assertEquals("bar", proxy.__$getInvocationHandler().getTarget().getFoo());

		assertEquals("bar", storage.getReturn());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>