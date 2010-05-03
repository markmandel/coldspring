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

<cfcomponent hint="An abstract test case for default setup, teardown, and util methods" extends="mxunit.framework.TestCase" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="assertArrayEqualsNonOrdered" hint="Assert that the two arrays are the same, but they don't have to be in the same order" access="private" returntype="void" output="false">
	<cfargument name="arr1" hint="array1" type="array" required="Yes">
	<cfargument name="arr2" hint="array2" type="array" required="Yes">
	<cfscript>
		var local = {};
		local.len1 = ArrayLen(arguments.arr1);
		local.len2 = arraylen(arguments.arr2);
		if(local.len1 neq local.len2)
		{
			fail("Arrays are not equals - Array 1 has #local.len1# items, while array 2 has #local.len2# items");
		}

        for(local.counter=1; local.counter lte local.len1; local.counter++)
        {
        	local.item = arguments.arr1[local.counter];

			if(!arguments.arr2.contains(local.item))
			{
				fail("Array 2 does not have #toString(local.item)#");
			}
        }
    </cfscript>
</cffunction>

<cffunction name="_trace" access="private">
	<cfargument name="s">
	<cfset var g = "">
	<cfsetting showdebugoutput="true">
	<cfsavecontent variable="g">
		<cfdump var="#arguments.s#">
	</cfsavecontent>
	<cftrace text="#g#">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->



</cfcomponent>