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

<cfcomponent hint="test for making sure Ordered is as it should be." extends="unittests.AbstractTestCase" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setup" hint="setup method" access="public" returntype="void" output="false">
	<cfscript>
		comparator = createObject("component", "coldspring.core.OrderComparator").init();
    </cfscript>
</cffunction>

<cffunction name="testHighestLowestNone" hint="tests highest vs lowest, vs not ordered" access="public" returntype="void" output="false">
	<cfscript>
		var lowest = createObject("component", "com.Ordered").init(comparator.getLowestPrecedence());
		var highest = createObject("component", "com.Ordered").init(comparator.getHighestPrecedence());
		var none = createObject("component", "com.NonOrdered").init();

		var array = [none, highest, lowest];
		var expected = [highest, none, lowest];

		assertEquals(expected, comparator.sort(array).getCollection());
    </cfscript>
</cffunction>

<cffunction name="testNumericValues" hint="tests some numeric values" access="public" returntype="void" output="false">
	<cfscript>
		var negativeOne = createObject("component", "com.Ordered").init(-1);
		var seven = createObject("component", "com.Ordered").init(7);
		var twentyThree = createObject("component", "com.Ordered").init(23);
		var seventeen = createObject("component", "com.Ordered").init(17);

		var array = [seventeen, twentyThree, negativeOne, seven];
		var expected = [negativeOne, seven, seventeen, twentyThree];

		assertEquals(expected, comparator.sort(array).getCollection());
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>