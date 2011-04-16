<cfcomponent
	hint="BeanPostProcessor implementation that creates AOP proxies based on all candidate Advisors in the current BeanFactory."
	extends="AbstractAdvisorAutoProxyCreator"
	output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="findCandidateAdvisors" hint="Returns all Advisors in the BeanFactory." access="private" returntype="array" output="false"
	colddoc:generic="coldspring.aop.Advisor">
	<cfscript>
		var advisorNames = getBeanFactory().getBeanNamesForTypeIncludingAncestor("coldspring.aop.Advisor");
		var advisorName = 0;
		var advisors = createObject("java", "java.util.ArrayList").init(ArrayLen(advisorNames));
		var advisor = 0;
    </cfscript>
    <cfloop array="#advisorNames#" index="advisorName">
		<cfscript>
			advisor = getBeanFactory().getBean(advisorName);
			ArrayAppend(advisors, advisor);
        </cfscript>
	</cfloop>
	<cfreturn advisors />
</cffunction>

</cfcomponent>