<!---
   Copyright 2011 Mark Mandel

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
<cfinterface hint="Marker Interface for AutoProxyer's to check if Advisors are auto proxy-able">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="isAutoproxyCandidate" hint="is this Advisor a candidate for autoproxying. It is recommended that this value is defaulted to 'true',
				unless there is a good reason not to"
			access="public" returntype="boolean" output="false">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>