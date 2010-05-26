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

<cfcomponent hint="Unit tests for XmlFactory parsing and support" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="the setup for the tests" access="public" returntype="void" output="false">
	<cfscript>
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/car-beans.xml"));
    </cfscript>
</cffunction>

<cffunction name="getSingletonBeanTest" hint="test to get just a single, singleton bean" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.engine = instance.factory.getBean("engine");

		//we did get back an engine
		assertEquals(getMetaData(local.engine).name, "unittests.testBeans.Engine");
		assertEquals("default engine", local.engine.getType());
    </cfscript>
</cffunction>

<cffunction name="getManuallyInjectedTest" hint="test to get just a bean with constructor and property args" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car1");

		testCar(local.car);
    </cfscript>
</cffunction>

<cffunction name="getManuallyInjectedTest2" hint="test to get just a bean with constructor and property args (nested values)" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car2");

		testCar(local.car, false);
    </cfscript>
</cffunction>

<cffunction name="getAutowireTest1" hint="test to get just a bean autowired by name" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car3");

		testCar(local.car, false);
    </cfscript>
</cffunction>

<cffunction name="getAnonymouseBeanTest1" hint="test" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car4");

		testCar(local.car, false);
    </cfscript>
</cffunction>

<cffunction name="testFactoryBean" hint="test implementation of factory bean and method" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car5");

		testCar(local.car, true);
    </cfscript>
</cffunction>

<cffunction name="testCar" hint="test out a car" access="private" returntype="void" output="false">
	<cfargument name="car" hint="the car to test" type="any" required="Yes">
	<cfargument name="sameWheels" hint="all wheels are the same object?" type="boolean" required="No" default="false">
	<cfscript>
		var local = {};

		assertEquals(getMetaData(arguments.car).name, "unittests.testBeans.Car");

		assertEquals("Mustang", arguments.car.getMake());

		local.engine = arguments.car.getEngine();

		local.gears = [ 1, 2, 3 ];

		assertEquals(local.gears, local.engine.getGears());

		//we did get back an engine
		assertEquals(getMetaData(local.engine).name, "unittests.testBeans.Engine");
		assertEquals("default engine", local.engine.getType());

		//did we get a colour?
		local.colour = arguments.car.getColor();

		assertEquals(getMetaData(local.colour).name, "unittests.testBeans.Color");

		assertEquals("blue", local.colour.getName());

		local.wheels = arguments.car.getWheels();

		assertEquals(5, structCount(local.wheels), "should be 5 wheels");

		assertTrue(StructkeyExists(local.wheels, "spare"));

		if(arguments.sameWheels)
		{
			assertSame(local.wheels["1"], local.wheels["2"], "should be same wheels (1)");
			assertSame(local.wheels["3"], local.wheels["2"], "should be same wheels (2)");
			assertSame(local.wheels["3"], local.wheels["4"], "should be same wheels (3)");
			assertSame(local.wheels["spare"], local.wheels["4"], "should be same wheels (4)");
		}
		else
		{
			assertNotSame(local.wheels["1"], local.wheels["2"], "should be different wheels (1)");
			assertNotSame(local.wheels["3"], local.wheels["2"], "should be different wheels (2)");
			assertNotSame(local.wheels["3"], local.wheels["4"], "should be different wheels (3)");
			assertNotSame(local.wheels["spare"], local.wheels["4"], "should be different wheels (4)");
		}
    </cfscript>
</cffunction>

<cffunction name="testSimpleMap" hint="tests a simple map" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("carSimpleMap");

		local.wheels = local.car.getWheels();

		local.testWheels = {
			dog="red"
			,john="soda"
		};

		assertEquals(local.wheels, local.testWheels);
    </cfscript>
</cffunction>

