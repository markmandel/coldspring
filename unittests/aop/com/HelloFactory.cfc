<cfcomponent hint="Factory who has a method to create a Hello Object" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="HelloFactory" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>


<cffunction name="create" hint="creates a hello object" access="public" returntype="Hello" output="false">
	<cfreturn createObject("component", "Hello").init() />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>