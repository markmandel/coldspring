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
<cfcomponent hint="Component that uses meta data to store and manage singletons of objects" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Singleton" output="false">
	<cfscript>
		//get a little sneaky, and remove the init
		var singleton = createObject("component", "Singleton");

		return singleton.createInstance(getMetaData(this).name);
	</cfscript>
</cffunction>

<cffunction name="createInstance" hint="create a singleton instance of an object, or if already created, return the already existing object" access="public" returntype="any" output="false">
	<cfargument name="class" hint="the class name of the CFC to create" type="string" required="Yes">
	<cfargument name="args" hint="the arguments to pass to an optional 'configures' method that configures the static instance" type="struct" required="No" default="#StructNew()#">
	<cfargument name="key" hint="The key to use on the 'singleton' struct that will be created on the metadata for the given cfc.<br/>Defaults to 'instance'."
				type="string" required="No" default="instance">
	<cfscript>
		var meta = getComponentMetadata(arguments.class);
		var instance = 0;
    </cfscript>
	<cfif NOT StructKeyExists(meta, "singleton")>
    	<cflock name="coldspring.util.Singleton.singleton.#arguments.class#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(NOT StructKeyExists(meta, "singleton"))
    		{
				meta.singleton = {};
    		}
    	</cfscript>
    	</cflock>
    </cfif>
	<cfif NOT StructKeyExists(meta.singleton, arguments.key)>
    	<cflock name="coldspring.util.Singleton.#arguments.key#.#arguments.class#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(NOT StructKeyExists(meta.singleton, arguments.key))
    		{
				instance = createObject("component", arguments.class);

				if(StructKeyExists(instance, "configure"))
				{
					instance.configure(argumentCollection=args);
				}

				meta.singleton[arguments.key] = instance;
    		}
    	</cfscript>
    	</cflock>
    </cfif>

	<cfreturn meta.singleton[arguments.key] />

</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>