<cfcomponent hint="Exception for when autowiring by type finds more than one bean name to type" extends="coldspring.exception.Exception" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="void" output="false">
	<cfargument name="id" hint="the id of the bean" type="string" required="Yes">
	<cfargument name="className" hint="the classname that is attempting to be resolved" type="string" required="Yes">
	<cfscript>
		super.init("Error attempting to autowire by type",
		"Error while autowiring by type bean with the id of '#arguments.id#'. More than one bean in your configuration file resolves to the type '#arguments.className#'");
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>