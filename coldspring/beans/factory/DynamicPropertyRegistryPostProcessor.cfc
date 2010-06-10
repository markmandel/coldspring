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

<cfcomponent hint="Post processor that manages converting dynamic properties to their real values" implements="coldspring.beans.factory.config.BeanDefinitionRegistryPostProcessor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="DynamicPropertyRegistryPostProcessor" output="false">
	<cfargument name="dynamicProperties" hint="A struct of key value pairs, for which the keys will be used to translate '${key}' string values in BeanDefinitions properties into their corresponding values."
				type="struct" required="yes">
	<cfscript>
		setDynamicProperties(arguments.dynamicProperties);

		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeanDefinitionRegistry" hint="Modify the application context's internal bean definition registry after its standard initialization.
			All regular bean definitions will have been loaded, but no beans will have been instantiated yet, or will autowiring have been configured.
			This allows for adding further bean definitions before the next post-processing phase kicks in." access="public" returntype="void" output="false">
	<cfargument name="registry" type="coldspring.beans.BeanDefinitionRegistry" required="yes" />
	<cfscript>
		var names = arguments.registry.getBeanDefinitionNames();
		var id = 0;
		var propertyStringResolver = createObject("component", "PropertyStringResolver").init(getDynamicProperties());
		var beanVisitor = createObject("component", "coldspring.beans.factory.config.BeanDefinitionVisitor").init(propertyStringResolver);
		var beanDef = 0;
    </cfscript>
	<cfloop array="#names#" index="id">
		<cfscript>
			beanDef = arguments.registry.getBeanDefinition(id);
			beanVisitor.visitBeanDefinition(beanDef);
        </cfscript>
	</cfloop>
</cffunction>

<cffunction name="getDynamicProperties" access="public" returntype="struct" output="false">
	<cfreturn instance.dynamicProperties />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="setDynamicProperties" access="private" returntype="void" output="false">
	<cfargument name="dynamicProperties" type="struct" required="true">
	<cfset instance.dynamicProperties = arguments.dynamicProperties />
</cffunction>

</cfcomponent>