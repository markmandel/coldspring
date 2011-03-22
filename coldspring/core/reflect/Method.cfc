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

<cfcomponent hint="A Method provides information about, and access to, a single method on a class or interface. The reflected method may be a class method or an instance method." output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Method" output="false">
	<cfargument name="methodMeta" hint="the meta data for this particular method" type="struct" required="Yes">
	<cfargument name="class" hint="the Class this method belongs to" type="Class" required="Yes">
	<cfargument name="isConcrete" hint="whether or not this is a concrete method (true), or it is backed by onMissingMethod (false)" type="boolean" required="no" default="true">
	<cfscript>
		var reflectionService = getComponentMetaData("coldspring.core.reflect.ReflectionService").singleton.instance;
    	var parameters = createObject("java", "java.util.ArrayList").init(); //pass by reference
		var item = 0;
		var parameter = 0;
		var counter = 1;
		var len = 0;

		//do some clean up for convenience
		if(!structKeyExists(arguments.methodMeta, "returntype"))
		{
			arguments.methodMeta.returntype = "any";
		}
		else
		{
			arguments.methodMeta.returntype = reflectionService.resolveClassName(arguments.methodMeta.returntype, arguments.class.getPackage());
		}

		if(!structKeyExists(arguments.methodMeta, "access"))
		{
			arguments.methodMeta.access = "public";
		}

		setMeta(arguments.methodMeta);
		setClass(arguments.class);
    	setConcrete(arguments.isConcrete);

		//bit of defensive code, as meta data often returns null.
		if(structKeyExists(arguments.methodMeta, "parameters"))
		{
			len = Arraylen(arguments.methodMeta.parameters);
			for(; counter <= len; counter++)
			{
				item = arguments.methodMeta.parameters[counter];
				parameter = createObject("component", "Parameter").init(item, this);
				arrayAppend(parameters, parameter);
			}
		}

		setParameters(parameters);

		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="invoke this method on a given object. (Usually an object of the same class as where this method comes from)" access="public" returntype="any" output="false">
	<cfargument name="object" hint="the object to invoke the method on" type="any" required="Yes">
	<cfargument name="args" hint="the arguments to pass through" type="struct" required="No" default="#structNew()#">
	<cfscript>
		var local = {};
    </cfscript>
	<cfinvoke component="#arguments.object#" method="#getname()#" argumentcollection="#arguments.args#" returnvariable="local.return">
	<cfscript>
		if(structKeyExists(local, "return"))
		{
			return local.return;
		}
    </cfscript>
</cffunction>

<cffunction name="hasAnnotation" hint="does the given annotation exist on this method" access="public" returntype="boolean" output="false">
	<cfargument name="annotation" hint="the name of the annotation" type="string" required="Yes">
	<cfreturn structKeyExists(getMeta(), arguments.annotation) />
</cffunction>

<cffunction name="getAnnotation" hint="Gets the value of this annotation from the metadata, and returns it" access="public" returntype="boolean" output="false">
	<cfargument name="annotation" hint="the name of the annotation" type="string" required="Yes">
	<cfreturn structFind(getMeta(), arguments.annotation) />
</cffunction>

<cffunction name="getName" hint="The name of the method" access="public" returntype="string" output="false">
	<cfreturn getMeta().name />
</cffunction>

<cffunction name="getMeta" hint="Returns the meta data for a this particular function<br/>A method meta returned from a Method will always have: returntype and access."
	access="public" returntype="struct" output="false">
	<cfreturn instance.meta />
</cffunction>

<cffunction name="$getClass" hint="Get the Class that this method belongs to" access="public" returntype="Class" output="false">
	<cfreturn instance.class />
</cffunction>

<cffunction name="isConcrete" hint="whether or not this is a concrete method (true), or it is backed by onMissingMethod (false)" access="public" returntype="boolean" output="false">
	<cfreturn instance.isConcrete />
</cffunction>

<cffunction name="getAccess" hint="The access level of this method, 'public', 'private', or 'package'" access="public" returntype="string" output="false">
	<cfreturn getMeta().access />
</cffunction>

<cffunction name="getReturnType" hint="the return type for this method" access="public" returntype="string" output="false">
	<cfreturn getMeta().returntype />
</cffunction>

<cffunction name="getParameters" access="public" returntype="array" output="false" colddoc:generic="Parameter">
	<cfreturn instance.parameters />
</cffunction>

<cffunction name="getParameter" hint="Convenience function to get a paramter from a specific index" access="public" returntype="Parameter" output="false">
	<cfargument name="index" hint="the index of the parameter" type="numeric" required="Yes">
	<cfscript>
		var parameters = getParameters();

		return parameters[arguments.index];
    </cfscript>
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="Method" output="false">
	<cfscript>
		var cloneable = getComponentMetadata("coldspring.util.Cloneable").singleton.instance;

		return cloneable.clone(this);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		//usually cloning is to modify something and then pass it elsewhere, so duplicate the meta.
		arguments.instance.meta = duplicate(arguments.instance.meta);

		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<cffunction name="setParameters" access="private" returntype="void" output="false">
	<cfargument name="parameters" type="array" required="true" colddoc:generic="string,Parameter">
	<cfset instance.parameters = arguments.parameters />
</cffunction>

<cffunction name="setConcrete" access="private" returntype="void" output="false">
	<cfargument name="isConcrete" type="boolean" required="true">
	<cfset instance.isConcrete = arguments.isConcrete />
</cffunction>

<cffunction name="setMeta" access="private" returntype="void" output="false">
	<cfargument name="meta" type="struct" required="true">
	<cfset instance.meta = arguments.meta />
</cffunction>

<cffunction name="setClass" access="private" returntype="void" output="false">
	<cfargument name="class" type="Class" required="true">
	<cfset instance.class = arguments.class />
</cffunction>

</cfcomponent>