<!---
   Copyright 2010 Mark Mandel
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at
       http://www.apache.org/licenses/LICENSE-2.0
   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.

 --->

<html>

<body>

<cfif !structIsEmpty(form)>
    <cfscript>
		exclude = "cf9";
		engine = createObject("component", "coldspring.util.Engine").init();

        if(engine.getMajorVersion() >= 9 || engine.getName() == "Railo")
        {
			exclude = "";
        }

        directoryTestSuite = createObject("component", "mxunit.runner.DirectoryTestSuite");
        result = directoryTestSuite.run(directory="#expandPath('/unittests')#"
                                        ,componentPath="unittests"
                                        ,recurse="true"
                                        ,excludes="#exclude#");
    </cfscript>

    <cfoutput> #result.getResultsOutput()# </cfoutput>
<cfelse>

	<form method="post">
		<input type="hidden" name="runMe" value="please">
	    <input type="submit" value="Run All Tests">
	</form>

    <cfdirectory action="list" directory="#expandPath("./")#" filter="*Test.cfc" name="tests" recurse="true"/>
<!---  http://coldspring/cf9/unittests/beans/XmlFactoryTest.cfc?method=runtestremote&output=html
  --->
	<cfscript>
		root = getDirectoryFromPath(CGI.CF_TEMPLATE_PATH);
	</cfscript>
    <cfoutput>
	<h4>Run Individual Tests</h4>
    <ul>
        <cfloop query="tests">
	        <cfscript>
		        path = replaceNoCase(tests.directory, root, '');
	        </cfscript>
            <li>
                <a href="#getDirectoryFromPath(CGI.SCRIPT_NAME)#/#path#/#name#?method=runTestRemote">#path#/#name#</a>
            </li>
        </cfloop>
    </ul>
    </cfoutput>
</cfif>

</body>

</html>