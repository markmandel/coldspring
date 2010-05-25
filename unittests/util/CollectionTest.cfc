<cfcomponent hint="tests for the closure collections" extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->


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

</cfcomponent>