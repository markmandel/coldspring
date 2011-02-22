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

<cfinterface hint="Defines a contract for the lookup and use of a BeanFactory. Most commonly used in for powering remoting facades.">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="getInstance" hint="return an instance of the BeanFactory for which this locator has found" access="public" returntype="coldspring.beans.BeanFactory" output="false">
</cffunction>

<cffunction name="setBeanFactory" hint="set the bean factory to be stored under the conditions required by the locator." access="public" returntype="void" output="false">
	<cfargument name="beanFactory" hint="the bean factory to set" type="coldspring.beans.BeanFactory" required="Yes">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>