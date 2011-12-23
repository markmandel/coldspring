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
<cfcomponent hint="Test for aop:remote, but just using the attributes of the element" extends="RemoteFactoryBeanTest" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="initFactory" hint="handy method for init'ing the factory I want." access="private" returntype="void" output="false">
	<cfargument name="trusted" hint="whether or not it's trusted source" type="boolean" required="no" default="false">
	<cfscript>
		factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/aop-namespace-remoteAttributes.xml"), arguments);
    </cfscript>
</cffunction>

</cfcomponent>