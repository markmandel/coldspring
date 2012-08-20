<!---
   Copyright 2012 Mark Mandel
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

<cfcomponent hint="The application.cfc" output="false">
	<cfsetting requesttimeout="#(60*60)#">

	<cfscript>
		this.name = "coldspringAOPORM";
		this.sessionmanagement = true;
		this.sessiontimeout = createTimespan(0, 0, 10, 0);

		this.mappings["/coldspring"] = expandPath("../../coldspring");
		this.mappings["/model"] = expandPath("./model");

		//orm settings
		this.datasource = "coldspringAOPORM";

		this.ormenabled = true;
		this.ormSettings.cfclocation = "model";
		this.ormSettings.dbcreate = "dropcreate";
		this.ormSettings.sqlscript = expandPath("./import.sql");
		this.ormsettings.logSQL = true;

		//We turn this off, because we will be managing flushing with Transactions.
		this.ormSettings.flushatrequestend = false;
		this.ormSettings.automanageSession = false;

		//Autowire any beans that are created, so they can have dependencies.
		this.ormsettings.eventhandling = true;
		this.ormsettings.eventhandler = "coldspring.orm.hibernate.BeanInjectorEventHandler";
	</cfscript>

	<!--- just so you can run this on MYSQL if you want --->
	<cfdbinfo type="version" name="version" datasource="#this.datasource#">

	<cfscript>
		//otherwise, mySQL gives up myISAM, which doesn't support transactions :P
		if(version.database_productname eq "mysql")
		{
			this.ormSettings.dialect = "MySQLwithInnoDB";
		}
	</cfscript>

	<cffunction name="onApplicationStart" hint="application start" access="public" returntype="boolean" output="false">
		<cfscript>
			application.coldspring = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("./config/coldspring.xml"));
			return true;
		</cfscript>
	</cffunction>

	<cffunction name="onRequestStart" returnType="boolean">
		<cfargument type="string" name="targetPage" required=true/>

		<cfinclude template="./include/cfsetting.cfm" />

		<cfscript>
			// simple reload using application stop.
			if(structKeyExists(url, "reload"))
			{
				applicationStop();
				location(".", false);
			}
		</cfscript>

		<cfreturn true>
	</cffunction>

</cfcomponent>