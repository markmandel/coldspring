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
		sessionWrapper = new coldspring.orm.hibernate.SessionWrapper(defaultFlushMode="COMMIT");
    }

	/**
     * test GetORMGetSession
     */
    public void function testGetORMGetSession()
    {
		sessionWrapper.getORMSession();

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test ORMGetSession factory
     */
    public void function testGetORMGetSessionFactory()
    {
		sessionWrapper.getSessionFactory();

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * sees if get works
     */
    public void function testGet()
    {
		local.foo = sessionWrapper.get("Foo", 1);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test basic list
     */
    public void function testBasicList()
    {
		local.result = sessionWrapper.list("Foo");

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test delete
     */
    public void function testDelete()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		sessionWrapper.delete(local.result);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test save
     */
    public void function testSave()
    {

		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		sessionWrapper.save(local.result);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test update
     */
    public void function testUpdate()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		sessionWrapper.update(local.result);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test merge
     */
    public void function testMerge()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		local.merge = sessionWrapper.merge(local.result);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test insert
     */
    public void function testInsert()
    {
		local.result = sessionWrapper.new("Foo");

		local.result.setName("Mark Mandel");

		sessionWrapper.insert(local.result);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
	}

	/**
     * test Clear
     */
    public void function testClear()
    {
		sessionWrapper.clear();

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test reload
     */
    public void function testReload()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		var query = new Query(sql="update Foo set name='Clark Kent' where id = :id");
		query.addParam(name="id", value=local.result.getID(), cfsqltype="integer");
		query.execute();

		sessionWrapper.reload(local.result);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());

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

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test close
     */
    public void function testClose()
    {
		sessionWrapper.close();

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test basic HQL
     */
    public void function testBasicHQL()
    {
		local.result = sessionWrapper.executeQuery("from Foo");

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * testCacheEvictEntity
	 * This is more of a integration test, as I don't want to turn on 2nd level cache.
     */
    public void function testCacheEvictEntity()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		sessionWrapper.cacheEvictEntity("Foo");

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
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

	        assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
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

	    assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test out setting the flush mode
     */
    public void function testOverwriteFlushMode()
    {
		sessionWrapper.setFlushMode("MANUAL");

		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		assertEquals("MANUAL", sessionWrapper.getFlushMode().toString());
    }

	/**
     * test thet onMM passes through to the session well
     */
    public void function testOnMM()
    {
		var foo = new com.Foo();
		var has = sessionWrapper.contains(foo);

		assertEquals("COMMIT", sessionWrapper.getFlushMode().toString());
    }
}