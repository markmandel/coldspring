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

<cffunction name="testBasicCollection" hint="test basic methods" access="public" returntype="any" output="false">
	<cfscript>
		var local = {};

		local.array = [1, 2, 3, 4, 5, 6, 7,8, 9, 10];

		local.collection = createObject("component", "coldspring.util.Collection").init(local.array);

		assertEquals(10, local.collection.length());
		assertEquals(4, local.collection.get(4));

		local.collection.add(11);

		assertEquals(11, local.collection.length());

		assertEquals(11, local.collection.get(11));
    </cfscript>
</cffunction>

<cffunction name="testSelect" hint="tests the select function of the collection" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.array = [1, 2, 3, 4, 5, 6, 7,8, 9, 10];

		local.closure = createObject("component", "coldspring.util.Closure").init(isEven);
		local.collection = createObject("component", "coldspring.util.Collection").init(local.array);

		local.expected = [2, 4, 6, 8, 10];
		local.result = local.collection.select(local.closure);

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

</cfcomponent>