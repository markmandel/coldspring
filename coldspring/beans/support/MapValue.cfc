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

<cfcomponent hint="I represent a struct of AbstractValues, use getValue() to modify" extends="AbstractValue" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="MapValue" output="false">
	<cfscript>
		//use a hashmap, so we can work this fast, and store objects as keys
		setValueMap(createObject("java", "java.util.HashMap").init());
		setUseConcurrentHashMap(false);

		return this;
	</cfscript>
</cffunction>

<cffunction name="addValue" hint="add a value to this map" access="public" returntype="void" output="false">
	<cfargument name="key" hint="the abstractValue that represents the key" type="AbstractValue" required="Yes">
	<cfargument name="value" hint="the abstractValue that represents the value to add" type="AbstractValue" required="Yes">
	<cfscript>
		/*
			if we are using something other than a simple value
			for a key, we will use a ConcurrentHashMap, as it can manage objects
			as keys.
		*/
		if(NOT isInstanceOf(arguments.key, "SimpleValue"))
		{
			setUseConcurrentHashMap(true);
		}

		getValueMap().put(arguments.key, arguments.value);
    </cfscript>
</cffunction>

<cffunction name="getValue" hint="A new instance of the struct (map)" access="public" returntype="struct" output="false">
	<cfscript>
		var struct = 0;
		var valueMap = getValueMap();
		var key = 0;

		if(getUseConcurrentHashMap())
		{
			struct = createObject("java", "java.util.concurrent.ConcurrentHashMap").init(structCount(getValueMap()));
		}
		else
		{
			struct = {};
		}

		for(key in valueMap)
		{
			/*
				we have to use the java native methods, as we may/may not be
				dealing an native Java Map, and/or have Objects as keys
			*/
			struct.put(key.getValue(), getValueMap().get(key).getValue());
		}

		return struct;
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setCloneInstanceData" hint="sets the incoming data for this object as a clone" access="private" returntype="void" output="false">
	<cfargument name="instance" hint="instance data" type="struct" required="Yes">
	<cfargument name="cloneable" hint="" type="coldspring.util.Cloneable" required="Yes">
	<cfscript>
		arguments.instance.valueMap = arguments.cloneable.cloneStruct(arguments.instance.valueMap, true, "java.util.HashMap");

		variables.instance = arguments.instance;
    </cfscript>
</cffunction>

<cffunction name="getValueMap" access="private" returntype="struct" output="false" colddoc:generic="AbstractValue,AbstractValue">
	<cfreturn instance.valueMap />
</cffunction>

<cffunction name="setValueMap" access="private" returntype="void" output="false">
	<cfargument name="valueMap" type="struct" required="true" colddoc:generic="AbstractValue,AbstractValue">
	<cfset instance.valueMap = arguments.valueMap />
</cffunction>

<cffunction name="getUseConcurrentHashMap" access="private" returntype="boolean" output="false">
	<cfreturn instance.useConcurrentHashMap />
</cffunction>

<cffunction name="setUseConcurrentHashMap" access="private" returntype="void" output="false">
	<cfargument name="useConcurrentHashMap" type="boolean" required="true">
	<cfset instance.useConcurrentHashMap = arguments.useConcurrentHashMap />
</cffunction>

</cfcomponent>