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

<cfcomponent hint="BeanDefinitionRegistry Post Processor that does the work to enable FactoryBeans to work" implements="coldspring.beans.factory.config.BeanDefinitionRegistryPostProcessor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	reflectionService = getComponentMetaData("coldspring.core.reflect.ReflectionService").singleton.instance;

	instance.static.FACTORYBEAN_CLASS = reflectionService.loadClass("coldspring.beans.factory.FactoryBean");
</cfscript>


<cffunction name="init" hint="Constructor" access="public" returntype="FactoryBeanRegistryPostProcessor" output="false">
	<cfscript>
		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeanDefinitionRegistry" hint="Moves any FactoryBean implementations to &id and puts in a place a newer CFCBeanDefinition that has a FactoryBean and FactoryMethod pointing at it."
			access="public" returntype="void" output="false">
	<cfargument name="registry" type="coldspring.beans.BeanDefinitionRegistry" required="yes" />
	<cfscript>
		var names = arguments.registry.getBeanDefinitionNames();
		var beanDefinition = 0;
		var id = 0;
		var childBeanDefinition = 0;
		var factoryBean = 0;
    </cfscript>
	<cfloop array="#names#" index="id">
		<cfscript>
			beanDefinition = arguments.registry.getBeanDefinition(id);

			if(beanDefinition.hasClassName() AND instance.static.FACTORYBEAN_CLASS.isAssignableFrom(beanDefinition.getClassName()))
			{
				arguments.registry.removeBeanDefinition(id);

				beanDefinition.setID("&" & id);

				arguments.registry.registerBeanDefinition(beanDefinition);

				childBeanDefinition = createObject("component", "coldspring.beans.support.CFCBeanDefinition").init(id, arguments.registry);

				//create an instance of the factory bean, so we can get the type
				factoryBean = createObject("component", beanDefinition.getClassName()).init();

				if(NOT factoryBean.isSingleton())
				{
					childBeanDefinition.setScope("prototype");
				}

				if(Len(factoryBean.getObjectType()))
				{
					childBeanDefinition.setClassName(factoryBean.getObjectType());
				}

				childBeanDefinition.setFactoryMethodName("getObject");
				childBeanDefinition.setFactoryBeanName(beanDefinition.getID());

				arguments.registry.registerBeanDefinition(childBeanDefinition);
			}
        </cfscript>
	</cfloop>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

</cfcomponent>