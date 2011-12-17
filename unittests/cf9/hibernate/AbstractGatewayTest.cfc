/*
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
*/

/**
 * class for unit testing the abstract gateway
 */
component  extends="AbstractHibernateTest"
{
	/**
     * setup method
     */
    public void function setup()
    {
		super.setup();
	    engine = new coldspring.util.Engine();
		instance.gateway = new coldspring.orm.hibernate.AbstractGateway();
    }

	/**
     * test get by id
     */
    public void function testGetByID()
    {
		local.foo = instance.gateway.getFoo(1);

		assertEquals(local.foo.getName(), "Han Solo");
    }

	/**
     * test get by property
     */
    public void function testGetByProperty()
    {
		local.value = "Luke Skywalker";
		local.foo = instance.gateway.getFooByName(local.value);

		assertEquals(local.foo.getName(), local.value);
    }

	/**
     * test gettings something that doesn't exist, you get a new one
     */
    public void function testGetNonExistant()
    {
		local.value = "John Lock";
		local.foo = instance.gateway.getFooByName(local.value);

		assertNotEquals(local.foo.getName(), local.value);
		assertTrue(isNull(local.foo.getID()));
    }

	/**
     * test basic list
     */
    public void function testBasicList()
    {
		local.result = instance.gateway.listFoo();

		assertEquals(3, Arraylen(local.result));
    }

	/**
     * test ordered list
     */
    public void function testOrderedList()
    {
		local.result = instance.gateway.listFooOrderByName();

		assertEquals("Darth Vader", local.result[1].getName());
    }

	/**
     * test filtered list
     */
    public void function testFilteredList()
    {
		local.result = instance.gateway.listFooFilterByName("Darth Vader");

		assertEquals(1, ArrayLen(local.result));
		assertEquals("Darth Vader", local.result[1].getName());
    }

	/**
     * test filtered, ordered list
     */
    public void function testFilteredOrderedList()
    {
		local.result = instance.gateway.listFooFilterByNameOrderByID("Darth Vader");

		assertEquals(1, ArrayLen(local.result));
		assertEquals("Darth Vader", local.result[1].getName());
    }

	/**
     * test NewXXX
     */
    public void function testNew()
    {
		local.object = instance.gateway.newFoo();

		assertEquals("I am new!", local.object.getName());
    }

	/**
     * test saveXXX
     */
    public void function testSave()
    {
		local.result = instance.gateway.getFooByName("Darth Vader");

		local.result.setName("Mark Mandel");

		instance.gateway.saveFoo(local.result);

		ormFlush();
		ormClearSession();

		local.result = instance.gateway.getFooByName("Mark Mandel");

		assertEquals("Mark Mandel", local.result.getName());
    }

	/**
     * test deleteXXX
     */
    public void function testDelete()
    {
		local.result = instance.gateway.listFoo();

		assertEquals(3, Arraylen(local.result));

		local.result = instance.gateway.getFooByName("Darth Vader");

		instance.gateway.deleteFoo(local.result);

		ormFlush();

		local.result = instance.gateway.listFoo();

		assertEquals(2, Arraylen(local.result));
    }

	/**
     * test enable filter
     */
    public void function testEnableFilter()
    {
	    //railo doesn't support manual mappings
	    if(engine.getName() eq "Railo")
	    {
		    return;
	    }

		local.result = instance.gateway.listFoo();
		assertEquals(3, Arraylen(local.result));

		instance.gateway.enableFilterName(name="Darth Vader");

		local.result = instance.gateway.listFoo();
		assertEquals(1, Arraylen(local.result));

		assertEquals("Darth Vader", local.result[1].getName());

		//turn this off after the test, otherwise other tests fail.
		instance.gateway.disableFilterName();
    }

	/**
     * test disable filter
     */
    public void function testDisableFilter()
    {
		//railo doesn't support manual mappings
	    if(engine.getName() eq "Railo")
	    {
		    return;
	    }

		instance.gateway.enableFilterName(name="Darth Vader");

		local.result = instance.gateway.listFoo();
		assertEquals(1, Arraylen(local.result));

		assertEquals("Darth Vader", local.result[1].getName());

		instance.gateway.disableFilterName();

		local.result = instance.gateway.listFoo();
		assertEquals(3, Arraylen(local.result));
    }

	/**
     * test dependency injection on new
     */
    public void function testNewDI()
    {
		var injector = application.coldspring.getBean("beanInjector");
		var sessionWrapper = new coldspring.orm.hibernate.SessionWrapper(injector);

		gateway = new coldspring.orm.hibernate.AbstractGateway(sessionWrapper);

		var foo = gateway.newFoo();

		assertEquals("Gandalf", local.foo.getInject());
    }

}