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

component extends="AbstractHibernateTest"
{
	/**
     * setup
     */
    public void function setup()
    {
		super.setup();
		sessionWrapper = new coldspring.orm.hibernate.SessionWrapper();
    }

	/**
     * test GetORMGetSession
     */
    public void function testGetORMGetSession()
    {
		var sess1 = sessionWrapper.getORMSession();
		var sess2 = ormGetSession();

		assertSame(sess1, sess2);
    }

	/**
     * test ORMGetSession factory
     */
    public void function testGetORMGetSessionFactory()
    {
		var sessf1 = sessionWrapper.getSessionFactory();
		var sessf2 = ormGetSessionFactory();

		assertSame(sessf1, sessf2);
    }

	/**
     * sees if get works
     */
    public void function testGet()
    {
		local.foo = sessionWrapper.get("Foo", 1);
		assertEquals(local.foo.getName(), "Han Solo");

		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		assertEquals("Darth Vader", local.result.getName());
    }

	/**
     * test basic list
     */
    public void function testBasicList()
    {
		local.result = sessionWrapper.list("Foo");

		assertEquals(3, Arraylen(local.result));
    }

	/**
     * test ordered list
     */
    public void function testOrderedList()
    {
		local.result = sessionWrapper.list(entityname="Foo", sortorder="name asc");

		assertEquals("Darth Vader", local.result[1].getName());
    }

	/**
     * test filtered list
     */
    public void function testFilteredList()
    {
		local.result = sessionWrapper.list("Foo", {name="Darth Vader"});

		assertEquals(1, ArrayLen(local.result));
		assertEquals("Darth Vader", local.result[1].getName());
    }

	/**
     * test filtered, ordered list
     */
    public void function testFilteredOrderedList()
    {
		local.result = sessionWrapper.list("Foo", {name="Darth Vader"}, "name asc", {ignorecase=true});

		assertEquals(1, ArrayLen(local.result));
		assertEquals("Darth Vader", local.result[1].getName());
    }

	/**
	 * test passing through an option to list() for offset, cachename etc
	 */
	public void function testOptionedList()
	{
		var result1 = sessionWrapper.list("Foo");

		var count = (arraylen(result1) - 1);

		var options = {maxResults = count};
		var result2 = sessionWrapper.list(entityname="Foo", options=options);

		assertEquals(count, arraylen(result2));
	}

	/**
     * test delete
     */
    public void function testDelete()
    {
		local.result = sessionWrapper.list("Foo");

		assertEquals(3, Arraylen(local.result));

		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		sessionWrapper.delete(local.result);

		ormFlush();

		local.result = sessionWrapper.list("Foo");

		assertEquals(2, Arraylen(local.result));
    }

	/**
     * test save
     */
    public void function testSave()
    {

		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		sessionWrapper.save(local.result);

		ormFlush();
		ormClearSession();

		local.result = sessionWrapper.get("Foo", {name= "Mark Mandel"});

		assertEquals("Mark Mandel", local.result.getName());
    }

	/**
     * test update
     */
    public void function testUpdate()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		sessionWrapper.update(local.result);

		ormFlush();
		ormClearSession();

		local.result = sessionWrapper.get("Foo", {name= "Mark Mandel"});

		assertEquals("Mark Mandel", local.result.getName());
    }

	/**
     * test merge
     */
    public void function testMerge()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		local.merge = sessionWrapper.merge(local.result);

		ormFlush();
		ormClearSession();

		local.result = sessionWrapper.get("Foo", {name= "Mark Mandel"});

		assertEquals("Mark Mandel", local.result.getName());
    }

	/**
     * test insert
     */
    public void function testInsert()
    {
		local.result = sessionWrapper.new("Foo");

		local.result.setName("Mark Mandel");

		sessionWrapper.insert(local.result);

		ormFlush();
		ormClearSession();

		local.result = sessionWrapper.list("Foo");

		assertEquals(4, Arraylen(local.result));
	}

	/**
     * test Clear
     */
    public void function testClear()
    {
		local.result1 = sessionWrapper.get("Foo", {name= "Darth Vader"});
		sessionWrapper.clear();

		local.result2 = sessionWrapper.get("Foo", {name= "Darth Vader"});

		assertNotSame(local.result1, local.result2);
    }

	/**
     * test reload
     */
    public void function testReload()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		var query = new Query(sql="update Foo set name='Clark Kent' where id = :id");
		query.addParam(name="id", value=local.result.getID(), cfsqltype="integer");
		debug(query.execute());

	    //gate
	    query.setSQL("select * from Foo where id = :id");
	    assertEquals("Clark Kent", query.execute().getResult().name);

		sessionWrapper.reload(local.result);

		assertEquals("Clark Kent", local.result.getName());
    }

	/**
     * test flush
     */
    public void function testFlush()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		sessionWrapper.update(local.result);

		sessionWrapper.flush();
		sessionWrapper.clear();

		local.result = sessionWrapper.get("Foo", {name= "Mark Mandel"});

		assertEquals("Mark Mandel", local.result.getName());
    }

	/**
     * test close
     */
    public void function testClose()
    {
		var sess1 = sessionWrapper.getORMSession();

		sessionWrapper.close();

		var sess2 = sessionWrapper.getORMSession();

		assertNotSame(sess1, sess2);
    }

	/**
     * test basic HQL
     */
    public void function testBasicHQL()
    {
		local.result = sessionWrapper.executeQuery("from Foo");

		assertEquals(3, Arraylen(local.result));
    }

	/**
     * testCacheEvictEntity
	 * This is more of a integration test, as I don't want to turn on 2nd level cache.
     */
    public void function testCacheEvictEntity()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		sessionWrapper.cacheEvictEntity("Foo");
		sessionWrapper.cacheEvictEntity("Foo", 1);
    }

	/**
     * test cache Evict collection
	 * This is more of a integration test, as I don't want to turn on 2nd level cache.
     */
    public void function testCacheEvictCollection()
    {
	    var engine = new coldspring.util.Engine();

	    //throws an error on railo. Pain to test this really.
	    if(engine.getName() != "Railo")
	    {
		    local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

            sessionWrapper.cacheEvictCollection("Foo", "bar");
            sessionWrapper.cacheEvictCollection("Foo", "bar", 1);
	    }
    }

	/**
     * test cache Evict queries
	 * This is more of a integration test, as I don't want to turn on 2nd level cache.
     */
    public void function testCacheEvictQueries()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		sessionWrapper.cacheEvictQueries("Foo");
    }

	/**
     * test dependency inject
     */
    public void function testDependencyInject()
    {
		var beanInjector = application.coldspring.getBean("hibernate-beanInjector");
		var sessionWrapper = new coldspring.orm.hibernate.SessionWrapper(beanInjector);

		foo = sessionWrapper.new("Foo");

		assertEquals("Gandalf", foo.getInject());
    }

	/**
     * test out setting the flush mode
     */
    public void function testFlushMode()
    {
		sessionWrapper.setFlushMode("MANUAL");

		assertEquals("MANUAL", sessionWrapper.getFlushMode().toString());

		sessionWrapper.setFlushMode("COMMIT");

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());

		sessionWrapper.setFlushMode("AUTO");

		assertEquals("AUTO", sessionWrapper.getFlushMode().toString());
    }


	/**
     * test thet onMM passes through to the session well
     */
    public void function testOnMM()
    {
		var foo = new com.Foo();
		var has = sessionWrapper.contains(foo);

		assertFalse(has);

		local.foo = sessionWrapper.get("Foo", 1);

		has = sessionWrapper.contains(foo);

		assertTrue(has);

		assertFalse(sessionWrapper.isDirty());
    }

	/**
     * test dependency injection on new
     */
    public void function testNewDI()
    {
		var injector = application.coldspring.getBean("beanInjector");
		var sessionWrapper = new coldspring.orm.hibernate.SessionWrapper(injector);

		var foo = sessionWrapper.new("Foo");

		assertEquals("Gandalf", local.foo.getInject());
    }

    public void function testPersistAnnotation()
    {
    	var reflectionService = new coldspring.core.reflect.ReflectionService();

    	var class = reflectionService.loadClass("coldspring.orm.hibernate.SessionWrapper");

		for(methodName in ["delete", "insert", "merge", "save", "update"])
		{
			var method = class.getMethod(methodName);

			assertTrue(method.hasAnnotation("orm:persist"), "Could not find annotation orm:persist on #methodName#()");
			assertTrue(method.getAnnotation("orm:persist"), "Could orm:persist on #methodName#() is not true");
		}
    }

}