
<cfinvoke component="mxunit.runner.DirectoryTestSuite"
			method="run"
			directory="#expandPath('/coldspring/unittests')#"
			componentPath="unittests"
			recurse="true"
			excludes=""
			returnvariable="results" />

 <cfoutput> #results.getResultsOutput('extjs')# </cfoutput>