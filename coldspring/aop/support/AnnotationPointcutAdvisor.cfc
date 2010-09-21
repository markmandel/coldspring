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

<cfcomponent hint="Convenient class for annotation matching pointcuts that hold an Advice, making them an Advisor."
	extends="coldspring.aop.PointcutAdvisor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AnnotationPointcutAdvisor" output="false">
	<cfscript>
		var pointcut = createObject("component", "AnnotationPointcut").init();

		super.init(pointcut);

		return this;
	</cfscript>
</cffunction>

<cffunction name="setClassAnnotations" hint="Key value pair of annotations on a CFC to look for."
	access="public" returntype="void" output="false">
	<cfargument name="classAnnotations" type="struct" required="true" colddoc:generic="string,string">
	<cfset getPointcut().setClassAnnotations(arguments.classAnnotations)>
</cffunction>

<cffunction name="setMethodAnnotations" access="public" returntype="void" output="false">
	<cfargument name="methodAnnotations" type="struct" required="true" colddoc:generic="string,string">
	<cfset getPointcut().setMethodAnnotations(arguments.methodAnnotations)>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>