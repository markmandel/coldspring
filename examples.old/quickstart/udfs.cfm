<cffunction name="getCodeSnippet" access="public" returntype="string" output="false" hint="">
	<cfargument name="snippetFile" type="string" required="true" />
	<cfargument name="codeType" type="string" required="false" default="coldfusion" />
	<cfset var testSnippet = "" />
	<cffile action="read" file="#ExpandPath('/examples/quickstart/#arguments.snippetFile#')#" variable="codeSnippet" />
	<cfreturn '<pre class="#arguments.codeType#" name="code">#HTMLEditFormat(Trim(codeSnippet))#</pre>' />
</cffunction>

<cffunction name="createColdSpring" access="public" returntype="void" output="false" hint="">
	<cfargument name="configFile" type="string" required="false" default="coldspring.xml" />
	<cfscript>
        import coldspring.beans.xml.XmlBeanFactory;
        beanFactory = new XmlBeanFactory(expandPath('config/#arguments.configFile#'));		
	</cfscript>
</cffunction>