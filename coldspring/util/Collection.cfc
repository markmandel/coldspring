<cfcomponent hint="A Collection class for the Closure library.
			<br/>This is very rudimentary for now, as it only has what is needed for CS, but will be expanded in the future (Contributions welcome!)" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Collection" output="false">
	<cfargument name="collection" hint="an existing collection - array or struct, defaults to a CF array" type="any" required="no" default="#ArrayNew(1)#">
	<cfscript>
		setCollection(arguments.collection);
		setList(isArray(arguments.collection));

		return this;
	</cfscript>
</cffunction>

<cffunction name="select" hint="return a collection in which all the items that match the predicate are returned" access="public" returntype="Collection" output="false">
	<cfargument name="closure" hint="the closure that specifies if the item should be included. Needs to return a boolean" type="Closure" required="Yes">
	<cfscript>
		var item = 0;
		var key = 0;

		//give me a copy of exactly the same class we are using already
		var newCollection = createObject("component", "Collection").init(getCollection().getClass().newInstance());
    </cfscript>

	<cfif isList()>
		<cfloop array="#getCollection()#" index="item">
			<cfscript>
				if(arguments.closure.call(item))
				{
					newCollection.add(item);
				}
            </cfscript>
		</cfloop>
	<cfelse>
		<cfloop collection="#getCollection()#" item="key">
			<cfscript>
				item = structFind(getCollection(), key);
				if(arguments.closure.call(item))
				{
					add(key, item);
				}
            </cfscript>
		</cfloop>
	</cfif>

	<cfreturn newCollection />
</cffunction>

<cffunction name="add" hint="adds the item to the collection. if an array, expects 1 argument, if a struct, expects a key, then value" access="public" returntype="void" output="false">
	<cfscript>
		if(isList())
		{
			arrayAppend(getCollection(), arguments[1]);
		}
		else
		{
			//may be a java collection, so use put
			getCollection().put(arguments[1], arguments[2]);
		}
    </cfscript>
</cffunction>

<cffunction name="getCollection" hint="returns the underlying collection" access="public" returntype="any" output="false">
	<cfreturn instance.collection />
</cffunction>

<cffunction name="get" hint="get an item from the collection" access="public" returntype="any" output="false">
	<cfargument name="key" hint="the key or numerical index" type="any" required="Yes">
	<cfscript>
		if(isList())
		{
			return getCollection().get(arguments.key - 1);
		}

		return getCollection().get(arguments.key);
    </cfscript>
</cffunction>

<cffunction name="length" hint="get the length of this collection" access="public" returntype="numeric" output="false">
	<cfscript>
		if(isList())
		{
			return arraylen(getCollection());
		}
		else
		{
			return structCount(getCollection());
		}
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCollection" access="private" returntype="void" output="false">
	<cfargument name="collection" type="any" required="true">
	<cfset instance.collection = arguments.collection />
</cffunction>

<cffunction name="isList" access="private" returntype="boolean" output="false">
	<cfreturn instance.isList />
</cffunction>

<cffunction name="setList" access="private" returntype="void" output="false">
	<cfargument name="isList" type="boolean" required="true">
	<cfset instance.isList = arguments.isList />
</cffunction>

</cfcomponent>