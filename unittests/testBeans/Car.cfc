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

<cfcomponent hint="Simple Car Bean">

<cfset this.id = CreateUUId() />

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Car" output="false">
	<cfargument name="engine" type="Engine" required="Yes" />
	<cfset setEngine(arguments.engine)>
	<cfreturn this />
</cffunction>

<cffunction name="configure" hint="post DI method that takes the make, and reverses it to reverse make" access="public" returntype="void" output="false">
	<cfscript>
		setReverseMake(reverse(getMake()));
    </cfscript>
</cffunction>

<cffunction name="setColor" access="public" returntype="void" output="false">
	<cfargument name="color" type="Color" required="Yes" />
	<cfset instance.color = arguments.color />
</cffunction>

<cffunction name="getColor" access="public" returntype="Color" output="false">
	<cfreturn instance.color />
</cffunction>

<cffunction name="getEngine" access="public" returntype="Engine" output="false">
	<cfreturn instance.Engine />
</cffunction>

<cffunction name="setEngine" access="private" returntype="void" output="false">
	<cfargument name="Engine" type="Engine" required="true">
	<cfset instance.Engine = arguments.Engine />
</cffunction>

<cffunction name="getMake" access="public" returntype="string" output="false">
	<cfreturn instance.Make />
</cffunction>

<cffunction name="setMake" access="public" returntype="void" output="false">
	<cfargument name="Make" type="string" required="true">
	<cfset instance.Make = arguments.Make />
</cffunction>

<cffunction name="getWheels" access="public" returntype="struct" output="false">
	<cfreturn instance.Wheels />
</cffunction>

<cffunction name="setWheels" access="public" returntype="void" output="false">
	<cfargument name="Wheels" type="struct" required="true">
	<cfset instance.Wheels = arguments.Wheels />
</cffunction>

<cffunction name="getReverseMake" access="public" returntype="string" output="false">
	<cfreturn instance.reverseMake />
</cffunction>

<cffunction name="setReverseMake" access="public" returntype="void" output="false">
	<cfargument name="reverseMake" type="string" required="true">
	<cfset instance.reverseMake = arguments.reverseMake />
</cffunction>

<cffunction name="clone" hint="create a clone of this object" access="public" returntype="Car" output="false">
	<cfscript>
		var cloneable = createObject("component", "coldspring.util.Cloneable").init();

		return cloneable.clone(this);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCloneInstanceData" hint="sets the incoming clone data " access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		if(structKeyExists(arguments.instance, "wheels"))
		{
			arguments.instance.wheels = arguments.cloneable.cloneStruct(arguments.instance.wheels);
		}

		arguments.instance.engine = arguments.instance.engine.clone();

		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

</cfcomponent>