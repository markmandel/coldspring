<cfcomponent hint="Remote facade for remoteLanguageService">

<!--- this always trips me up, lets set it up as a default --->
<cfsetting showdebugoutput="false">

<cfscript>
	//keep this lightweight, as this cfc will probably get instantiated on each call (as per CF usually does things)
	beanName = "remoteLanguageService";
	beanFactoryName = "remoteBeanFactory";
	beanScope = "application";
	locator = createObject("component", "coldspring.beans.factory.access.ScopeBeanFactoryLocator").init();

	locator.setBeanFactoryName(beanFactoryName);
	locator.setBeanFactoryScope(beanScope);

	beanFactory = locator.getInstance();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="reverseString" access="remote" returntype="string" hint="" output="false">
<cfargument name="string" type="string" required="true" hint="">
<cfreturn getTarget().reverseString(argumentCollection=arguments) >
</cffunction>

<cffunction name="duplicateString" access="remote" returntype="string" hint="" output="false">
<cfargument name="string" type="string" required="true" hint="">
<cfargument name="numberOfDuplicates" type="numeric" required="true" hint="">
<cfreturn getTarget().duplicateString(argumentCollection=arguments) >
</cffunction>



<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getTarget" hint="returns the target object this proxy wraps" access="private" returntype="any" output="false">
	<cfreturn beanFactory.getBean(beanName) />
</cffunction>

</cfcomponent>