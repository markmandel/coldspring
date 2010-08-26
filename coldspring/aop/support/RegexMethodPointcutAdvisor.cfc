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

<cfcomponent hint='Convenient class for regexp method pointcuts that hold an Advice, making them an Advisor.<br/>
			Configure this class using the "pattern" and "patterns" pass-through properties. <br/>
			These are analogous to the pattern and patterns properties of AbstractRegexpMethodPointcut.'
			extends="coldspring.aop.PointcutAdvisor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RegexMethodPointcutAdvisor" output="false">
	<cfscript>
		var pointcut = createObject("component", "RegexMethodPointcut").init();

		super.init(pointcut);

		return this;
	</cfscript>
</cffunction>

<cffunction name="setPattern" hint="Convenience method when we have only a single pattern. Use either this method or setPatterns(), not both."
	access="public" returntype="void" output="false">
	<cfargument name="pattern" type="string" required="true">
	<cfscript>
		getPointcut().setPattern(arguments.pattern);
    </cfscript>
</cffunction>

<cffunction name="setPatterns" hint="Set the regular expressions defining methods to match. Matching will be the union of all these; if any match, the pointcut matches."
	access="public" returntype="void" output="false">
	<cfargument name="patterns" hint="A list or an array of patterns" type="any" required="true">
	<cfscript>
		getPointcut().setPatterns(arguments.patterns);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>