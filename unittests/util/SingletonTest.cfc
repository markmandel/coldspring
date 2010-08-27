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
<cfcomponent hint="Test for singleton helper" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="void" output="false">
	<cfscript>
		instance.singleton = createObject("component", "coldspring.util.Singleton").init();
    </cfscript>
</cffunction>

<cffunction name="testSimpleSingleton" hint="test a simple singleton" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.engine1 = instance.singleton.createInstance("unittests.testBeans.Engine");
		local.engine2 = instance.singleton.createInstance("unittests.testBeans.Engine");

		assertSame(local.engine1, local.engine2);

		assertSame(local.engine1, getMetadata(local.engine1).static.instance);
		assertSame(local.engine1, getComponentMetaData("unittests.testBeans.Engine").static.instance);

		local.engine3 = instance.singleton.createInstance(class="unittests.testBeans.Engine", key="foo");

		assertNotSame(local.engine1, local.engine3);

		local.engine4 = instance.singleton.createInstance(class="unittests.testBeans.Engine", key="foo");

		assertSame(local.engine3, local.engine4);

		assertSame(local.engine3, getMetadata(local.engine3).static.foo);
		assertSame(local.engine3, getComponentMetaData("unittests.testBeans.Engine").static.foo);
    </cfscript>
</cffunction>

<cffunction name="testOverwrittenInit" hint="tests an overwritten init value" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.cfcMetaUtil1 = createObject("component", "coldspring.util.CFCMetaUtil").init();
		local.cfcMetaUtil2 = createObject("component", "coldspring.util.CFCMetaUtil").init();

		assertSame(local.cfcMetaUtil1, local.cfcMetaUtil2);

		assertSame(local.cfcMetaUtil1, getMetadata(local.cfcMetaUtil1).static.instance);
		assertSame(local.cfcMetaUtil1, getComponentMetaData("coldspring.util.CFCMetaUtil").static.instance);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>