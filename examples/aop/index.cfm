<cfimport taglib="/examples/layout" prefix="layout" />

<cfoutput>
<layout:layout section="aop">
<h1>Aspect-Oriented Programming with ColdSpring</h1>

<p>See <a href="http://sourceforge.net/apps/trac/coldspring/wiki/AOPSchema#ThePreviousExampleUsingAOPNamespace">http://sourceforge.net/apps/trac/coldspring/wiki/AOPSchema#ThePreviousExampleUsingAOPNamespace</a> for a description of this example.</p>

<cfset languageService = beanFactory.getBean('languageService') />

<p>
Result for duplicate: #languageService.duplicateString('foo', 3)#<br />
<cfdump var="#request.logData#" label="Log data for duplicate"><br />
</p>

<p>
Result for reverse: #languageService.reverseString('ColdSpring')#<br />
<cfdump var="#request.logData#" label="Log data for reverse"><br />
</p>

<p>
Result for capitalize: #languageService.capitalizeString('Dependency Injection')#<br />
<cfdump var="#request.logData#" label="Log data for capitalize"><br />
</p>

</layout:layout>
</cfoutput>