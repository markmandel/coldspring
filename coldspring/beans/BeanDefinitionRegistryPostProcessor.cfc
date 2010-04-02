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

<cfinterface hint="A post processor for when the BeanDefintinitionRegistry is comple, but notifyComplete has not fired yet.
					This enables the ability to add/remove/move BeanDefinitions before notifyComplete occurs">

<cffunction name="postProcessBeanDefinitionRegistry" hint="Modify the application context's internal bean definition registry after its standard initialization.
				All regular bean definitions will have been loaded, but no beans will have been instantiated yet, or will autowiring have been configured.
				This allows for adding further bean definitions before the next post-processing phase kicks in." access="public" returntype="void" output="false">
	<cfargument name="registry" hint="The bean definition registry itself" type="coldspring.beans.BeanDefinitionRegistry" required="Yes">
</cffunction>

</cfinterface>