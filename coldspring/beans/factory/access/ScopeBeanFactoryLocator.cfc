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

<cfcomponent hint="BeanFactoryLocator that stores and retrieves a BeanFactory from a shared scope, under a given name"
			 implements="coldspring.beans.factory.config.BeanFactoryPostProcessor,BeanFactoryLocator" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ScopeBeanFactoryLocator" output="false">
	<cfscript>
		setBeanFactoryName("coldspring");
		setBeanFactoryScope("application");
		return this;
	</cfscript>
</cffunction>

<cffunction name="getInstance" hint="Returns the instance of the bean factory that has been set under the given scope, and given bean factory name."
			access="public" returntype="coldspring.beans.BeanFactory" output="false">
	<cfscript>
		var scope = getScope();
		return scope[getBeanFactoryName()];
    </cfscript>
</cffunction>

<cffunction name="hasInstance" hint="Whether or not an instance of the bean factory exists in the given scope underthe given name" access="public" returntype="boolean" output="false">
	<cfscript>
		var scope = getScope();
		return structKeyExists(scope, getBeanFactoryName());
    </cfscript>
</cffunction>

<cffunction name="setBeanFactory" hint="Stores the beanFactory in the given scope, under the configured bean factory name" access="public" returntype="void" output="false">
	<cfargument name="beanFactory" hint="the bean factory to set" type="coldspring.beans.BeanFactory" required="Yes">
	<cfscript>
	    var scope = getScope();
		scope[getBeanFactoryName()] = arguments.beanFactory;
    </cfscript>
</cffunction>

<cffunction name="getBeanFactoryName" hint="Get the key value that the BeanFactory is stored under. If not set explicitely, it defaults to 'coldspring'"
			access="public" returntype="string" output="false">
	<cfreturn instance.beanFactoryName />
</cffunction>

<cffunction name="setBeanFactoryName" access="public" returntype="void" output="false">
	<cfargument name="beanFactoryName" type="string" required="true">
	<cfset instance.beanFactoryName = arguments.beanFactoryName />
</cffunction>

<cffunction name="getBeanFactoryScope" hint="Get the text representation of the bean factory scope. i.e. application, session, server, request.
			If not set explicitely, defaults to 'application'"
			access="public" returntype="any" output="false">
	<cfreturn instance.beanFactoryScope />
</cffunction>

<cffunction name="setBeanFactoryScope" access="public" returntype="void" output="false">
	<cfargument name="beanFactoryScope" type="any" required="true">
	<cfset instance.beanFactoryScope = arguments.beanFactoryScope />
</cffunction>

<cffunction name="postProcessBeanFactory" hint="Take the current beanFactory, and store it in the given scope and name."
			access="public" returntype="void" output="false">
	<cfargument name="beanFactory" hint="" type="coldspring.beans.BeanFactory" required="Yes">
	<cfscript>
		setBeanFactory(arguments.beanFactory);
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getScope" hint="get the scope as set in this locator" access="private" returntype="struct" output="false">
	<cfscript>
		switch(getBeanFactoryScope())
		{
			case "application":
				return application;
			break;

			case "server":
				return server;
			break;

			case "session":
				return session;
			break;

			case "request":
				return request;
			break;
		}

		createObject("component", "coldspring.beans.factory.access.exception.InvalidScopeException").init(getBeanFactoryScope());
    </cfscript>
</cffunction>

</cfcomponent>