<cfcomponent hint="Simple observer" output="false">

<cffunction name="init" hint="Constructor" access="public" returntype="Observer" output="false">
	<cfscript>
		//this.id = createUUID();

		return this;
	</cfscript>
</cffunction>

<cffunction name="update" hint="update method" access="public" returntype="void" output="false">
	<cfscript>
		StructAppend(this, arguments);
    </cfscript>
</cffunction>

</cfcomponent>