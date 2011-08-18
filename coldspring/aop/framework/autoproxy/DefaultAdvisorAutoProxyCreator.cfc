<cfcomponent
	hint="BeanPostProcessor implementation that creates AOP proxies based on all candidate Advisors in the current BeanFactory."
	extends="AbstractAdvisorAutoProxyCreator"
	output="false">

<cfscript>
	meta = getMetadata(this);
	if(!structKeyExists(meta, "const"))
	{
		const = {};
		const.AUTOPROXYABLE_CLASS = "coldspring.aop.framework.autoproxy.AutoProxyable";

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="findEligableAdvisors" hint="Abstract: overwrite me to determine which Advisors are candidates for auto proxying"
			access="private" returntype="array" output="false" colddoc:generic="coldspring.aop.Advisor">
	<cfscript>
		var advisors = findCandidateAdvisors();
		var advisor = 0;

		var eligableAdvisors = createObject("java", "java.util.ArrayList").init();
    </cfscript>
    <cfloop array="#advisors#" index="advisor">
		<cfscript>
			if(isInstanceOf(advisor, meta.const.AUTOPROXYABLE_CLASS) AND advisor.isAutoproxyCandidate())
			{
				arrayAppend(eligableAdvisors, advisor);
			}
        </cfscript>
    </cfloop>

    <cfreturn eligableAdvisors />
</cffunction>

</cfcomponent>