<cffunction name="testObjectKeyMap" hint="tests a simple map" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("carObjectKeyMap");

		local.colour1 = instance.factory.getBean("color1");
		local.colour2 = instance.factory.getBean("color2");

		local.wheels = local.car.getWheels();

		assertEquals("frodo", local.wheels.get(local.colour1));
		assertEquals("baggins", local.wheels.get(local.colour2));
    </cfscript>
</cffunction>

<cffunction name="testAbstractBean" hint="test if an abstract bean throws an error when we try and grab it" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.beans.support.exception.AbstractBeanCannotBeInstantiatedException">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("abstractCar");
    </cfscript>
</cffunction>

<cffunction name="testMetaOnBean" hint="test to see if adding meta to a bean works" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		makePublic(instance.factory, "getBeanDefinitionRegistry");

		local.beanDef = instance.factory.getBeanDefinitionRegistry().getBeanDefinition("car3");

		AssertTrue(structIsEmpty(local.beanDef.getMeta()));

		local.beanDef = instance.factory.getBeanDefinitionRegistry().getBeanDefinition("car4");

		AssertTrue(structKeyExists(local.beanDef.getMeta(), "keyValue1"));
		AssertTrue(structKeyExists(local.beanDef.getMeta(), "keyValue2"));

		AssertFalse(structKeyExists(local.beanDef.getMeta(), "makeBrand"));

		AssertEquals("metaValue1", structFind(local.beanDef.getMeta(), "keyValue1"));
		AssertEquals("metaValue2", structFind(local.beanDef.getMeta(), "keyValue2"));
    </cfscript>
</cffunction>

<cffunction name="testMetaOnProperty" hint="tests meta on a property" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		makePublic(instance.factory, "getBeanDefinitionRegistry");

		local.beanDef = instance.factory.getBeanDefinitionRegistry().getBeanDefinition("car3");

		local.properties = local.beanDef.getProperties();

		AssertTrue(structIsEmpty(local.properties.make.getMeta()));

		local.beanDef = instance.factory.getBeanDefinitionRegistry().getBeanDefinition("car4");

		local.properties = local.beanDef.getProperties();

		AssertFalse(structIsEmpty(local.properties.make.getMeta()));

		AssertEquals("Ford", structFind(local.properties.make.getMeta(), "makeBrand"));
    </cfscript>
</cffunction>

<cffunction name="testMetaOnConstructorArg" hint="test a meta on constructor arg" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		makePublic(instance.factory, "getBeanDefinitionRegistry");

		local.beanDef = instance.factory.getBeanDefinitionRegistry().getBeanDefinition("car1");

		local.constructorArgs = local.beanDef.getConstructorArgs();

		AssertFalse(structKeyExists(local.constructorArgs.engine.getMeta(), "engineMeta"));

		local.beanDef = instance.factory.getBeanDefinitionRegistry().getBeanDefinition("car2");

		local.constructorArgs = local.beanDef.getConstructorArgs();

		AssertTrue(structKeyExists(local.constructorArgs.engine.getMeta(), "engineMeta"));
		AssertTrue(structKeyExists(local.constructorArgs.engine.getMeta(), "engineMeta2"));
    </cfscript>
</cffunction>

<cffunction name="testAutowireByType" hint="tests to make sure autowire by type is working" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/autowire-by-type-car-beans.xml"));
		instance.factory.refresh();

		local.car = instance.factory.getBean("car1");

		local.engine = local.car.getEngine();
		assertEquals("default engine", local.engine.getType());

		local.colour = local.car.getColor();
		assertEquals("blue", local.colour.getName());
    </cfscript>
</cffunction>

<cffunction name="testAutowireByTypeAmbiguousExceptionConstructor" hint="tests to make sure autowire by type is working" access="public" returntype="void" output="false"
			mxunit:expectedException="coldspring.beans.support.exception.AmbiguousTypeAutowireException">
	<cfscript>
		var local = {};

		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/errorXML/autowire-by-type-ambiguous-constructor.xml"));
		instance.factory.refresh();

		local.car = instance.factory.getBean("car1");
    </cfscript>
