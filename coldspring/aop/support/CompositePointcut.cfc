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

<cfcomponent hint="A pointcut that allows multiple pointcuts to be joined into one super pointcut of doom"
			implements="coldspring.aop.Pointcut"
			output="false">

<cfscript>
	meta = getMetadata(this);

	if(!structKeyExists(meta, "const"))
	{
		const = {};

		const.AND = 1;
		const.OR = 2;

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CompositePointcut" output="false">
	<cfargument name="initialPointcut" hint="the initial pointcut to start off with" type="coldspring.aop.Pointcut" required="Yes">
	<cfargument name="negate" hint="whether to switch the matching of the initial pointcut, i.e. !initialPointcut.match()" type="boolean" required="No" default="false">
	<cfscript>
		setInitialPointcut(arguments.initialPointcut);
		setNegateInitialPointcut(arguments.negate);
		setPointcutCollection(createObject("java", "java.util.ArrayList").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Does given method, for the given class, match for this pointcut" access="public" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">

	<cfscript>
		var finalMatch = getInitialPointcut().matches(arguments.method, arguments.class);
		var match = 0;
		var pointcutCollection = getPointcutCollection();
		var pointcutData = 0;

		if(getNegateInitialPointcut())
		{
			finalMatch = !finalMatch;
		}
    </cfscript>

	<cfloop array="#pointcutCollection#" index="pointcutData">
		<cfscript>
			match = pointcutData.pointcut.matches(arguments.method, arguments.class);

			if(pointcutData.negate)
			{
				match = !match;
			}

			if(pointcutData.operator == meta.const.AND)
			{
				finalMatch = finalMatch && match;
			}
			else if(pointcutData.operator == meta.const.OR)
			{
				finalMatch = finalMatch || match;
			}
        </cfscript>
	</cfloop>

	<cfreturn finalMatch />
</cffunction>

<cffunction name="addAndPointcut" hint="add a pointcut that will be added to the set of pointcuts under AND boolean logic" access="public" returntype="void" output="false">
	<cfargument name="pointcut" hint="the pointcut to add to the logic set" type="coldspring.aop.Pointcut" required="Yes">
	<cfargument name="negate" hint="whether to switch the matching of the pointcut, i.e. !pointcut.match()" type="boolean" required="No" default="false">
	<cfscript>
		addPointcut(arguments.pointcut, arguments.negate, meta.const.AND);
    </cfscript>
</cffunction>

<cffunction name="addOrPointcut" hint="add a pointcut that will be added to the set of pointcuts under OR boolean logic" access="public" returntype="void" output="false">
	<cfargument name="pointcut" hint="the pointcut to add to the logic set" type="coldspring.aop.Pointcut" required="Yes">
	<cfargument name="negate" hint="whether to switch the matching of the pointcut, i.e. !pointcut.match()" type="boolean" required="No" default="false">
	<cfscript>
		addPointcut(arguments.pointcut, arguments.negate, meta.const.OR);
    </cfscript>
</cffunction>


<cffunction name="getInitialPointcut" access="public" returntype="coldspring.aop.Pointcut" output="false">
	<cfreturn instance.initialPointcut />
</cffunction>

<cffunction name="setInitialPointcut" access="public" returntype="void" output="false">
	<cfargument name="initialPointcut" type="coldspring.aop.Pointcut" required="true">
	<cfset instance.initialPointcut = arguments.initialPointcut />
</cffunction>

<cffunction name="getNegateInitialPointcut" access="public" returntype="boolean" output="false">
	<cfreturn instance.negateInitialPointcut />
</cffunction>

<cffunction name="setNegateInitialPointcut" access="public" returntype="void" output="false">
	<cfargument name="negateInitialPointcut" type="boolean" required="true">
	<cfset instance.negateInitialPointcut = arguments.negateInitialPointcut />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="addPointcut" hint="add a pointcut that will be added to the set of pointcuts under AND boolean logic" access="private" returntype="void" output="false">
	<cfargument name="pointcut" hint="the pointcut to add to the logic set" type="coldspring.aop.Pointcut" required="Yes">
	<cfargument name="negate" hint="whether to switch the matching of the pointcut, i.e. !pointcut.match()" type="boolean" required="No" default="false">
	<cfargument name="operator" hint="the boolean operator to use" type="numeric" required="Yes">
	<cfscript>
		arrayAppend(getPointcutCollection(), arguments);
    </cfscript>
</cffunction>

<cffunction name="getPointcutCollection" access="private" returntype="array" output="false">
	<cfreturn instance.pointcutCollection />
</cffunction>

<cffunction name="setPointcutCollection" access="private" returntype="void" output="false">
	<cfargument name="pointcutCollection" type="array" required="true">
	<cfset instance.pointcutCollection = arguments.pointcutCollection />
</cffunction>

</cfcomponent>