<cfcomponent hint="Stores the exception on a throws advice" implements="coldspring.aop.ThrowsAdvice" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ExceptionStoreThrowsAdvice" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>


<cffunction name="afterThrowing" hint="Callback after a method throws an exception." access="public" returntype="void" output="false">
	<cfargument name="method" type="coldspring.reflect.Method" required="yes" />
	<cfargument name="args" type="struct" required="yes" />
	<cfargument name="target" type="any" required="yes" />
	<cfargument name="exception" type="struct" required="yes" />
	<cfscript>
		setException(arguments.exception);
    </cfscript>
</cffunction>

<cffunction name="getException" access="public" returntype="any" output="false">
	<cfreturn instance.Exception />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setException" access="private" returntype="void" output="false">
	<cfargument name="Exception" type="any" required="true">
	<cfset instance.Exception = arguments.Exception />
</cffunction>

</cfcomponent>