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

<cfcomponent hint="Implementation of Observable Pattern. Could be used as an implementation or as an base class" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Observable" output="false">
	<cfscript>
		setCollection(createObject("java", "java.util.ArrayList").init());
		setSystem(createObject("java", "java.lang.System"));

		return this;
	</cfscript>
</cffunction>

<cffunction name="addObserver" hint="Adds an observer" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to be added" type="any" required="Yes">

	<cflock name="coldspring.util.Observer.#getSystem().identityHashCode(this)#" type="exclusive" timeout="60">
		<cfset arrayAppend(getCollection(), arguments.observer)>
	</cflock>
</cffunction>

<cffunction name="removeObserver" hint="Removes an observer from the collection" access="public" returntype="void" output="false">
	<cfargument name="observer" hint="The observer to be removed (may be the soft reference)" type="any" required="Yes">
	<cfscript>
		var iterator = 0;
		var iObserver = 0;
    </cfscript>
	<!--- we do this because CFC's hashCode() implementation is fubar --->
	<cflock name="coldspring.util.Observer.#getSystem().identityHashCode(this)#" type="exclusive" timeout="60">
		<cfscript>
			iterator = getCollection().iterator();

			while(iterator.hasNext())
			{
				iObserver = iterator.next();

				if(getSystem().identityHashCode(iObserver) eq getSystem().identityHashCode(arguments.observer))
				{
					iterator.remove();
					return;
				}
			}
        </cfscript>
	</cflock>
</cffunction>

<cffunction	name="onMissingMethod" access="public" returntype="any" output="false" hint="calling this method calls the same method on all the observers">
	<cfargument	name="missingMethodName" type="string"	required="true"	hint=""	/>
	<cfargument	name="missingMethodArguments" type="struct" required="true"	hint=""/>
	<cfscript>
		var collection = 0;
		var observer = 0;
		var local = {};
    </cfscript>
	<cflock name="coldspring.util.Observer.#getSystem().identityHashCode(this)#" type="readonly" timeout="60">
		<cfset collection = getCollection()>
		<cfloop array="#collection#" index="observer">
			<cfinvoke component="#observer#" method="#arguments.missingMethodName#" argumentcollection="#missingMethodArguments#" returnvariable="local.return">
		</cfloop>
	</cflock>
	<cfscript>
		if(structKeyExists(local, "return"))
		{
			return local.return;
		}
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="removeOnMissingMethod" hint="If you are extending this Observable,
			this convenience method is hear to make it easier to clear off the onMM implementation, so you can write your own observer notification
			implementation" access="private" returntype="void" output="false">
	<cfscript>
		structDelete(variables, "onMissingMethod");
		structDelete(this, "onMissingMethod");
    </cfscript>
</cffunction>

<cffunction name="getCollection" access="private" returntype="any" output="false">
	<cfreturn instance.Collection />
</cffunction>

<cffunction name="setCollection" access="private" returntype="void" output="false">
	<cfargument name="Collection" type="any" required="true">
	<cfset instance.Collection = arguments.Collection />
</cffunction>

<cffunction name="getSystem" access="private" returntype="any" output="false">
	<cfreturn instance.System />
</cffunction>

<cffunction name="setSystem" access="private" returntype="void" output="false">
	<cfargument name="System" type="any" required="true">
	<cfset instance.System = arguments.System />
</cffunction>

</cfcomponent>