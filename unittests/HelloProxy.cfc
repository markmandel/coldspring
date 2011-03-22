<cfcomponent hint="Remote facade for helloProxy">

<!--- this always trips me up, lets set it up as a default --->
<cfsetting showdebugoutput="false">

<cfscript>
	//keep this lightweight, as this cfc will probably get instantiated on each call (as per CF usually does things)
	beanName = "helloProxy";
	beanFactoryName = "remoteBeanFactory";
	beanScope = "application";
	locator = createObject("component", "coldspring.beans.factory.access.ScopeBeanFactoryLocator").init();

	locator.setBeanFactoryName(beanFactoryName);
	locator.setBeanFactoryScope(beanScope);

	beanFactory = locator.getInstance();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="sayHello" access="remote" returntype="string" default="arguments.returnType" hint="arguments.hint" output="false">
<cfargument name="str" type="arguments.type" required="no" hint="">
<cfreturn getTarget().sayHello(argumentCollection=arguments) >
</cffunction>



<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getTarget" hint="returns the target object this proxy wraps" access="public" returntype="any" output="false">
	<cfreturn beanFactory.getBean(beanName) />
</cffunction>

</cfcomponent>