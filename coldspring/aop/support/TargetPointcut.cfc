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

<cfcomponent hint="Pointcut to match all methods on a given class / interface" implements="coldspring.aop.Pointcut" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="TargetPointcut" output="false">
	<cfargument name="instanceType" hint="the name of the class or interface that this pointcut should match all methods on" type="string" required="Yes">
	<cfscript>
		setInstanceType(arguments.instanceType);
		setCFCMetaUtil(getComponentMetadata("coldspring.util.CFCMetaUtil").singleton.instance);

		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Can the currently class instance type be assigned to the provided class / interface" access="public" returntype="boolean" output="false">
	<cfargument name="methodMetadata" type="struct" required="yes" />
	<cfargument name="classMetadata" type="struct" required="yes" />

	<cfreturn getCFCMetaUtil().isAssignableFrom(arguments.classMetadata.name, getInstanceType()) />

</cffunction>

<cffunction name="getInstanceType" access="public" returntype="string" output="false">
	<cfreturn instance.instanceType />
</cffunction>

<cffunction name="setInstanceType" access="public" returntype="void" output="false">
	<cfargument name="instanceType" type="string" required="true">
	<cfset instance.instanceType = arguments.instanceType />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getCFCMetaUtil" access="private" returntype="coldspring.util.CFCMetaUtil" output="false">
	<cfreturn instance.cfcMetaUtil />
</cffunction>

<cffunction name="setCFCMetaUtil" access="private" returntype="void" output="false">
	<cfargument name="cfcMetaUtil" type="coldspring.util.CFCMetaUtil" required="true">
	<cfset instance.cfcMetaUtil = arguments.cfcMetaUtil />
</cffunction>

</cfcomponent>