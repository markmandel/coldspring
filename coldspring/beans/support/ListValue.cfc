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

<cfcomponent hint="An array of abstractValues, use getValue() to modify. Uses an ArrayList, so it will pass by reference"
			 extends="AbstractValue" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ListValue" output="false">
	<cfscript>
		//using an ArrayList, as they pass by reference, are _fast_ and we don't need thread safety here
		setValueArray(createObject("java", "java.util.ArrayList").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="addValue" hint="add a value to this array" access="public" returntype="void" output="false">
	<cfargument name="value" hint="the abstractValue to add to the list" type="AbstractValue" required="Yes">
	<cfscript>
		arrayAppend(getValueArray(), arguments.value);
    </cfscript>
</cffunction>

<cffunction name="getValue" hint="A new instance of the array (list)" access="public" returntype="array" output="false">
	<cfscript>
		var array = [];
		var value = 0;
		var valueArray = getValueArray();
		var counter = 1;
		var len = arraylen(valueArray);

		for(; counter lte len; counter++)
		{
			array[counter] = valueArray[counter].getValue();
		}

		return array;
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		arguments.instance.valueArray = arguments.cloneable.cloneArray(arguments.instance.valueArray, "java.util.ArrayList");

		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<cffunction name="getValueArray" access="private" returntype="array" output="false"	colddoc:generic="AbstractValue">
	<cfreturn instance.valueArray />
</cffunction>

<cffunction name="setValueArray" access="private" returntype="void" output="false">
	<cfargument name="valueArray" type="array" required="true" colddoc:generic="AbstractValue">
	<cfset instance.valueArray = arguments.valueArray />
</cffunction>

</cfcomponent>