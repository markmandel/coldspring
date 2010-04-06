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

<cfinterface hint="Interface to be implemented by beans that want to be aware of their bean name in a bean factory.
				Note that it is not usually recommended that an object depend on its bean name, as this represents a
				potentially brittle dependence on external configuration, as well as a possibly unnecessary dependence on a ColdSpring API.">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="setBeanName" hint="Set the name of the bean in the bean factory that created this bean.<br/>
			Invoked after population of normal bean properties but before an a custom init-method."
			access="public" returntype="void" output="false">
	<cfargument name="name" hint="the name of the bean in the factory.
							Note that this name is the actual bean name used in the factory,
							which may differ from the originally specified name" type="string" required="Yes">
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfinterface>