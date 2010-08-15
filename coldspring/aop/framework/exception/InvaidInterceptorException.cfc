<cfcomponent hint="Exception to be thrown when a declared interceptor is neither Advice or Advisor" extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="name" hint="the bean name of the interceptor" type="string" required="Yes">
	<cfargument name="interceptor" hint="the invalid interceptor" type="any" required="Yes">
	<cfscript>
		super.init("The bean '#arguments.name#' is not a valid interceptor",
			"The class of '#getMetadata(arguments.interceptor).name#' must implement either 'coldspring.aop.Advice', or 'coldspring.aop.Advisor'"
			);
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>