<!---
   Copyright 2011 Mark Mandel
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

<cfcomponent hint="Service for managing all reflection and class metadata objects" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor - returns singleton" access="public" returntype="ReflectionService" output="false">
	<cfscript>
		var singleton = createObject("component", "coldspring.util.Singleton").init();

		return singleton.createInstance(getMetaData(this).name);
	</cfscript>
</cffunction>

<cffunction name="configure" hint="singleton configuration method" access="public" returntype="void" output="false">
	<cfscript>
		clearCache();
	</cfscript>
</cffunction>

<cffunction name="loadClass" hint="Returns the class with the given name" access="public" returntype="Class" output="false">
	<cfargument name="className" hint="the name of the class to load" type="string" required="Yes"/>
	<cfscript>
	   var local = {};
	   local.cache = getClassCache();
    </cfscript>

	<cflock name="coldspring.core.reflect.ReflectionService" type="readonly" timeout="60">

		<cfif NOT StructKeyExists(local.cache, arguments.className)>
			<cflock name="ReflectionService.loadClass.#arguments.className#" throwontimeout="true" timeout="60">
				<cfscript>
					if(NOT StructKeyExists(local.cache, arguments.className))
					{
						local.class = createObject("component", "Class").init(arguments.className);
						local.cache[arguments.className] = local.class;
					}
				</cfscript>
			</cflock>
		</cfif>
		<cfreturn local.cache[arguments.className]/>

	</cflock>
</cffunction>

<cffunction name="clearCache" hint="clears the class cache. Very important to run on the init of ColdSpring, or generally after a class meta data change, so the changes are picked up."
			access="public" returntype="void" output="false">
	<cflock name="coldspring.core.reflect.ReflectionService" type="exclusive" timeout="60">
		<cfscript>
			setClassCache(structNew());
	    </cfscript>
    </cflock>
</cffunction>

<cffunction name="isPrimitive" hint="is the type a primitive value?" access="private" returntype="boolean" output="false">
	<cfargument name="type" hint="the cf type" type="string" required="Yes">
	<cfscript>
		var primitives = "string,date,struct,array,void,binary,numeric,boolean,query,xml,uuid,any,component";
		return ListFindNoCase(primitives, arguments.type);
    </cfscript>
</cffunction>

<cffunction name="resolveClassName" hint="resolves a class name that may not be full qualified (ignore primitive value types)" access="public" returntype="string" output="false">
	<cfargument name="className" hint="the name of the class" type="string" required="Yes">
	<cfargument name="package" hint="the package the class comes from" type="string" required="Yes">
	<cfscript>
		if(isPrimitive(arguments.className))
		{
			return arguments.className;
		}

		if(ListLen(arguments.className, ".") eq 1)
		{
			arguments.className = arguments.package & "." & arguments.className;
		}

		return arguments.className;
    </cfscript>
</cffunction>

<cffunction name="classExists" hint="check to see if a given class exists" access="public" returntype="boolean" output="false">
	<cfargument name="class" hint="a dot notated class path" type="string" required="Yes">
	<cfscript>
		return fileExists(classToFile(argumentCollection=arguments));
    </cfscript>
</cffunction>

<cffunction name="classToFile" hint="converts a classpath to a filename" access="public" returntype="string" output="false">
	<cfargument name="class" hint="a dot notated class path" type="string" required="Yes">
	<cfscript>
		var path = "/" & replace(arguments.class, ".", "/", "all") & ".cfc";

		return expandPath(path);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getClassCache" access="private" returntype="struct" output="false">
	<cfreturn instance.classCache />
</cffunction>

<cffunction name="setClassCache" access="private" returntype="void" output="false">
	<cfargument name="classCache" type="struct" required="true">
	<cfset instance.classCache = arguments.classCache />
</cffunction>

</cfcomponent>