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
<cfinterface hint="Interface to be implemented by beans that wish to be aware of their owning BeanFactory.<br/>
				For example, beans can look up collaborating beans via the factory (Dependency Lookup).
				Note that most beans will choose to receive references to collaborating beans via corresponding
				bean properties or constructor arguments (Dependency Injection). ">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setBeanFactory" access="public" hint="Callback that supplies the owning factory to a bean instance.
			Invoked after the population of normal bean properties but before an initialization callback such as
			a custom init-method."
			returntype="void" output="false">
	<cfargument name="beanFactory" type="coldspring.beans.AbstractBeanFactory" required="true">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>