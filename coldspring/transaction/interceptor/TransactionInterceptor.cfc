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

<cfcomponent hint="MethodInterceptor for declarative transaction management using &lt;cftransaction&gt;. <br/>Also allows for nested AOP based transactions in CF8." implements="coldspring.aop.MethodInterceptor" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="TransactionInterceptor" output="false">
	<cfscript>
		setTransactionLocal(createObject("java", "java.lang.ThreadLocal").init());

		return this;
	</cfscript>
</cffunction>

<cffunction name="invokeMethod" hint="Invoke the method, from within a transaction block, unless already in a transaction block." access="public" returntype="any" output="false">
	<cfargument name="methodInvocation" type="coldspring.aop.MethodInvocation" hint="the method invocation joinpoint" required="yes" />
	<cfset var local = {} />

	<cfif getInTransaction()>
		<cfset local.return = arguments.methodInvocation.proceed() />
	<cfelse>
			<cfset getTransactionLocal().set(true) />
			<cftry>
				<cfscript>
					local.attribs = {};

					if(hasIsolation())
					{
						local.attribs.isolation = getIsolation();
					}
                </cfscript>

				<cftransaction attributecollection="#local.attribs#">
					<cfset local.return = arguments.methodInvocation.proceed() />
				</cftransaction>

				<cfcatch>
					<cfset getTransactionLocal().set(false) />
					<cfrethrow>
				</cfcatch>
			</cftry>
		<cfset getTransactionLocal().set(false) />
	</cfif>
	<cfif StructKeyExists(local, "return")>
		<cfreturn local.return />
	</cfif>
</cffunction>

<cffunction name="getInTransaction" hint="returns if we are in a transaction" access="public" returntype="boolean" output="false">
	<cfscript>
		var local = StructNew();
		local.in = getTransactionLocal().get();

		if(NOT StructKeyExists(local, "in"))
		{
			getTransactionLocal().set(false);
			return getTransactionLocal().get();
		}

		return local.in;
	</cfscript>
</cffunction>

<cffunction name="getIsolation" hint="set Isolation level of the transaction to be applied" access="public" returntype="string" output="false">
	<cfreturn instance.isolation />
</cffunction>

<cffunction name="setIsolation" hint="Set the isolation level of the current transaction being applied.
			<br/>Note that when using nested transactions, the isolation level of the outer-most transaction is used."
			access="public" returntype="void" output="false">
	<cfargument name="isolation" type="string" required="true">
	<cfset instance.isolation = arguments.isolation />
</cffunction>

<cffunction name="hasIsolation" hint="whether this object has a isolation value" access="public" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "isolation") />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="getTransactionLocal" access="private" returntype="any" output="false">
	<cfreturn instance.transactionLocal />
</cffunction>

<cffunction name="setTransactionLocal" access="private" returntype="void" output="false">
	<cfargument name="transactionLocal" type="any" required="true">
	<cfset instance.transactionLocal = arguments.transactionLocal />
</cffunction>

</cfcomponent>