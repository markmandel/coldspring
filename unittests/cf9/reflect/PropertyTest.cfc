/*
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
*/

component  extends="unittests.AbstractTestCase"
{
	/**
     * setup
     */
    public void function setup()
    {
    	reflectionService = createObject("component", "coldspring.core.reflect.ReflectionService").init();
		reflectionService.clearCache();
    }

    /**
     * test no properties
     *
     * @mxunit:expectedException coldspring.core.reflect.exception.PropertyNotFoundException
     */
    public void function testNoProperties()
    {
    	var class = reflectionService.loadClass("unittests.reflect.com.Hello");
    	var properties = class.getProperties();
    	assertTrue(StructIsEmpty(properties));

    	var properties = class.getDeclaredProperties();
    	assertTrue(StructIsEmpty(properties));

    	assertFalse(class.hasDeclaredProperty("foo"));
    	assertFalse(class.hasProperty("foo"));

    	class.getProperty("foo");
    }

	/**
     * testNoDeclaredProperty
     *
     * @mxunit:expectedException coldspring.core.reflect.exception.PropertyNotFoundException
     */
    public void function testNoDeclaredProperty()   expectedException="coldspring.core.reflect.exception.PropertyNotFoundException"
    {
    	var class = reflectionService.loadClass("unittests.cf9.reflect.com.Foo");
    	class.getDeclaredProperty("foo");
    }

    /**
     * testProperties
     */
    public void function testProperties()
    {
    	var class = reflectionService.loadClass("unittests.cf9.reflect.com.Bar");

		assertTrue(class.hasProperty("bar"));
		assertTrue(class.hasProperty("Foo"));
		assertTrue(class.hasDeclaredProperty("bar"));
		assertTrue(class.hasDeclaredProperty("foo"));

		assertEquals(4, StructCount(class.getProperties()));
		assertEquals(4, StructCount(class.getDeclaredProperties()));

		assertEquals("bar", class.getProperty("bar").getName());
		assertEquals("foo", class.getDeclaredProperty("foo").getName());

		assertEquals("stuff", class.getDeclaredProperty("bar").getMeta().hint);
    }

    /**
     * test inherited Properties
     */
    public void function testInheritedProperties()
    {
    	var class = reflectionService.loadClass("unittests.cf9.reflect.com.Foo");

    	assertTrue(class.hasProperty("Bar"));
    	assertTrue(class.hasProperty("Foo"));
    	assertTrue(class.hasDeclaredProperty("Bar"));
    	assertFalse(class.hasDeclaredProperty("Foo"));

		assertEquals(4, StructCount(class.getProperties()));
		assertEquals(1, StructCount(class.getDeclaredProperties()));

		var property = class.getProperty("Foo");
		assertEquals("Foo", property.getName());

		var property = class.getProperty("bar");
		assertEquals("bar", property.getName());

		assertEquals("Should be overwritten", property.getMeta().hint);
    }

    /**
     * test accessorsEnabled
     */
    public void function testAccessorsEnabled()
    {
    	var class = reflectionService.loadClass("unittests.cf9.reflect.com.Bar");
    	assertTrue(class.isAccessorsEnabled());
    	var class = reflectionService.loadClass("unittests.cf9.reflect.com.Foo");
    	assertTrue(class.isAccessorsEnabled());
    	var class = reflectionService.loadClass("unittests.cf9.hibernate.com.Foo");

	    //writeDump(class.getMeta());abort;

    	assertTrue(class.isAccessorsEnabled());

    	var class = reflectionService.loadClass("unittests.testBeans.Car");
    	assertFalse(class.isAccessorsEnabled());
    }

    /**
     * testGetterAndSetter
     */
    public void function testGetterAndSetter()
    {
	    var class = reflectionService.loadClass("unittests.cf9.reflect.com.Bar");
	    assertTrue(class.getProperty("foo").hasSetter());
	    assertTrue(class.getProperty("foo").hasGetter());

	    assertFalse(class.getProperty("noSetter").hasSetter());
	    assertTrue(class.getProperty("noSetter").hasGetter());

	    assertTrue(class.getProperty("noGetter").hasSetter());
	    assertFalse(class.getProperty("noGetter").hasGetter());
    }
}