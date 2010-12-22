<!---
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
 --->

<cfcomponent hint="A sorted array test" extends="unittests.AbstractTestCase" output="false">

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

<cffunction name="testStringLengthSort" hint="test the a series of strings, we want sorted by their length" access="public" returntype="void" output="false"
			mxunit:dataprovider="strings">
	<cfargument name="string" hint="an array of strings" type="array" required="Yes">
	<cfscript>
		var local = {};

		//gate the comparator
		assertEquals(1, stringLengthComparator ("hello","bye"));
		assertEquals(-1, stringLengthComparator ("hello","goodbye"));
		assertEquals(0, stringLengthComparator ("bye","bye"));

		local.sorted = createObject("component","coldspring.util.SortedArray").init(stringLengthComparator);

		//debug(arguments.string);
    </cfscript>

    <cfloop array="#arguments.string#" index="local.item">
		<cfscript>
			local.sorted.add(local.item);

			local.result = local.sorted.getSortedArray();
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
    </cfloop>

	<!---<cfset debug(local.result)>--->
    <cfset assertEquals(ArrayLen(arguments.string), ArrayLen(local.result))>

</cffunction>

<cffunction name="testClosureComparator" hint="do a simple test with a Closure" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.string = ["aaa", "b", "cccc", "dddddd", "ee"];
		local.expected = ["b", "ee", "aaa", "cccc", "dddddd"];

		local.closure = createObject("component", "coldspring.util.Closure").init(stringLengthComparator);
		local.sorted = createObject("component","coldspring.util.SortedArray").init(local.closure);

	</cfscript>
	<cfloop array="#local.string#" index="local.item">
		<cfscript>
			local.sorted.add(local.item);
        </cfscript>
	</cfloop>

	<cfscript>
		assertEquals(local.expected, local.sorted.getSortedArray());
    </cfscript>
</cffunction>

<cffunction name="testRemove" hint="test remove a value" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.string = ["aaa", "b", "cccc", "dddddd", "ee"];
		local.expected = ["b", "ee", "cccc", "dddddd"];

		local.closure = createObject("component", "coldspring.util.Closure").init(stringLengthComparator);
		local.sorted = createObject("component","coldspring.util.SortedArray").init(local.closure);

	</cfscript>
	<cfloop array="#local.string#" index="local.item">
		<cfscript>
			local.sorted.add(local.item);
        </cfscript>
	</cfloop>

	<cfscript>
		AssertTrue(local.sorted.remove("aaa"));

		assertEquals(local.expected, local.sorted.getSortedArray());
    </cfscript>
</cffunction>

<cffunction name="testRemoveAt" hint="test remove a value" access="public" returntype="void" output="false">
	<cfscript>
		var local = {};

		local.string = ["aaa", "b", "cccc", "dddddd", "ee"];
		local.expected = ["b", "ee", "cccc", "dddddd"];

		local.closure = createObject("component", "coldspring.util.Closure").init(stringLengthComparator);
		local.sorted = createObject("component","coldspring.util.SortedArray").init(local.closure);
	</cfscript>

	<cfloop array="#local.string#" index="local.item">
		<cfscript>
			local.sorted.add(local.item);
        </cfscript>
	</cfloop>

	<cfscript>
		assertTrue(local.sorted.removeAt(3));

		assertEquals(local.expected, local.sorted.getSortedArray());
    </cfscript>
</cffunction>


<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

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