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

<cfinterface hint="Interface that can be implemented by objects that should be orderable, for example in a Collection.<br/>
			The actual order can be interpreted as prioritization, with the first object (with the lowest order value) having the highest priority.<br/>
			See coldspring.core.OrderedComparator for convenience functions">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getOrder" hint="Return the order value of this object, with a higher value meaning greater in terms of sorting.<br/>
			Higher values can be interpreted as lower priority. As a consequence, the object with the lowest value has highest priority.<br/>
			"
			access="public" returntype="numeric" output="false">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>