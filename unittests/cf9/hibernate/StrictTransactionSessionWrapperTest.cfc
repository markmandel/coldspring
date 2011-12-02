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

component extends="unittests.AbstractTestCase"
{
	/**
     * setup
     */
    public void function setup()
    {
		super.setup();
		ormReload();
		sessionWrapper = new coldspring.orm.hibernate.SessionWrapper(strictTransactions=true);
    }

	public void function teardown()
	{
		super.teardown();
		ormClearSession();
	}

	/**
     * test delete
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailDelete()
    {
		local.result = sessionWrapper.list("Foo");
		sessionWrapper.delete(local.result);
    }

	/**
     * test save
	 *
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailSave()
    {

		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		sessionWrapper.save(local.result);
    }

	/**
     * test update
 	 *
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailUpdate()
    {
		local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		sessionWrapper.update(local.result);
    }

	/**
     * test merge
	 *
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailMerge()
    {
	    local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

		local.result.setName("Mark Mandel");

		local.merge = sessionWrapper.merge(local.result);
    }

	/**
     * test insert
	 *
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailInsert()
    {
		local.result = sessionWrapper.new("Foo");

		local.result.setName("Mark Mandel");

		sessionWrapper.insert(local.result);
	}

	/**
     * test failing update HQL
	 *
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailUpdateHQL()
    {
		sessionWrapper.executeQuery("update Foo f set f.name = :name", {name = "Peter Parker"});
    }

	/**
     * test update HQL
     */
    public void function testUpdateHQL()
    {
		transaction
		{

			sessionWrapper.executeQuery("update Foo f set f.name = :name", {name = "Peter Parker"});

			local.result = sessionWrapper.list("Foo");

			assertEquals("Peter Parker", local.result[1].getName());

			transactionRollback();
		}
    }

	/**
     * test failing insert HQL
	 *
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailInsertHQL()
    {
		sessionWrapper.executeQuery("insert into Foo (name) select f.name from Foo f");
    }

	/**
     * test insert HQL
	 *
     */
    public void function testInsertHQL()
    {
		transaction
		{

			sessionWrapper.executeQuery("insert into Foo (name) select f.name from Foo f");

			local.result = sessionWrapper.list("Foo");

			assertEquals(6, ArrayLen(local.result));
			transactionRollback();
		}
    }

	/**
     * test failing delete HQL
	 *
	 * @mxunit:expectedException coldspring.orm.hibernate.exception.StrictTransactionException
     */
    public void function testFailDeleteHQL()
    {
		sessionWrapper.executeQuery("delete Foo f");
    }

	/**
     * test delete HQL
     */
    public void function testDeleteHQL()
    {
		transaction
		{
			sessionWrapper.executeQuery("delete Foo f");

			local.result = sessionWrapper.list("Foo");

			assertEquals(0, ArrayLen(local.result));

			transactionRollback();
		}

    }

	/**
     * test delete
     */
    public void function testDelete()
    {
		transaction
		{
			local.result = sessionWrapper.list("Foo");

			assertEquals(3, Arraylen(local.result));

			local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

			sessionWrapper.delete(local.result);

			ormFlush();

			local.result = sessionWrapper.list("Foo");

			assertEquals(2, Arraylen(local.result));

			transactionRollback();
		}
    }

	/**
     * test save
     */
    public void function testSave()
    {
		transaction
		{
			local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

			local.result.setName("Mark Mandel");

			sessionWrapper.save(local.result);

			ormFlush();
			ormClearSession();

			local.result = sessionWrapper.get("Foo", {name= "Mark Mandel"});

			assertEquals("Mark Mandel", local.result.getName());

			transactionRollback();
		}
    }

	/**
     * test update
     */
    public void function testUpdate()
    {
		transaction
		{
			local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

			local.result.setName("Mark Mandel");

			sessionWrapper.update(local.result);

			ormFlush();
			ormClearSession();

			local.result = sessionWrapper.get("Foo", {name= "Mark Mandel"});

			assertEquals("Mark Mandel", local.result.getName());

			transactionRollback();
		}
    }

	/**
     * test merge
     */
    public void function testMerge()
    {
		transaction
		{
			local.result = sessionWrapper.get("Foo", {name= "Darth Vader"});

			local.result.setName("Mark Mandel");

			local.merge = sessionWrapper.merge(local.result);

			ormFlush();
			ormClearSession();

			local.result = sessionWrapper.get("Foo", {name= "Mark Mandel"});

			assertEquals("Mark Mandel", local.result.getName());

			transactionRollback();
		}
    }

	/**
     * test insert
     */
    public void function testInsert()
    {
		transaction
		{
			local.result = sessionWrapper.new("Foo");

			local.result.setName("Mark Mandel");

			sessionWrapper.insert(local.result);

			ormFlush();
			ormClearSession();

			local.result = sessionWrapper.list("Foo");

			assertEquals(4, Arraylen(local.result));

			transactionRollback();
		}
	}

}