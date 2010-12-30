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

<cfcomponent hint="Object with conveninece methods for sorting and ordering Ordered Objects" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="OrderComparator" output="false">
	<cfscript>
		var singleton = createObject("component", "coldspring.util.Singleton").init();

		return singleton.createInstance(getMetaData(this).name);
	</cfscript>
</cffunction>

<cffunction name="configure" hint="Configure method for static configuration" access="public" returntype="void" output="false">
	<cfscript>
		var Integer = createObject("java", "java.lang.Integer");
		var comparator = createObject("component", "coldspring.util.Closure").init(compareOrdered);

		comparator.bind("getOrder", getOrder);

		variables.instance = {};

		setComparator(comparator);

		setLowestPrecedence(Integer.MAX_VALUE);
		setHighestPrecedence(Integer.MIN_VALUE);
	</cfscript>
</cffunction>

<cffunction name="sort" hint="Sort a given array with this OrderComparator. Returns an coldspring.util.Collection with the sorted Array in it."
			access="public" returntype="coldspring.util.Collection" output="false">
	<cfargument name="array" hint="the array to sort" type="array" required="Yes">
	<cfscript>
		var collection = createObject("component", "coldspring.util.Collection").init(arguments.array);

		//if no sorting is needed, just return what we have.
		if(ArrayLen(arguments.array) <= 1)
		{
			return collection;
		}

		return collection.sort(getComparator());
    </cfscript>
</cffunction>

<cffunction name="getComparator" hint="Return a closure that can be used as a sorting Comparator for classes such as coldspring.util.Collection and coldspring.util.OrderedList." access="public" returntype="coldspring.util.Closure" output="false">
	<cfreturn instance.comparator />
</cffunction>

<cffunction name="getHighestPrecedence" hint="Useful constant for the highest precedence value.<br/>Also see java.lang.Integer.MIN_VALUE" access="public" returntype="numeric" output="false">
	<cfreturn instance.highestPrecedence />
</cffunction>

<cffunction name="getLowestPrecedence" hint="Useful constant for the lowest precedence value.<br/>Also see java.lang.Integer.MAX_VALUE" access="public" returntype="numeric" output="false">
	<cfreturn instance.lowestPrecedence />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setComparator" access="private" returntype="void" output="false">
	<cfargument name="comparator" type="coldspring.util.Closure" required="true">
	<cfset instance.comparator = arguments.comparator />
</cffunction>

<cffunction name="setHighestPrecedence" access="private" returntype="void" output="false">
	<cfargument name="highestPrecedence" type="numeric" required="true">
	<cfset instance.highestPrecedence = arguments.highestPrecedence />
</cffunction>

<cffunction name="setLowestPrecedence" access="private" returntype="void" output="false">
	<cfargument name="lowestPrecedence" type="numeric" required="true">
	<cfset instance.lowestPrecedence = arguments.lowestPrecedence />
</cffunction>

<!--- Closure Functions --->
<cffunction name="compareOrdered" hint="Closure method for comparing Ordered objects" access="private" returntype="numeric" output="false">
	<cfargument name="object1" hint="object one" type="any" required="Yes">
	<cfargument name="object2" hint="object two" type="any" required="Yes">
	<cfscript>
		if(getOrder(arguments.object1) > getOrder(arguments.object2))
		{
			return 1;
		}
		else if(getOrder(arguments.object1) < getOrder(arguments.object2))
		{
			return -1;
		}

		return 0;
    </cfscript>
</cffunction>

<cffunction name="getOrder" hint="gets the order from an object. If it implements Ordered, returns it's value, otherwise returns 0" access="private" returntype="numeric" output="false">
	<cfargument name="object" hint="the object in question" type="any" required="Yes">
	<cfscript>
		if(isInstanceOf(arguments.object,"coldspring.core.Ordered"))
		{
			return arguments.object.getOrder();
		}

		return 0;
    </cfscript>
</cffunction>

<!--- /Closure Functions --->

</cfcomponent>