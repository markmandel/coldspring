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
<cfcomponent hint="Tests for autowiring by name" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="the setup for the tests" access="public" returntype="void" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/beanInjector-byName.xml"));
    </cfscript>
</cffunction>

<cffunction name="testAutowireCar" hint="tests autowiring a car" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		engine = createObject("component", "unittests.testBeans.Engine").init();
		car = createObject("component", "unittests.testBeans.Car").init(engine);

		injector = instance.factory.getBean("beanInjector");

		injector.wire(car);

		assertEquals("Ferrari", car.getMake());
		assertEquals(5, structCount(car.getWheels()));
		assertEquals("blue", car.getColor().getName());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>