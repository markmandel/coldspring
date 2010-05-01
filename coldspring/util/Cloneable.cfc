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

<cfcomponent hint="Component to aid in cloning of CFCs" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Cloneable" output="false">
	<cfscript>
		setMethodInjector(createObject("component", "MethodInjector").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="clone" hint="clone an object. If 'setInstance(struct, cloneable)' is defined locally (publically, or privately) on the object being cloned,
		it gets passed a shallow copy of variables.instance to modify as neccessary. Otherwise, the object is just duplicated."
		access="public" returntype="any" output="false">
	<cfargument name="object" hint="the object to clone" type="any" required="Yes">
	<cfscript>
		var clone = 0;

		getMethodInjector().start(arguments.object);

		getMethodInjector().injectMethod(arguments.object, __cloneObject, "public");

		clone = arguments.object.__cloneObject(this);

		getMethodInjector().removeMethod(arguments.object, "cloneObject");

		getMethodInjector().stop(arguments.object);

		return clone;
    </cfscript>
</cffunction>

<cffunction name="cloneArray" hint="Run .clone() on an array, and return the new array. Handy helper method." access="public" returntype="array" output="false">
	<cfargument name="array" hint="the array to clone all elements on" type="array" required="Yes">
	<cfscript>
		var cloneArray = [];
		var len = ArrayLen(arguments.array);
		var counter = 1;

		for(; counter lte len; counter++)
		{
			ArrayAppend(cloneArray, arguments.array[counter].clone());
		}

		return cloneArray;
	</cfscript>
</cffunction>

<cffunction name="cloneStruct" hint="Run .clone() on a struct, and return the new struct. Handy helper method." access="public" returntype="struct" output="false">
	<cfargument name="struct" hint="the struct to clone all elements on" type="struct" required="Yes">
	<cfscript>
		var cloneStruct = {};
		var key = 0;

		for(key in arguments.struct)
		{
			structInsert(cloneStruct, key, arguments.struct[key].clone());
		}

		return cloneStruct;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- mixins --->

<cffunction name="__cloneObject" hint="mixin: clone the object by copying the instance struct and passing it to the private setInstance function" access="private" returntype="any" output="false">
	<cfargument name="cloneable" hint="pass through cloneable, as it's handy" type="Cloneable" required="Yes">
	<cfscript>
		var clone = 0;
		var injector = createObject("component", "MethodInjector").init();

		if(structKeyExists(variables, "setInstance"))
		{
			clone = createObject("component", getMetadata(this).name);

			injector.start(clone);
			injector.changeMethodScope(clone, "setInstance", "public");
			injector.stop(clone);

			clone.setInstance(structCopy(variables.instance), arguments.cloneable);
		}
		else
		{
			clone = duplicate(this);
		}

		return clone;
    </cfscript>
</cffunction>

<!--- /mixins --->

<cffunction name="getMethodInjector" access="private" returntype="MethodInjector" output="false">
	<cfreturn instance.methodInjector />
</cffunction>

<cffunction name="setMethodInjector" access="private" returntype="void" output="false">
	<cfargument name="methodInjector" type="MethodInjector" required="true">
	<cfset instance.methodInjector = arguments.methodInjector />
</cffunction>

</cfcomponent>