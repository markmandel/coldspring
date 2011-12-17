<cfcomponent hint="Simple observer" output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="Observer" output="false">
	<cfargument name="doReturnValue" hint="whether to return a value or not" type="boolean" required="false" default="true">
	<cfargument name="returnValue" hint="the return value" type="string" required="false" default="foo">
	<cfscript>
		//this.id = createUUID();
		structAppend(variables, arguments);

		return this;
	</cfscript>
</cffunction>

<cffunction name="update" hint="update method" access="public" returntype="void" output="false">
	<cfscript>
		StructAppend(this, arguments);
    </cfscript>
</cffunction>

<cffunction name="returnString" hint="returns 'foo'" access="public" returntype="string" output="false">
	<cfif variables.doReturnValue>
		<cfreturn variables.returnValue />
	</cfif>
</cffunction>
		
</cfcomponent>