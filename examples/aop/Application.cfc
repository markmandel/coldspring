<cfcomponent displayname="Application">

	<cfscript>
		this.name = "coldspring-aop-example";
	</cfscript>

	<cffunction name="onRequest">
		<cfargument name="targetPage" required="true">

		<!---
			In a production application this would generally be placed in onApplicationStart and
			the beanFactory placed in application scope.  However for demonstration purposes we
			place it in onRequest so we can reload it easily.
		--->
		<cfscript>
	        import coldspring.beans.xml.XmlBeanFactory;
	        	beanFactory = new XmlBeanFactory(expandPath('config/coldspring.xml'));
		</cfscript>

        <!--- Include the requested page. --->
        <cfinclude template="#arguments.targetPage#" />

	</cffunction>

</cfcomponent>