</cffunction>

<cffunction name="testAutowireByTypeAmbiguousExceptionProperty" hint="tests to make sure autowire by type is working" access="public" returntype="void" output="false"
			mxunit:expectedException="coldspring.beans.support.exception.AmbiguousTypeAutowireException">
	<cfscript>
		var local = {};

		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/errorXML/autowire-by-type-ambiguous-property.xml"));
		instance.factory.refresh();

		local.car = instance.factory.getBean("car1");
    </cfscript>
</cffunction>

<cffunction name="testNoClassSet" hint="test for when no class has been set" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.beans.support.exception.BeanDefinitionValidationException">
	<cfscript>
		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/errorXML/no-class-set.xml"));
		instance.factory.refresh();
    </cfscript>
</cffunction>

<cffunction name="testOnlyFactoryBean" hint="test when only a factory bean has been set" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.beans.support.exception.BeanDefinitionValidationException">
	<cfscript>
		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/errorXML/only-factory-method.xml"));
		instance.factory.refresh();
    </cfscript>
</cffunction>

<cffunction name="testOnlyFactoryMethod" hint="test for when only a factory method has been set" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.beans.support.exception.BeanDefinitionValidationException">
	<cfscript>
		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/errorXML/only-factory-bean.xml"));
		instance.factory.refresh();
    </cfscript>
</cffunction>

<cffunction name="testFactoryBeanAndClass" hint="test for when only a factory bean and class has been set" access="public" returntype="void" output="false"
	mxunit:expectedException="coldspring.beans.support.exception.BeanDefinitionValidationException">
	<cfscript>
		instance.factory.setConfigLocations(expandPath("/unittests/testBeans/errorXML/factory-bean-and-class.xml"));
		instance.factory.refresh();
    </cfscript>
</cffunction>

<cffunction name="testInitMethod" hint="test the init method works" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("car1");

		assertEquals(reverse(local.car.getMake()), local.car.getReverseMake());
    </cfscript>
</cffunction>

<cffunction name="testPrototype" hint="tests prototype scope" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.car = instance.factory.getBean("wheel");
		local.reget = instance.factory.getBean("wheel");

		assertNotSame(local.car, local.reget);
	</cfscript>
</cffunction>

<cffunction name="testLazyInit" hint="testing of lazy init" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		assertFalse(StructKeyExists(request, "nameToRequest1"), "nameToRequest1 should NOT be there");
		assertTrue(StructKeyExists(request, "nameToRequest2"), "nameToRequest2 should be there");

		local.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/factory.config.xml"));

		assertTrue(StructKeyExists(request, "nameToRequest3"), "nameToRequest3 should be there");
		assertFalse(StructKeyExists(request, "nameToRequest4"), "nameToRequest4 should NOT be there");
    </cfscript>
</cffunction>

<cffunction name="testParentCar" hint="test that a car with a parent works" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.beanDef = instance.factory.getBeanDefinition("childCar");

		local.car = instance.factory.getBean("childCar");

		testCar(local.car);
    </cfscript>
</cffunction>

<cffunction name="importTest" hint="test the <import> element" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		instance.factory = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/import-test.xml"));

		debug(instance.factory.getAliases("car1"));

		local.car1 = instance.factory.getBean("car1");

		testCar(local.car1);

		local.car2 = instance.factory.getBean("import_carAlias");

		testCar(local.car2);

		assertSame(local.car1, local.car2);

		local.car3 = instance.factory.getBean("import_car1");

		testCar(local.car3);
    </cfscript>
</cffunction>

<cffunction name="containsTest" hint="" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		assertTrue(instance.factory.containsBean("engine"));
		assertTrue(instance.factory.containsBeanDefinition("engine"));

		assertFalse(instance.factory.containsBean("fubar"));
		assertFalse(instance.factory.containsBeanDefinition("fubar"));
    </cfscript>
</cffunction>

</cfcomponent>