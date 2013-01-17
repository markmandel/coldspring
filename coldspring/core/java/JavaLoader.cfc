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

<cfcomponent name="JavaLoader" hint="Facade for loading external Java Classes for ColdSpring.">

<cfscript>
	instance = StructNew();
	instance.static.SCOPE_KEY = "coldspring.51807A36-1941-4DAD-9CC541EF14360F27";
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="JavaLoader" output="false">
	<cfargument name="version" hint="the version of the bean factory in question" type="string" required="Yes">
	<cfscript>
		var singleton = createObject("component", "coldspring.util.Singleton").init();

		return singleton.createInstance(getMetaData(this).name, arguments);
	</cfscript>
</cffunction>

<cffunction name="configure" hint="config for singleton construction" access="public" returntype="JavaLoader" output="false">
	<cfargument name="version" hint="the version of the bean factory in question" type="string" required="Yes">
	<cfscript>
		var local = {};

		setJavaLoaderKey(instance.static.SCOPE_KEY & "." & arguments.version);
	</cfscript>

	<!--- double check lock for safety --->
	<cfif NOT hasJavaLoader()>
		<cflock name="coldspring.core.java.JavaLoader.init" throwontimeout="true" timeout="60">
			<cfscript>
				if(NOT hasJavaLoader())
				{
					local.args = {};
					local.args.loadPaths = queryJars();

					//uncommment during development
					//local.args.sourceDirectories = [ getDirectoryFromPath(getMetadata(this).path) & "/src/" ];
					//local.args.trustedSource = true;

					local.javaloader = createObject("component", "coldspring.util.javaloader.JavaLoader").init(argumentCollection=local.args);

					setJavaLoader(local.javaloader);
				}
			</cfscript>
		</cflock>
	</cfif>

	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="create" hint="Retrieves a reference to the java class. To create a instance, you must run init() on this object" access="public" returntype="any" output="false">
	<cfargument name="className" hint="The name of the class to create" type="string" required="Yes">
	<cfscript>
		return getJavaLoader().create(argumentCollection=arguments);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="queryJars" hint="pulls a query of all the jars in the /resources/lib folder" access="private" returntype="array" output="false"
			colddoc:generic="string">
	<cfscript>
		var qJars = 0;
		//the path to my jar library
		var path = getDirectoryFromPath(getMetaData(this).path) & "/lib/";
		var jarList = "";
		var aJars = ArrayNew(1);
		var libName = 0;
	</cfscript>

	<cfdirectory action="list" name="qJars" directory="#path#" filter="*.jar" sort="name desc"/>

	<cfloop query="qJars">
		<cfscript>
			libName = ListGetAt(qJars.name, 1, "-");
			//let's not use the lib's that have the same name, but a lower datestamp
			if(NOT ListFind(jarList, libName))
			{
				ArrayAppend(aJars, qJars.directory & "/" & qJars.name);
				jarList = ListAppend(jarList, libName);
			}
		</cfscript>
	</cfloop>

	<cfreturn aJars>
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldspring.util.javaloader.JavaLoader" output="false">
	<cfreturn StructFind(server, getJavaLoaderKey()) />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="javaLoader" type="coldspring.util.javaloader.JavaLoader" required="true">
	<cfset StructInsert(server, getJavaLoaderKey(), arguments.javaLoader) />
</cffunction>

<cffunction name="hasJavaLoader" hint="if the server scope has the JavaLoader in it" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(server, getJavaLoaderkey())/>
</cffunction>

<cffunction name="getJavaLoaderKey" access="private" returntype="string" output="false">
	<cfreturn instance.javaLoaderKey />
</cffunction>

<cffunction name="setJavaLoaderKey" access="private" returntype="void" output="false">
	<cfargument name="JavaLoaderKey" type="string" required="true">
	<cfset instance.javaLoaderKey = arguments.javaLoaderKey />
</cffunction>

<cffunction name="dummy" hint="does nothing except reset meta data" access="private" returntype="void" output="false">

</cffunction>

</cfcomponent>