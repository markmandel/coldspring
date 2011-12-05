<cfcomponent hint="tests for the closure collections" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup function" access="public" returntype="void" output="false">
	<cfscript>
		var counter = 1;
		var len = 0;
		var counter2 = 1;
		var string = 0;

		strings = [];

		//build 100 of these
		for(; counter <= 100; counter++)
		{
			len = randRange (2,100);
			string = [];
			counter2 = 1;

			for(; counter2 <= len; counter2++)
			{
				arrayAppend(string, repeatString ("d",randRange (1,20)));
			}

			ArrayAppend(strings, string);
		}
    </cfscript>
</cffunction>

<cffunction name="testBasicArrayCollection" hint="test basic methods" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		local.array = [1, 2, 3, 4, 5, 6, 7,8, 9, 10];

		local.collection = createObject("component", "coldspring.util.Collection").init(local.array);

		assertEquals(10, local.collection.length());
		assertEquals(4, local.collection.get(4));

		local.collection.add(11);

		assertEquals(11, local.collection.length());

		assertEquals(11, local.collection.get(11));

		local.array2 = [1,2,3,4];

		local.collection.addAll(local.array2);

		assertEquals(15, local.collection.length());

		assertEquals(4, local.collection.get(15));
    </cfscript>
</cffunction>

<cffunction name="testBasicStructCollection" hint="test basic struct collection" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.struct = {
			foo = "bar"
			,bar = "foo"
		};

		local.collection = createObject("component", "coldspring.util.Collection").init(local.struct);

		assertEquals(2, local.collection.length());
		assertEquals("bar", local.collection.get('foo'));

		local.collection.add("stuff", "things");

		assertEquals(3, local.collection.length());
		assertEquals("things", local.collection.get('stuff'));

		local.struct2 = {
		  yes = "no"
		  ,no="yes"
		};

		local.collection.addAll(local.struct2);

		assertEquals(5, local.collection.length());
		assertEquals("things", local.collection.get('stuff'));
		assertEquals("no", local.collection.get('yes'));
    </cfscript>
</cffunction>

<cffunction name="testFindAllArray" hint="tests the findall() function of the collection" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.array = [1, 2, 3, 4, 5, 6, 7,8, 9, 10];

		local.closure = createObject("component", "coldspring.util.Closure").init(isEven);
		local.collection = createObject("component", "coldspring.util.Collection").init(local.array);

		local.expected = [2, 4, 6, 8, 10];
		local.result = local.collection.findAll(local.closure);

		assertEquals(local.expected, local.result.getCollection());
    </cfscript>
</cffunction>

<cffunction name="testFindAllStruct" hint="tests the select function of the collection" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.struct = {foo = 1, bar=2, things=3, stuff=4};

		local.closure = createObject("component", "coldspring.util.Closure").init(isEven);
		local.collection = createObject("component", "coldspring.util.Collection").init(local.struct);

		local.expected = {bar=2, stuff=4};
		local.result = local.collection.findAll(local.closure);

		assertEquals(local.expected, local.result.getCollection());
    </cfscript>
</cffunction>

<cffunction name="testStringLengthSort" hint="test the a series of strings, we want sorted by their length" access="public" returntype="void" output="false"
			mxunit:dataprovider="strings">
	<cfargument name="string" hint="an array of strings" type="array" required="Yes">
	<cfscript>
		var local = {};

		//gate the comparator
		assertEquals(1, stringLengthComparator ("hello","bye"));
		assertEquals(-1, stringLengthComparator ("hello","goodbye"));
		assertEquals(0, stringLengthComparator ("bye","bye"));

		local.sorted = createObject("component","coldspring.util.Collection").init(ArrayNew(1));
		local.sorted.setCollection(arguments.string);

		local.comparator = createObject("component","coldspring.util.Closure").init(stringLengthComparator);

		local.result = local.sorted.sort(local.comparator ).getCollection();

		assertEquals(ArrayLen(arguments.string), ArrayLen(local.result));

		local.previous = "";
    </cfscript>

	<cfloop array="#local.result#" index="local.check">
		<cfscript>
			if(Len(local.check) < Len(local.previous))
			{
				debug(local.result);
				debug(arguments.string);
				fail("'#local.check#' is greater than the previous '#local.previous#'");
			}

			local.previous = local.check;
        </cfscript>
    </cfloop>
</cffunction>

<cffunction name="testEachArray" hint="test the each method on an array" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.array = [1,2,3,4];

		local.expected = [1,2,3,4];

		local.collection = createObject("component","coldspring.util.Collection").init(local.array);
		local.closure = createObject("component", "coldspring.util.Closure" ).init(storeEach);

		local.storage = createObject("java", "java.util.ArrayList").init();
		local.closure.bind("storage", local.storage);

		local.collection.each(local.closure);

		assertEquals(local.expected, local.storage);
    </cfscript>
</cffunction>

<cffunction name="testEachStruct" hint="test the each method on an array" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.struct = {one=1, two=2, three=3, four=4};

		local.expected = [1,2,3,4];

		local.collection = createObject("component","coldspring.util.Collection").init(local.struct);
		local.closure = createObject("component", "coldspring.util.Closure" ).init(storeEach);

		local.storage = createObject("java", "java.util.ArrayList").init();
		local.closure.bind("storage", local.storage);

		local.collection.each(local.closure);

		//make sure it's in order
		arraySort(local.storage, "numeric");

		assertEquals(local.expected, local.storage);
    </cfscript>
</cffunction>

<cffunction name="testSortEmptyArray" hint="Should be able to sort an empty array" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};
		local.array = createObject("java", "java.util.ArrayList").init();

		local.collection = createObject("component","coldspring.util.Collection").init(local.array);
		local.closure = createObject("component", "coldspring.util.Closure" ).init(stringLengthComparator);

		local.sorted = local.collection.sort(local.closure);

		assertTrue(arrayIsEmpty(local.sorted.getCollection()));

		assertNotSame(local.collection, local.sorted);
		assertNotSame(local.collection.getCollection(), local.sorted.getCollection());
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="isEven" hint="if the number is even, return true" access="private" returntype="boolean" output="false">
	<cfargument name="number" hint="" type="any" required="Yes">
	<cfscript>
		if(arguments.number % 2 == 0)
		{
			return true;
		}

		return false;
    </cfscript>
</cffunction>

<cffunction name="stringLengthComparator" hint="" access="private" returntype="numeric" output="false">
	<cfargument name="str1" hint="" type="string" required="Yes">
	<cfargument name="str2" hint="" type="string" required="Yes">
	<cfscript>
		var len1 = Len(arguments.str1);
		var len2 = Len(arguments.str2);

		if(len1 > len2)
		{
			return 1;
		}
		else if(len1 < len2)
		{
			return -1;
		}

		return 0;
    </cfscript>
</cffunction>

<cffunction name="storeEach" hint="closure method, stored each of the items in an array" access="private" returntype="void" output="false">
	<cfargument name="value" hint="the value" type="any" required="Yes">
	<cfscript>
		ArrayAppend(storage, arguments.value);
    </cfscript>
</cffunction>

</cfcomponent>