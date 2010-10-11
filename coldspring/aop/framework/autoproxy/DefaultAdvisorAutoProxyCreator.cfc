<cfcomponent
	hint="BeanPostProcessor implementation that creates AOP proxies based on all candidate Advisors in the current BeanFactory."
	extends="AbstractAdvisorAutoProxyCreator"
	output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="findCandidateAdvisors" hint="Returns all Advisors in the BeanFactory." access="private" returntype="array" output="false"
	colddoc:generic="coldspring.aop.Advisor">
	<cfreturn getBeanFactory().getBeanNamesForTypeIncludingAncestor("coldspring.aop.Advisor") />
</cffunction>

</cfcomponent>