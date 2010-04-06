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

<cfcomponent hint="Implementation of Observable for BeanPostProcessors, as their notifyUpdate requires the pass through of possible wrapper bean instances" extends="coldspring.util.Observable" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	instance.static.BEFORE_EVENT_METHOD = "postProcessBeforeInitialization";
	instance.static.AFTER_EVENT_METHOD = "postProcessAfterInitialization";
</cfscript>


<cffunction name="init" hint="Constructor" access="public" returntype="BeanPostProcessorObservable" output="false">
	<cfscript>
		super.init();

		removeOnMissingMethod();

		return this;
	</cfscript>
</cffunction>

<cffunction name="notifyBeforeUpdate" hint="Fire postProcessBeforeInitialization() on all the observers that are currently registered. Stops if null is returned from a observer."
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn notifyUpdate(instance.static.BEFORE_EVENT_METHOD, arguments.bean, arguments.beanName) />
</cffunction>

<cffunction name="notifyAfterUpdate" hint="Stops if null is returned from a observer."
			access="public" returntype="any" output="false">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfreturn notifyUpdate(instance.static.AFTER_EVENT_METHOD, arguments.bean, arguments.beanName) />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction	name="onMissingMethod" access="private" returntype="any" output="false" hint="Removed from implementation">
	<cfargument	name="missingMethodName" type="string"	required="true"	hint=""	/>
	<cfargument	name="missingMethodArguments" type="struct" required="true"	hint=""/>
</cffunction>

<cffunction	name="notifyUpdate" access="private" returntype="any" output="false" hint="notify all observers, with the post processor rules">
	<cfargument name="methodName" hint="the name of the method to invoke" type="string" required="Yes">
	<cfargument name="bean" hint="the new bean instance" type="any" required="Yes">
	<cfargument name="beanName" hint="the name of the bean" type="string" required="Yes">
	<cfscript>
		var local = {};
		var collection = 0;
		var observer = 0;
		var method = arguments.methodName;
		var args = {
			bean = arguments.bean
			,beanName = arguments.beanName
		};
    </cfscript>
	<cflock name="coldspring.util.Observer.#getSystem().identityHashCode(this)#" type="readonly" timeout="60">
		<cfset collection = getCollection()>
		<cfloop array="#collection#" index="observer">
			<cfinvoke component="#observer#" method="#method#" argumentcollection="#args#" returnvariable="local.return">
			<cfscript>
				if(structKeyExists(local, "return"))
				{
					args.bean = local.return;
				}
				else
				{
					return args.bean;
				}
            </cfscript>
		</cfloop>
	</cflock>
	<cfscript>
		return args.bean;
    </cfscript>
</cffunction>

</cfcomponent>