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

<cfcomponent hint="Convenient class for name-match method pointcuts that hold an Advice, making them an Advisor."
	extends="coldspring.aop.PointcutAdvisor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="NamedMethodPointcutAdvisor" output="false">
	<cfscript>
		var pointcut = createObject("component", "NamedMethodPointcut").init();

		super.init(pointcut);

		return this;
	</cfscript>
</cffunction>

<cffunction name="setMappedName" hint="Convenience method when we have only a single method name to match. Use either this method or setMappedNames, not both." access="public" returntype="void" output="false">
	<cfargument name="name" hint="the mapping name" type="string" required="Yes">
	<cfscript>
		getPointcut().setMappedName(arguments.name);
    </cfscript>
</cffunction>

<cffunction name="setMappedNames" hint="List, or array of mapped names" access="public" returntype="void" output="false">
	<cfargument name="mappedNames" type="any" required="true">
	<cfscript>
		getPointcut().setMappedNames(arguments.mappedNames);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>