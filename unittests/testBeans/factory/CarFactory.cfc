<cfcomponent hint="factory for car components" output="true">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="CarFactory" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="getEngine" hint="returns an engine" access="public" returntype="unittests.testBeans.Engine" output="false">
	<cfargument name="gears" hint="the gears for the engine" type="array" required="Yes">
	<cfscript>
		var engine = createObject("component", "unittests.testBeans.Engine").init();

		engine.setGears(arguments.gears);

		return engine;
    </cfscript>
</cffunction>

<cffunction name="getColor" hint="gets a colour" access="public" returntype="unittests.testBeans.Color" output="false">
	<cfreturn createObject("component", "unittests.testBeans.Color").init() />
</cffunction>

<cffunction name="getWheel" hint="gets  wheel" access="public" returntype="unittests.testBeans.Wheel" output="false">
	<cfreturn createObject("component", "unittests.testBeans.Wheel").init() />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


</cfcomponent>