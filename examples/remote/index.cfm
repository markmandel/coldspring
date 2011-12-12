<cfimport taglib="/examples/layout" prefix="layout" />

<cfoutput>
<layout:layout section="remote">
<h1>Generating Remote Proxies with ColdSpring</h1>

<p>You can see that the remote proxy was created by <a href="/examples/remote/RemoteLanguageService.cfc?wsdl">clicking here to view the WSDL for it.</a></p>

<hr>

<p>Below is the output from invoking the web service:</p>


<!--- Invoke the web service. --->
<cfinvoke
	webservice="http://#CGI.SERVER_NAME#:#CGI.SERVER_PORT#/examples/remote/RemoteLanguageService.cfc?wsdl"
	method="reverseString"
	returnvariable="wsReturnValue">

	<cfinvokeargument name="string" value="Coldspring" />
</cfinvoke>

<!--- Display compliment. --->
#wsReturnValue#


</layout:layout>
</cfoutput>