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
component  extends="unittests.AbstractTestCase"
{
	/**
     * setup method
     */
    public void function setup()
    {
		super.setup();
		ormReload();

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

}