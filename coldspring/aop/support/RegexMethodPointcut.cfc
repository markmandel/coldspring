<cfcomponent hint="Regular expression pointcut. Supports the following JavaBean properties:<br/>
    * pattern: regular expression for the method names to match<br/>
    * patterns: alternative property taking a String array of patterns.<br/>
	The result will be the union of these patterns."
	implements="coldspring.aop.Pointcut" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RegexMethodPointcut" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Does given method, for the given class, match for this pointcut" access="public" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">
	<cfscript>
		var pattern = 0;
    </cfscript>
	<cfloop array="#getPatterns()#" index="pattern">
		<cfscript>
			if(reFind(pattern, arguments.method.getName()) > 0)
			{
				return true;
			}
        </cfscript>
	</cfloop>
	<cfreturn false />
</cffunction>

<cffunction name="setPattern" hint="Convenience method when we have only a single pattern. Use either this method or setPatterns(), not both."
	access="public" returntype="void" output="false">
	<cfargument name="pattern" type="string" required="true">
	<cfscript>
		var patterns = [arguments.pattern];

		setPatterns(patterns);
    </cfscript>
</cffunction>

<cffunction name="getPatterns" hint="Return the regular expressions for method matching." access="public" returntype="any" output="false">
	<cfreturn instance.patterns />
</cffunction>

<cffunction name="setPatterns" hint="Set the regular expressions defining methods to match. Matching will be the union of all these; if any match, the pointcut matches."
	access="public" returntype="void" output="false">
	<cfargument name="patterns" hint="A list or an array of patterns" type="any" required="true">
	<cfscript>
		if(isSimpleValue(arguments.patterns))
		{
			arguments.patterns = listToArray(arguments.patterns);
		}
    </cfscript>

	<cfset instance.patterns = arguments.patterns />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>