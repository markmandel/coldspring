<cfcomponent hint="Remote facade for helloProxyOnMMAOP">

<!--- this always trips me up, lets set it up as a default --->
<cfsetting showdebugoutput="false">

<cfscript>
	//keep this lightweight, as this cfc will probably get instantiated on each call (as per CF usually does things)
	beanName = "helloProxyOnMMAOP";
	beanFactoryName = "remoteBeanFactory";
	beanScope = "application";
	locator = createObject("component", "coldspring.beans.factory.access.ScopeBeanFactoryLocator").init();

	locator.setBeanFactoryName(beanFactoryName);
	locator.setBeanFactoryScope(beanScope);

	beanFactory = locator.getInstance();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="sayHello" access="remote" returntype="string" hint="" output="false">
<cfargument name="str" type="string" required="no" hint="">
<cfreturn getTarget().sayHello(argumentCollection=arguments) >
</cffunction>

<cffunction name="doThis" access="remote" returntype="any" hint="" output="false">
<cfreturn getTarget().doThis(argumentCollection=arguments) >
</cffunction>

<cffunction name="doThat" access="remote" returntype="any" hint="" output="false">
<cfreturn getTarget().doThat(argumentCollection=arguments) >
</cffunction>



<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getTarget" hint="returns the target object this proxy wraps" access="public" returntype="any" output="false">
	<cfreturn beanFactory.getBean(beanName) />
</cffunction>

</cfcomponent>