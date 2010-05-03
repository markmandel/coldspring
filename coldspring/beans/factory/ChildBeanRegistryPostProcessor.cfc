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

<cfcomponent hint="Post processor for handling beans with 'parent' attributes" implements="coldspring.beans.BeanDefinitionRegistryPostProcessor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ChildBeanRegistryPostProcessor" output="false">
	<cfscript>
		setProcessed(structNew());

		return this;
	</cfscript>
</cffunction>

<cffunction name="postProcessBeanDefinitionRegistry" hint="If the beans has a parent name, then clone the parent, and merge in the child, and replace the bean definition"
			access="public" returntype="void" output="false">
	<cfargument name="registry" hint="the bean definition registry" type="coldspring.beans.BeanDefinitionRegistry" required="yes" />
	<cfscript>
		var names = arguments.registry.getBeanDefinitionNames();
		var beanDefinition = 0;
		var id = 0;
    </cfscript>

	<cfloop array="#names#" index="id">
		<cfscript>
			beanDefinition = arguments.registry.getBeanDefinition(id);

			processChildBeanDefinition(beanDefinition, arguments.registry);
		</cfscript>
	</cfloop>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="processChildBeanDefinition" hint="Processes a bean definition if it is a child, and has yet to be processed. Recurses up to the parent if it is a parent and has yet to be set."
	access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the child bean definition" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfargument name="registry" type="coldspring.beans.BeanDefinitionRegistry" required="yes" />
	<cfscript>
		var parentBeanDefinition = 0;
		var mergedBeanDefinition = 0;
		if(beanDefinition.hasParentName() AND NOT isProcessed(arguments.beanDefinition))
		{
			parentBeanDefinition = arguments.registry.getBeanDefinition(beanDefinition.getParentName());

			//make sure the parent gets processed first
			processChildBeanDefinition(parentBeanDefinition, arguments.registry);

			//get it again, as it may have been replaced
			parentBeanDefinition = arguments.registry.getBeanDefinition(beanDefinition.getParentName());

			//remove the child, as we are going to replace him
			arguments.registry.removeBeanDefinition(arguments.beanDefinition.getID());

			//clone parent, merge with child, and then re-register
			mergedBeanDefinition = parentBeanDefinition.clone();

			mergedBeanDefinition.overrideFrom(arguments.beanDefinition);

			//switch the id on the merged bean to the child's id (overrideFrom won't do this)
			mergedBeanDefinition.setID(arguments.beanDefinition.getID());

			arguments.registry.registerBeanDefinition(mergedBeanDefinition);
		}
    </cfscript>
</cffunction>

<cffunction name="isProcessed" hint="have we processed this bean definition?" access="public" returntype="boolean" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to see if it is processed" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		return structKeyExists(getProcessed(), arguments.beanDefinition.getID());
    </cfscript>
</cffunction>

<cffunction name="markProcessed" hint="mark this bean as being processed" access="private" returntype="void" output="false">
	<cfargument name="beanDefinition" hint="the bean definition to mark as processed" type="coldspring.beans.support.AbstractBeanDefinition" required="Yes">
	<cfscript>
		structInsert(getProcessed(), arguments.beanDefinition.getID(), 1);
    </cfscript>
</cffunction>

<cffunction name="getProcessed" access="private" returntype="struct" output="false">
	<cfreturn instance.processed />
</cffunction>

<cffunction name="setProcessed" access="private" returntype="void" output="false">
	<cfargument name="processed" type="struct" required="true">
	<cfset instance.processed = arguments.processed />
</cffunction>


</cfcomponent>