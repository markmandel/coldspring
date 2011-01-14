<cfcomponent hint="A Collection class for the Closure library.
			<br/>This is very rudimentary for now, as it only has what is needed for CS, but will be expanded in the future (Contributions welcome!)" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Collection" output="false">
	<cfargument name="collection" hint="an existing collection - array or struct, defaults to a CF array" type="any" required="no" default="#ArrayNew(1)#">
	<cfscript>
		setCollection(arguments.collection);

		return this;
	</cfscript>
</cffunction>

<cffunction name="each" hint="The closure is called for every item in this collection, with the value passed in as an argument." access="public" returntype="void" output="false">
	<cfargument name="closure" hint="The closure that will be called against each item in this collection." type="Closure" required="Yes">
	<cfscript>
		var item = 0;
		var key = 0;
    </cfscript>

	<cfif isList()>
		<cfloop array="#getCollection()#" index="item">
			<cfset arguments.closure.call(item)>
		</cfloop>
	<cfelse>
		<cfloop collection="#getCollection()#" item="key">
			<cfscript>
				item = structFind(getCollection(), key);
				arguments.closure.call(item);
            </cfscript>
		</cfloop>
    </cfif>
</cffunction>

<cffunction name="findAll" hint="return a collection in which all the items that match the predicate are returned" access="public" returntype="Collection" output="false">
	<cfargument name="closure" hint="the closure that specifies if the item should be included. Needs to return a boolean" type="Closure" required="Yes">
	<cfscript>
		var item = 0;
		var key = 0;

		//give me a copy of exactly the same class we are using already
		var newCollection = createCollectionOfSameType();
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
					newCollection.add(key, item);
				}
            </cfscript>
		</cfloop>
	</cfif>

	<cfreturn newCollection />
</cffunction>

<cffunction name="add" hint="adds the item to the collection. if an array, expects 1 argument if a struct, expects a key, then value"
	access="public" returntype="void" output="false">
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

<cffunction name="addAll" hint="adds all the items that are passed in. expects the same collection type as what is stored, i.e. a struct/array"
			access="public" returntype="void" output="false">
	<cfargument name="collection" hint="the struct/array to add" type="any" required="Yes">
	<cfscript>
		if(isList())
		{
			getCollection().addAll(arguments.collection);
		}
		else
		{
			StructAppend(getCollection(), arguments.collection, true);
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

c<cffunction name="sort" hint="Returns a sorted Collection. Currently only works on Array Collections, structs will just return themselves. Uses QuickSort for sorting." access="public" returntype="Collection" output="false">
	<cfargument name="comparator" hint="Closure for comparing items. Will take 2 arguments, should should return less than 0 if argument1 is less than argument 2,
			return greater than 0 if the argument1 is greater than argument2 and 0 if they are the same."
			type="Closure" required="Yes">
	<cfscript>
		var sortedCollection = 0;
		var newCollection = 0;
		if(isList())
		{
			sortedCollection = quickSort(getCollection(), arguments.comparator);
			return createObject("component", "Collection").init(sortedCollection);
		}
		else
		{
			//can't sort most structs. Maybe if you want to sort a TreeMap later we'll do that.
			return this;
		}
    </cfscript>
</cffunction>

<cffunction name="setCollection" hint="Directly set the collection to an Array/Struct (or any java Map or List)" access="public" returntype="void" output="false">
	<cfargument name="collection" type="any" required="true">
	<cfscript>
		setList(isArray(arguments.collection));
		instance.collection = arguments.collection;
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="createCollectionOfSameType" hint="create a new collection, of the same type as this one" access="private" returntype="Collection" output="false">
	<cfscript>
		return createObject("component", "Collection").init(getCollection().getClass().newInstance());
    </cfscript>
</cffunction>

<!---
/**
 * Implementation of Hoare's Quicksort algorithm for sorting arrays of arbitrary items.
 * Slight mods by RCamden (added var for comparison)
 * Slight mods by MMandel (Used .addAll() to reprocess arrays, and used else/if which is faster)
 *
 * @param arrayToCompare 	 The array to be sorted.
 * @param sorter 	 The comparison UDF.
 * @return Returns a sorted array.
 * @author James Sleeman (james@innovativemedia.co.nz)
 * @version 1, March 12, 2002
 */
 --->
<cffunction name="quickSort" hint="Implementation of quicksort, with some minor modofications for speed improvement." access="private" returntype="array" output="false">
	<cfargument name="arrayToCompare" hint="The array to compare" type="array" required="Yes">
	<cfargument name="comparator" hint="Closure for comparing items. Will take 2 arguments, should should return less than 0 if argument1 is less than argument 2,
			return greater than 0 if the argument1 is greater than argument2 and 0 if they are the same."
			type="Closure" required="Yes">
	<cfscript>
		//changed, so that the List type is maintained
		var lesserArray  = arguments.arrayToCompare.getClass().newInstance();
		var greaterArray = duplicate (lesserArray);
		var pivotArray   = duplicate (lesserArray);
		var examine      = 2;
		var comparison = 0;

		pivotArray[1]    = arrayToCompare[1];

		if (arrayLen(arrayToCompare) LT 2)
		{
			return arrayToCompare;
		}

		while(examine LTE arrayLen(arrayToCompare))
		{
			comparison = arguments.comparator.call(arrayToCompare[examine], pivotArray[1]);

			if(comparison < 0)
			{
				arrayAppend(lesserArray, arrayToCompare[examine]);
			}
			else if(comparison > 0)
			{
				arrayAppend(greaterArray, arrayToCompare[examine]);
			}
			else
			{
				arrayAppend(pivotArray, arrayToCompare[examine]);
			}
			examine = examine + 1;
		}

		if (arrayLen(lesserArray)) {
			lesserArray  = quickSort(lesserArray, arguments.comparator);
		} else {
			lesserArray = arguments.arrayToCompare.getClass().newInstance();
		}

		if (arrayLen(greaterArray)) {
			greaterArray = quickSort(greaterArray, arguments.comparator);
		} else {
			greaterArray = arguments.arrayToCompare.getClass().newInstance();
		}

		lesserArray.addAll(pivotArray);
		lesserArray.addAll(greaterArray);

		return lesserArray;
	</cfscript>
</cffunction>

<cffunction name="isList" access="private" returntype="boolean" output="false">
	<cfreturn instance.isList />
</cffunction>

<cffunction name="setList" access="private" returntype="void" output="false">
	<cfargument name="isList" type="boolean" required="true">
	<cfset instance.isList = arguments.isList />
</cffunction>

</cfcomponent>