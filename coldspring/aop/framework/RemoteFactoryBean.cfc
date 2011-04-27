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

<cfcomponent extends="ProxyFactoryBean" implements="coldspring.beans.factory.BeanNameAware" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="RemoteFactoryBean" output="false">
	<cfscript>
		super.init();
		setProxyGenerated(false);
		setAddMissingMethods(ArrayNew(1));
		setRemoteMethodNames(ArrayNew(1));
		setTrustedSource(false);

		return this;
	</cfscript>
</cffunction>

<cffunction name="getObject" hint="Returns a proxy if there are interceptorNames applied. Otherwise, this returns the target object."
			access="public" returntype="any" output="false">
	<cfscript>
		if(!isProxyGenerated() && !checkTrustedSource())
		{
			buildRemoteProxy();
		}

		if(!hasInterceptorNames())
		{
			return getTarget();
		}

		return super.getObject();
    </cfscript>
</cffunction>

<cffunction name="getServiceName" hint="Get the name of the CFC that is generated as the remote facade." access="public" returntype="string" output="false">
	<cfreturn instance.serviceName />
</cffunction>

<cffunction name="setServiceName" hint="Set the name of the CFC that will be generated as the Remote Proxy." access="public" returntype="void" output="false">
	<cfargument name="serviceName" type="string" required="true">
	<cfset instance.serviceName = arguments.serviceName />
</cffunction>

<cffunction name="setRelativePath" hint="Set the relative path to the directory that the Service Remote Proxy will be generated to.
			Automatically populates the absolute path with expandpath()"
			access="public" returntype="void" output="false">
	<cfargument name="relativePath" type="string" required="true">
	<cfset setAbsolutePath(expandPath(arguments.relativePath)) />
</cffunction>

<cffunction name="getAbsolutePath" hint="Get the absolute path to the directory that the Service Remote Proxy is generated to." access="public" returntype="string" output="false">
	<cfreturn instance.absolutePath />
</cffunction>

<cffunction name="setAbsolutePath" hint="Set the absolute path to the directory that the Service Remote Proxy will be generated to." access="public" returntype="void" output="false">
	<cfargument name="absolutePath" type="string" required="true">
	<cfset instance.absolutePath = arguments.absolutePath />
</cffunction>

<cffunction name="getRemoteMethodNames" hint="Get the remote names to expose on the remote proxy." access="public" returntype="array" output="false">
	<cfreturn instance.remoteMethodNames />
</cffunction>

<cffunction name="setRemoteMethodNames" hint="Set the remote names to expose on the remote proxy." access="public" returntype="void" output="false">
	<cfargument name="remoteMethodNames" hint="List or array of the method names that need to be applied to the remote proxy" type="any" required="true">
	<cfscript>
		if(isSimpleValue(arguments.remoteMethodNames))
		{
			arguments.remoteMethodNames = listToArray(arguments.remoteMethodNames);
		}

		instance.remoteMethodNames = arguments.remoteMethodNames;
    </cfscript>
</cffunction>

<cffunction name="getBeanFactoryName" hint="Get the bame of the bean factory to be used in the application scope." access="public" returntype="string" output="false">
	<cfreturn instance.beanFactoryName />
</cffunction>

<cffunction name="setBeanFactoryName" hint="Set the bame of the bean factory to be used in the application scope." access="public" returntype="void" output="false">
	<cfargument name="beanFactoryName" hint="The key used for the bean factory in the application scope" type="string" required="true">
	<cfset instance.beanFactoryName = arguments.beanFactoryName />
</cffunction>

<cffunction name="getAddMissingMethods" hint="List of non-existent methods that are to be implemented as remote methods on the remote facade" access="public" returntype="array" output="false">
	<cfreturn instance.addMissingMethods />
</cffunction>

<cffunction name="setAddMissingMethods" hint="List of non-existent methods that are to be implemented as remote methods on the remote facade"
			access="public" returntype="void" output="false">
	<cfargument name="addMissingMethods" hint="List or array of method names" type="any" required="true">
	<cfscript>
		if(isSimpleValue(arguments.addMissingMethods))
		{
			arguments.addMissingMethods = listToArray(arguments.addMissingMethods);
		}

		instance.addMissingMethods = arguments.addMissingMethods;
    </cfscript>
</cffunction>

