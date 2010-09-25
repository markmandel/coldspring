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

<cfcomponent hint="The application.cfc" output="false">
<cfsetting requesttimeout="#(60*60)#">

<cfscript>
	this.name = "ColdSpring Unit Tests";
	this.sessionmanagement = true;
	this.sessiontimeout = createTimespan(0, 0, 10, 0);

	//orm settings
	this.datasource = "coldspring";
	this.ormenabled = true;
	this.ormSettings.cfclocation = expandPath("/unittests/cf9/hibernate/com/");
	this.ormSettings.dbcreate = "dropcreate";
	this.ormSettings.sqlscript = expandPath("/unittests/cf9/hibernate/com/import.sql");
	this.ormSettings.dialect = "MySQLwithInnoDB";

	this.ormSettings.flushatrequestend = false;
	this.ormSettings.automanageSession = false;

	this.ormsettings.eventhandling = true;
	this.ormsettings.eventhandler = "coldspring.orm.hibernate.BeanInjectorEventHandler";

	//createObject("component", "coldspring.orm.hibernate.BeanInjectorEventHandler").init();
</cfscript>

<cffunction name="onRequestStart" returnType="boolean">
    <cfargument type="string" name="targetPage" required=true/>

	<cfscript>
		//use this if you need to autowire
		application.coldspring = createObject("component", "coldspring.beans.xml.XmlBeanFactory").init(expandPath("/unittests/testBeans/beanInjector-name-bean.xml"));
    </cfscript>

    <cfreturn true>
</cffunction>

</cfcomponent>