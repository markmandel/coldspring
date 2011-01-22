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
 * <p>SessionWrapper for CF9 ORM that provides extra functionality above and beyond the default.</p>
 * <p>If a BeanInjector is provided, it will be used to wire() beans on new().</p>
 * <p>This provides functionality for 'strictTransactions', in which when set to true, delete(), insert(), merge(), save(), update(), and INSERT, UPDATE and DELETE HQL statements
 * must occur within a transaction block, or an exception will be thrown. This is often useful to ensure that persistence occurs within a transaction block.</p>
 * <p>Default Flush Mode provides you with a way of setting up a different Flush Mode other than 'AUTO' as the default, if you wish.
 * See <a href="http://docs.jboss.org/hibernate/stable/core/api/org/hibernate/FlushMode.html">FlushMode</a> for more details.</p>
 * <p>The methods delete(),insert(),merge(),save() & update() have the annotation 'orm:persist="true"', for easy interception of ORM persistent events via AOP,
 * e.g. for Transaction Management</p>
 * <p>Note that multiple SessionWrappers will all work on the same underlying Hibernate Session, as that is how ColdFusion works</p>
 */
component accessors="true"
{
	/**
	 * The bean injector to use to autowire entities on new().<br/>
	 * Usually a class that extends AbstractBeanInjector.
	 */
	property name="beanInjector";

	/**
     * Whether or not to use strict Transactions
     */
	property name="strictTransactions" type="boolean";

	/**
     * The default flush mode.<br/>
	 * ALWAYS, AUTO, COMMIT, or MANUAL
     */
	property name="defaultFlushMode" type="string";

	meta = getMetaData(this);

	if(!structKeyExists(meta, "const"))
	{
		const = {};
		const.REQUEST_KEY = "sessionWrapper_";

		meta.const = const;
	}

	/*
	TODO:
		implement custom schema
	*/

	/**
     * Constructor
	 *
	 * @beanInjector the beanInjector to wire up new() created entities
	 * @strictTransactions Whether to enable strict transactions
	 * @defaultFlushMode The default flush mode, either ALWAYS, AUTO, COMMIT, or MANUAL
     */
    public SessionWrapper function init(any beanInjector, boolean strictTransactions=false, string defaultFlushMode)
    {
		configure(argumentCollection=arguments);

    	return this;
    }

	/**
     * configure function to be used when creating a Singleton with coldspring.util.Singleton
	 *
 	 * @beanInjector the beanInjector to wire up new() created entities
	 * @strictTransactions Whether to enable strict transactions
	 * @defaultFlushMode The default flush mode, either ALWAYS, AUTO, COMMIT, or MANUAL
     */
    public void function configure(any beanInjector, boolean strictTransactions=false, string defaultFlushMode)
    {
		if(structKeyExists(arguments, "beanInjector"))
		{
			setBeanInjector(arguments.beanInjector);
		}

		if(structKeyExists(arguments, "defaultFlushMode"))
		{
			setDefaultFlushMode(arguments.defaultFlushMode);
		}

		setRequestKey(meta.const.REQUEST_KEY & createUUID());

		setStrictTransactions(arguments.strictTransactions);
    }

	/**
     * Create a new instance of the entity.
	 * If a beanInjector has been provided, it will be used to wire up the dependencies on this object.
	 *
	 * @entityName the entity name of the object to create the new instance of.
     */
    public any function new(string entityName)
    {
		var object = entityNew(arguments.entityName);

		if(hasBeanInjector())
		{
			getBeanInjector().wire(object);
		}

		return object;
    }

	/**
     * Loads a single object, either by it's primary key, or by a set filter.
	 * If the object is not found, null it returned
	 *
	 * @entityname the name of the entity to be loaded
	 * @key if key is a simple value, it is matched against the primary key. If is a struct, then object is matched against the set of property names and values.
     */
    public any function get(required string entityname, required any key)
    {
		manageDefaultFlushMode();

		if(isSimpleValue(arguments.key))
		{
			return entityLoadByPK(arguments.entityname, arguments.key);
		}
		else if(isStruct(arguments.key))
		{
			return entityLoad(arguments.entityname, arguments.key, true);
		}
    }

	/**
     * Listing of a given entity. Returns an array.
	 *
	 * @entityname the name of the entity to be loaded
	 * @filtercriteria key value pairs of properties and values to match against the given entity
	 * @sortorder string to specify the property sort of order of the entitied specified.
	 * @options ignorecase,offset,maxresults,cacheable,cachename & timeout - See <a href="http://www.cfquickdocs.com/cf9/#EntityLoad">EntityLoad()</a> for details.
     */
    public array function list(required string entityname, struct filtercriteria=StructNew(), string sortorder="", options=StructNew())
    {
		manageDefaultFlushMode();

		return EntityLoad(arguments.entityname, arguments.filtercriteria, arguments.sortorder, arguments.options);
    }

	/**
     * Inserts or updates data of the object and all related objects to the database.
	 *
	 * @entity the entity to insert or update
	 *
	 * @orm:persist true
     */
    public void function save(required any entity)
    {
		manageDefaultFlushMode();

		checkStrictTransaction("save");

		entitySave(arguments.entity);
    }

	/**
     * Specifically inserts a transient object,
	 * and returns the identifier.
	 *
	 * @entity the entity to insert
	 *
	 * @orm:persist true
     */
    public any function insert(required any entity)
    {
		manageDefaultFlushMode();

		checkStrictTransaction("insert");

		return ormGetSession().save(arguments.entity);
    }

	/**
     * Specifically updates a persistent object.
	 *
	 * @entity the entity to update
	 *
	 * @orm:persist true
     */
    public any function update(required any entity)
    {
		manageDefaultFlushMode();

		checkStrictTransaction("update");

		return ormGetSession().update(arguments.entity);
    }

	/**
     * Deletes the given entity
	 *
	 * @entity the entity to delete
	 *
	 * @orm:persist true
     */
    public void function delete(required any entity)
    {
		manageDefaultFlushMode();

		checkStrictTransaction("delete");

		entityDelete(arguments.entity);
    }

	/**
     * Applies an merges the passed in entity, and returns the resultant merged persistent entity.
	 *
	 * @entity the entity to merge.
	 *
	 * @orm:persist true
     */
    public any function merge(required any entity)
    {
		manageDefaultFlushMode();

		checkStrictTransaction("merge");

		return entityMerge(arguments.entity);
    }

	/**
     * Reloads data for an entity that is already loaded.
	 *
	 * @entity the entity to reload.
     */
    public void function reload(required any entity)
    {
		manageDefaultFlushMode();

		entityReload(arguments.entity);
    }

	/**
     * execute an HQL query
	 *
	 * @hql the HQL query string
	 * @params the array/structure of parameters to apply to the HQL query
	 * @unique When true returns a single object if it exists, or null if it does not. If false, returns an array of matches.
	 * @queryOptions options of maxResults, offset, cacheable, cachename, timeout, as defined by ormExecuteQuery()
     */
    public any function executeQuery(required string hql, any params=StructNew(), boolean unique=false, struct queryOptions=StructNew())
    {
		manageDefaultFlushMode();

		if(getStrictTransactions())
		{
			var lhql = Trim(lCase(arguments.hql));
			if(lhql.startsWith("insert") || lhql.startsWith("update") || lhql.startsWith("delete"))
			{
				checkStrictTransaction("executeQuery - #listGetAt(arguments.hql, 1, ' ')#");
			}
		}

		return ormExecuteQuery(arguments.hql, arguments.params, arguments.unique, arguments.queryOptions);
    }

	/**
     * Flush the current session
     */
    public void function flush()
    {
		manageDefaultFlushMode();

		ormFlush();
    }

	/**
     * Completely clear the current request's session.
     */
    public void function clear()
    {
		manageDefaultFlushMode();

		ormClearSession();
    }

	/**
     * Close the current session
     */
    public void function close()
    {
		manageDefaultFlushMode();

		//clear out the request scope, as we will have a new session at this point
		structDelete(request, getRequestKey());

		ormCloseSession();
    }

	/**
     * Set the flush mode for this session.<br/>
	 * See: <a href="http://docs.jboss.org/hibernate/stable/core/api/org/hibernate/Session.html#setFlushMode(org.hibernate.FlushMode)">Hibernate FlushMode</a> for more details.
	 *
	 * @flushMode the flush mode: ALWAYS,AUTO,COMMIT, or MANUAL
     */
    public void function setFlushMode(required string flushMode)
    {
		var mode = createObject("java", "org.hibernate.FlushMode");

		ormGetSession().setFlushMode(mode[arguments.flushMode]);

		//this overwrites the default flush mode.
		request[getRequestKey()] = 1;
    }

	/**
     * Evict an entity from the 2nd level cache.
	 *
	 * @entityName the name of the entity to evict.
	 * @key optional primary key value. If not provided, all entities with the given name will be evicted.
     */
    public void function cacheEvictEntity(required string entityName, any key)
    {
		if(structKeyExists(arguments, "key"))
		{
			ormEvictEntity(arguments.entityName, arguments.key);
		}
		else
		{
			ormEvictEntity(arguments.entityName);
		}
    }

	/**
     * Evict the collection of an entity from the 2nd level cache
	 *
	 * @entityName the name of the entity, whose collection to evict.
	 * @collectionName the name of the collection to evict
	 * @key optional primary key value. If not provided, all collections for the given entities with the given name will be evicted.
	 *
     */
    public void function cacheEvictCollection(required string entityName, required string collectionName, any key)
    {
		if(structKeyExists(arguments, "key"))
		{
			ormEvictCollection(arguments.entityName, arguments.collectionName, arguments.key);
		}
		else
		{
			ormEvictCollection(arguments.entityName, arguments.collectionName);
		}
    }

	/**
     * Evict cached queries from the 2nd level cache
	 *
	 * @cacheName optional cachename for the queries to evict. If non provided, all queries will be evicted.
     */
    public void function cacheEvictQueries(string cacheName)
    {
		if(structKeyExists(arguments, "cacheName"))
		{
			ormEvictQueries(arguments.cacheName);
		}
		else
		{
			ormEvictQueries();
		}
    }

	/**
     * Returns the request's hibernate session object
     */
    public any function getORMSession()
    {
		manageDefaultFlushMode();

		return ormGetSession();
    }

	/**
     * Get the underlying session factory for this request's session
     */
    public any function getSessionFactory()
    {
		manageDefaultFlushMode();

		return ormGetSessionFactory();
    }

	/**
     * Checks to see if strict transactions are on, and throws an exception if it is an a transaciotn is not currently active
	 *
	 * @methodName the name of the invoking method
     */
    private void function checkStrictTransaction(required string methodName)
    {
		if(getStrictTransactions())
		{
			/*
				Wish we didn't have to do it this way, but no better way.
				I would save the instance of TransactionTag, but if on a locked down shared host, any creation
				of this would make the whole sessionWrapper fail.
			*/
			var transactionTag = createObject("java", "coldfusion.tagext.sql.TransactionTag").getCurrent();

			var inHibernateTransaction = !isNull(ormGetSession().getTransaction()) AND ormGetSession().getTransaction().isActive();
			var inJDBCTranasction = !isNull(transactionTag);

			if(!(inHibernateTransaction OR inJDBCTranasction))
			{
				new coldspring.orm.hibernate.exception.StrictTransactionException(arguments.methodName);
			}
		}
    }

	/**
     * Tracks if the default flush mode has yet to be set, and if not, sets it.
     */
    private void function manageDefaultFlushMode()
    {
		if(hasDefaultFlushMode())
		{
			if(!structKeyExists(request, getRequestKey()))
			{
				setFlushMode(getDefaultFlushMode());
				request[getRequestKey()] = 1;
			}
		}
    }


	/**
     * When a method is not found, it is called on the underlying request's session.<br/>
	 * This is an easy way to expose the extra functionality of the underlying Session.<br/>
	 * See: <a href="http://docs.jboss.org/hibernate/stable/core/api/org/hibernate/Session.html">http://docs.jboss.org/hibernate/stable/core/api/org/hibernate/Session.html</a> for more details.
     *
     * @missingMethodName the missing method name
     * @missingMethodArguments the missing method arguments
     */
    public any function onMissingMethod(required string missingMethodName, required struct missingMethodArguments)
    {
		manageDefaultFlushMode();

		//build the argument list string (cache this?)
		var args = [];
		for(var counter = 1; counter <= structCount(arguments.missingMethodArguments); counter++)
		{
			ArrayAppend(args, "arguments.missingMethodArguments[#counter#]");
		}

		//do this first, as it works around 'contains' keyword issue on CF9.
		var sess = ormGetSession();
		return evaluate("sess.#arguments.missingMethodName#(#arrayToList(args)#)");
    }

	/**
     * whether this object has a beanInjector
     */
    public boolean function hasBeanInjector()
    {
		return StructKeyExists(variables, "beanInjector");
    }

	/**
     * Whether this object has a default FlushMode
     */
    public boolean function hasDefaultFlushMode()
    {
    	return StructKeyExists(variables, "defaultFlushMode");
    }

	private string function getRequestKey()
    {
    	return variables.requestKey;
    }

    private void function setRequestKey(required string requestKey)
    {
    	variables.requestKey = arguments.requestKey;
    }


}