<cffunction name="setBeanName" hint="set the bean name as it is stored in the BeanFactory." access="public" returntype="void" output="false">
	<cfargument name="name" type="string" required="true">
	<cfset instance.beanName = arguments.name />
</cffunction>

<cffunction name="isTrustedSource" hint="Whether or not the remote proxy should be re-generated if it already exists." access="public" returntype="boolean" output="false">
	<cfreturn instance.trustedSource />
</cffunction>

<cffunction name="setTrustedSource" hint="Set whether or not the remote proxy should be re-generated if it already exists. Defaults to false (always regenerate)." access="public" returntype="void" output="false">
	<cfargument name="trustedSource" type="boolean" required="true">
	<cfset instance.trustedSource = arguments.trustedSource />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="checkTrustedSource" hint="If the source is trusted, checks to see if the file is there or not" access="public" returntype="boolean" output="false">
	<cfscript>
		if(!isTrustedSource())
		{
			return false;
		}

		return fileExists(getAbsolutePath() & "/" & getServiceName() & ".cfc");
    </cfscript>
</cffunction>

<cffunction name="buildRemoteProxy" hint="builds the remote proxy and puts it in place" access="public" returntype="void" output="false">
	<cfscript>
		var path = getAbsolutePath() & "/" & getServiceName() & ".cfc";
		var locator = createObject("component", "coldspring.beans.factory.access.ScopeBeanFactoryLocator").init();
		var reflectionService = getComponentMetadata("coldspring.core.reflect.ReflectionService").singleton.instance;
		var class = reflectionService.loadClass(getMetaData(getTarget()).name);
		var method = 0;
		var methodName = 0;
		var remoteMethods = [];
		var functionBuilder = createObject("component", "coldspring.aop.util.FunctionBuilder").init();
		var template = 0;
		//since we're a bean factory, we get moved to the & spot.
		var beanName = replaceNoCase(getBeanName(), "&", "");

		//in application scope
		locator.setBeanFactoryName(getBeanFactoryName());
		locator.setBeanFactoryScope("application");

		locator.setBeanFactory(getBeanFactory());

	</cfscript>

	<!--- I hate CF8 syntax. build methods --->
	<cfloop array="#getRemoteMethodNames()#" index="methodName">
		<cfscript>
			method = class.getMethod(methodName).clone();
			method.getMeta().access = "remote";
			ArrayAppend(remoteMethods, method);
        </cfscript>
	</cfloop>

	<cfloop array="#getAddMissingMethods()#" index="methodName">
		<cfscript>
			method = class.getMethod(methodName).clone();
			method.getMeta().access = "remote";
			ArrayAppend(remoteMethods, method);
        </cfscript>
	</cfloop>

	<cfloop array="#remoteMethods#" index="method">
		<cfscript>
			functionBuilder.writeCopyOpenFunction(method);

				functionBuilder.append("<cfreturn ");
				functionBuilder.append("getTarget().#method.getName()#(argumentCollection=arguments)");
				functionBuilder.writeLine(" >");

			functionBuilder.writeFunctionClose();
        </cfscript>
	</cfloop>

	<cfscript>
		//get template
		template = fileRead(GetDirectoryFromPath(getMetaData(this).path) & "/templates/RemoteProxyBean.template");
		template = replaceNoCase(template, "{beanName}", beanName, "all");
		template = replaceNoCase(template, "{beanFactoryName}", getBeanFactoryName(), "all");
		template = replaceNoCase(template, "{beanScope}", "application", "all");
		template = replaceNoCase(template, "{functions}", functionBuilder.$toString());

		//delete it just before re-writing it, for smallest lag
		if(fileExists(path))
		{
			fileDelete(path);
		}

		//write template
		fileWrite("#getAbsolutePath()#/#getServiceName()#.cfc", template);
    </cfscript>
</cffunction>

<cffunction name="isProxyGenerated" access="private" returntype="boolean" output="false">
	<cfreturn instance.isProxyGenerated />
</cffunction>

<cffunction name="setProxyGenerated" access="private" returntype="void" output="false">
	<cfargument name="isProxyGenerated" type="boolean" required="true">
	<cfset instance.isProxyGenerated = arguments.isProxyGenerated />
</cffunction>

<cffunction name="getBeanName" access="private" returntype="string" output="false">
	<cfreturn instance.beanName />
</cffunction>

</cfcomponent>