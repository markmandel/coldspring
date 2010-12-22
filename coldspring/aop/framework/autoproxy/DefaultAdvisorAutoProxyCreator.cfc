<cfcomponent
	hint="BeanPostProcessor implementation that creates AOP proxies based on all candidate Advisors in the current BeanFactory."
	extends="AbstractAdvisorAutoProxyCreator"
	output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="findCandidateAdvisors" hint="Returns all Advisors in the BeanFactory." access="private" returntype="array" output="false"
	colddoc:generic="coldspring.aop.Advisor">

	<cfset println(getBeanFactory().getBeanNamesForTypeIncludingAncestor("coldspring.aop.Advisor").toString())>

	<cfreturn getBeanFactory().getBeanNamesForTypeIncludingAncestor("coldspring.aop.Advisor") />
</cffunction>

<cffunction name="println" hint="" access="private" returntype="void" output="false">
	<cfargument name="str" hint="" type="string" required="Yes">
	<cfscript>
		createObject("Java", "java.lang.System").out.println(arguments.str);
	</cfscript>
</cffunction>


</cfcomponent>