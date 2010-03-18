74<!---
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

<cfcomponent hint="Unit tests for BeanDefinitions and support" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="the setup for the tests" access="public" returntype="void" output="false">
	<cfscript>
		instance.factory = createObject("component", "unittests.testBeans.BeanFactory").init();
    </cfscript>
</cffunction>

<cffunction name="testRefValueConstruction" hint="tests to see if ref values will construct properly" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		//car needs an engine
		local.car = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("car", instance.factory.getBeanDefinitionRegistry());
		local.car.setClassName("unittests.testBeans.Car");

		local.engine = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("engine", instance.factory.getBeanDefinitionRegistry());
		local.engine.setClassName("unittests.testBeans.Engine");

		local.color = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("color", instance.factory.getBeanDefinitionRegistry());
		local.color.setClassName("unittests.testBeans.Color");

		//constructor arg to point to the engine and color
		local.engineRef = createObject("component", "coldspring.beans.support.RefValue").init("engine", instance.factory.getBeanDefinitionRegistry());
		local.colorRef = createObject("component", "coldspring.beans.support.RefValue").init("color", instance.factory.getBeanDefinitionRegistry());

		local.engineArg = createObject("component", "coldspring.beans.support.ConstructorArg").init("engine", local.engineRef);
		local.colorProp = createObject("component", "coldspring.beans.support.Property").init("color", local.colorRef);

		// ArrayAppend(local.car.getConstructorArgs(), local.engineArg);
		local.car.addConstructorArg(local.engineArg);
		local.car.addProperty(local.colorProp);

		instance.factory.addBeanDefinition(local.car);
		instance.factory.addBeanDefinition(local.engine);
		instance.factory.addBeanDefinition(local.color);

		// calling getValue on the RefValue will laod the beanDefinition and instance
		local.engineInst = local.engine.getInstance();
		local.engineInstRef = local.engineRef.getValue();

		local.colorInst = local.colorRef.getValue();
		local.colorInstRef = local.color.getInstance();

		// engineInstance and engineRef should be equal
		AssertEquals(local.engineInst, local.engineInstRef);
		// same with color and colorRef
		AssertEquals(local.colorInst, local.colorInstRef);
		// and the engine beandef should be the same as the one in the ref
		AssertEquals(local.engineRef.getBeanDefinition(), local.engine);

		local.carInst = instance.factory.getBean("car");

		AssertTrue(isObject(local.carInst));

		AssertEquals(local.carInst.getEngine(), local.engineInst);
		AssertEquals(local.carInst.getColor(), local.colorInst);
    </cfscript>
</cffunction>

<cffunction name="testCFCAutowireByName" hint="test basic autowiring, hopefully it works" access="public" returntype="void" output="false">
	<cfscript>
		//car needs an engine
		local.car = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("car", instance.factory.getBeanDefinitionRegistry());
		local.car.setClassName("unittests.testBeans.Car");

		local.car.setAutowire("byName");

		local.engine = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("engine", instance.factory.getBeanDefinitionRegistry());
		local.engine.setClassName("unittests.testBeans.Engine");

		local.color = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("color", instance.factory.getBeanDefinitionRegistry());
		local.color.setClassName("unittests.testBeans.Color");

		instance.factory.addBeanDefinition(local.car);
		instance.factory.addBeanDefinition(local.engine);
		instance.factory.addBeanDefinition(local.color);

		instance.factory.endRefresh();

		local.carInst = instance.factory.getBean("car");

		local.engineInst = instance.factory.getBean("engine");
		local.colorInst = instance.factory.getBean("color");

		AssertTrue(isObject(local.carInst));

		AssertEquals(local.carInst.getEngine(), local.engineInst);
		AssertEquals(local.carInst.getColor(), local.colorInst);
    </cfscript>
</cffunction>

<!--- TODO: this isn't going to work yet, until we implement caching --->
<cffunction name="testCFCAutowireCircularReference" hint="test a circular reference with autowiring" access="public" returntype="void" output="false">
	<cfscript>
		local.cr1 = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("circularReference1", instance.factory.getBeanDefinitionRegistry());
		local.cr1.setClassName("unittests.testBeans.CircularReference1");
		local.cr1.setAutowire("byName");

		local.cr2 = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init("circularReference2", instance.factory.getBeanDefinitionRegistry());
		local.cr2.setClassName("unittests.testBeans.CircularReference2");
		local.cr2.setAutowire("byName");

		instance.factory.addBeanDefinition(local.cr1);
		instance.factory.addBeanDefinition(local.cr2);

		instance.factory.endRefresh();

		local.cr1Inst = instance.factory.getBean("circularReference1");

		AssertEquals(getMetaData(local.cr1Inst.getCircularReference2()).name, "unittests.testBeans.CircularReference2", "Not the same class name");

		AssertSame(local.cr1Inst, local.cr1Inst.getCircularReference2().getCircularReference1(), "Not the same object");
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>