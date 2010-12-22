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

<cfcomponent hint="An implementation of an array that takes a Closure/UDF to define the comparator.
			<br/>This is backed by a java.util.ArrayList and manipulation operations are locked accordingly.<br/>
			Either a UDF or a Closure can be used as a comparator.
			The UDF/Closure will be passed 2 arguments. It should return less than 0 if argument1 is less than argument 2,
			return greater than 0 if the argument1 is greater than argument2 and 0 if they are the same.<br/>
			This has been implemented using a Binary Search algorithm to determine the right placement for new items in the array.
			" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="SortedArray" output="false">
	<cfargument name="comparator" hint="a UDF or a Closure to be used as a comparator." type="any" required="Yes">
	<cfscript>
		var System = createObject("java","java.lang.System");
		var closure = 0;

		setLockName(getMetadata(this).name & ".array." & System.identityHashcode(this));
		setSortedArray (createObject("java", "java.util.ArrayList").init());

		if(isCustomFunction(arguments.comparator))
		{
			closure = createObject("component","Closure").init(arguments.comparator);
			setComparator(closure);
		}
		else
		{
			setComparator(arguments.comparator);
		}

		return this;
	</cfscript>
</cffunction>

<cffunction name="add" hint="add an item to the array to be added in the sorted position." access="public" returntype="void" output="false">
	<cfargument name="value" hint="the value to be added to the array" type="any" required="Yes">
	<cfscript>
		var array = 0;
		var low = 1;
		var high = 0;
		var mid = 0;
		var comparator = getComparator();
		var result = 0;
    </cfscript>
	<cflock timeout="30" name="#getLockName()#" type="exclusive">
		<cfscript>
			array = getSortedArray();
			high = ArrayLen(array);

			if(high < low)
			{
				arrayAppend(array, arguments.value);
			}
			else
			{
				do
				{
					mid = Round((low + high) / 2);

					result = comparator.call(array[mid], arguments.value);

					if(result < 0)
					{
						low = mid + 1;
					}
					else if(result > 0)
					{
						high = mid - 1;
					}
					else
					{
						arrayInsertAt(array, mid, arguments.value);
						return;
					}
				}
				while(low <= high);


				if(low > ArrayLen(array))
				{
					ArrayAppend(array, arguments.value);
				}
				else
				{
					//this is the right spot
					arrayInsertAt(array, low, arguments.value);
				}
			}
	    </cfscript>
    </cflock>
</cffunction>

<cffunction name="remove" hint="remove an object from the array. Returns true if the item was found and removed" access="public" returntype="boolean" output="false">
	<cfargument name="value" hint="the value to remove" type="any" required="Yes">
	<cflock timeout="30" name="#getLockName()#" type="exclusive">
		<cfscript>
			//Do it natively, as CF8 doesn't have ArrayDelete.
			//return arrayDelete(getSortedArray(), arguments.value);
			return getSortedArray().remove(arguments.value);
        </cfscript>
</cflock>
</cffunction>

<cffunction name="removeAt" hint="remove an object at a specific index from the array. Returns true if the item was found and removed" access="public" returntype="boolean" output="false">
	<cfargument name="index" hint="the index of the item to remove" type="numeric" required="Yes">
	<cflock timeout="30" name="#getLockName()#" type="exclusive">
		<cfscript>
			return arrayDeleteAt(getSortedArray(), arguments.index);
        </cfscript>
	</cflock>
</cffunction>

<cffunction name="getSortedArray" access="public" returntype="array" hint="Returns the underlying array. Do not add/remove directly." output="false">
	<cflock timeout="30" name="#getLockName()#" type="readonly">
		<cfreturn instance.sortedArray />
	</cflock>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setSortedArray" access="private" returntype="void" output="false">
	<cfargument name="sortedArray" type="array" required="true">
	<cfset instance.sortedArray = arguments.sortedArray />
</cffunction>

<cffunction name="getLockName" access="private" returntype="string" output="false">
	<cfreturn instance.lockName />
</cffunction>

<cffunction name="setLockName" access="private" returntype="void" output="false">
	<cfargument name="lockName" type="string" required="true">
	<cfset instance.lockName = arguments.lockName />
</cffunction>

<cffunction name="getComparator" access="private" returntype="coldspring.util.Closure" output="false">
	<cfreturn instance.comparator />
</cffunction>

<cffunction name="setComparator" access="private" returntype="void" output="false">
	<cfargument name="comparator" type="coldspring.util.Closure" required="true">
	<cfset instance.comparator = arguments.comparator />
</cffunction>

</cfcomponent>

