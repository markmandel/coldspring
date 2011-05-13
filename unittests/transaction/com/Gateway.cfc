<!---
   Copyright 2011 Mark Mandel
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

<cfcomponent output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="Gateway" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<cffunction name="$insert" hint="inserts a value, then throws an exeception" access="public" returntype="void" output="false">
	<cfargument name="value" hint="the vaue to insert" type="string" required="Yes">
	<cfquery datasource="#request.datasource#">
		insert into Bar
		(id, name)
		values
		(
			<cfqueryparam value="#createUUID()#" cfsqltype="cf_sql_varchar">
			,<cfqueryparam value="#arguments.value#" cfsqltype="cf_sql_varchar">
		)
	</cfquery>

	<cfthrow type="uhoh" >
</cffunction>

<cffunction name="get" hint="returns a result from the db" access="public" returntype="query" output="false">
	<cfargument name="value" hint="the vaue to get" type="string" required="Yes">
	<cfset var query = 0>
	<cfquery name="query" datasource="#request.datasource#">
		select * from Bar
		where
		name = <cfqueryparam value="#arguments.value#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfreturn query />
</cffunction>

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>