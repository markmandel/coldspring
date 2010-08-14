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

<!--- 
normally it doesn't take this long, but when
I'm on a plane, and my m17x is on 65W of power
it takes a while.
 --->
<cfsetting requesttimeout="9600">

<cfoutput>
<cfscript>
	base = expandPath("/coldspring");
	path = expandPath("../../api/coldspring");

	colddoc = createObject("component", "colddoc.ColdDoc").init();
	strategy = createObject("component", "colddoc.strategy.api.HTMLAPIStrategy").init(path, "ColdSpring 2.0 - Narwhal");
	colddoc.setStrategy(strategy);

	colddoc.generate(base, "coldspring");
</cfscript>
</cfoutput>
<h1>Done!</h1>

<p>
<cfoutput>#now()#</cfoutput>
</p>

<a href="../../api/coldspring">Documentation</a>
