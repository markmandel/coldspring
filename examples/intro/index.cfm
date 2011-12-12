<cfimport taglib="/examples/layout" prefix="layout" />

<cfoutput>
<layout:layout section="intro">

<h1>ColdSpring In 5 Minutes</h1>

<p>For a detailed walkthrough of this example, visit <a href="http://sourceforge.net/apps/trac/coldspring/wiki/ColdSpringInFiveMinutes">http://sourceforge.net/apps/trac/coldspring/wiki/ColdSpringInFiveMinutes</a></p>

<p>
	Below are the 3 CFCs dumped using CFDump:
	<cfset userService = beanFactory.getBean('userService') />
	<cfdump var="#userService#" />
</p>

<p>
	<cfset userGateway = userService.getUserGateway() />
	<cfdump var="#userGateway#" />
</p>
<p>
	<cfset configBean = userGateway.getConfigBean() />
	<cfdump var="#configBean#" />
</p>

</layout:layout>
</cfoutput>