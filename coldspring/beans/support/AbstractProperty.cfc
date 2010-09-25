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

<cfcomponent hint="An abstract dependency, such as a constructor-arg or property definition" output="false"
			 colddoc:abstract="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getName" hint="The property name on the object" access="public" returntype="string" output="false">
	<cfreturn instance.name />
</cffunction>

<cffunction name="setName" access="public" returntype="void" output="false">
	<cfargument name="Name" type="string" required="true">
	<cfset instance.Name = arguments.name />
</cffunction>

<cffunction name="getValue" access="public" returntype="AbstractValue" output="false">
	<cfreturn instance.value />
</cffunction>

<cffunction name="getMeta" hint="Return custom object meta data" access="public" returntype="struct" output="false"
			colddoc:generic="string,string">
	<cfreturn instance.meta />
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="AbstractProperty" output="false">
	<cfscript>
		var cloneable = getComponentMetadata("coldspring.util.Cloneable").singleton.instance;

		return cloneable.clone(this);
    </cfscript>
</cffunction>

<cffunction name="create" hint="create an instance of the underlying value" access="public" returntype="any" output="false">
	<cfreturn getValue().getValue() />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="init" hint="Constructor" access="private" returntype="void" output="false">
	<cfargument name="name" hint="the name of the dependency argument" type="string" required="Yes">
	<cfargument name="value" hint="the abstract value of this dependency" type="AbstractValue" required="Yes">
	<cfscript>
		setName(arguments.name);
		setValue(arguments.value);
		setMeta(StructNew());
	</cfscript>
</cffunction>

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		arguments.instance.value = arguments.instance.value.clone();
		arguments.instance.meta = duplicate(arguments.instance.meta);

		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<cffunction name="setValue" access="private" returntype="void" output="false">
	<cfargument name="Value" type="AbstractValue" required="true">
	<cfset instance.value = arguments.value />
</cffunction>

<cffunction name="setMeta" access="private" returntype="void" output="false">
	<cfargument name="Meta" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.meta = arguments.meta />
</cffunction>

</cfcomponent>