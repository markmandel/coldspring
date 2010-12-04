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

<cfcomponent hint="Pointcut that can match against a wide variety of execution joinpoints, including package, method name, return types, etc" implements="coldspring.aop.Pointcut" output="false">

<cfscript>
	meta = getMetadata(this);
	if(!StructKeyExists(meta, "const"))
	{
		const = {};
		const.ANY = "*";
		const.NONE = "";

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ExecutionPointcut" output="false">
	<cfscript>
		setInstanceType(meta.const.ANY);
		setSubPackage(meta.const.ANY);
		setPackage(meta.const.ANY);

		setCFCMetaUtil(getComponentMetadata("coldspring.util.CFCMetaUtil").singleton.instance);

		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Can the current set of metadata match the execution pointcut that has been defined here?" access="public" returntype="boolean" output="false">
	<cfargument name="methodMetadata" type="struct" required="yes" />
	<cfargument name="classMetadata" type="struct" required="yes" />

	<cfscript>
		return (matchInstanceType(arguments.methodMetadata, arguments.classMetadata)
				AND
				matchSubPackage(arguments.methodMetadata, arguments.classMetadata)
				AND
				matchPackage(arguments.methodMetadata, arguments.classMetadata)
				);
    </cfscript>
</cffunction>

<cffunction name="getInstanceType" access="public" returntype="string" output="false">
	<cfreturn instance.instanceType />
</cffunction>

<cffunction name="setInstanceType" access="public" hint="The class/interface type that the class meta data must match to" returntype="void" output="false">
	<cfargument name="instanceType" type="string" required="true">
	<cfset instance.instanceType = arguments.instanceType />
</cffunction>

<cffunction name="getSubPackage" access="public" returntype="string" output="false">
	<cfreturn instance.subPackage />
</cffunction>

<cffunction name="setSubPackage" access="public" hint="Set the package that the class type must be part of, or of a sub package of" returntype="void" output="false">
	<cfargument name="subPackage" type="string" required="true">
	<cfset instance.subPackage = lcase(arguments.subPackage) />
</cffunction>

<cffunction name="getPackage" access="public" returntype="string" output="false">
	<cfreturn instance.package />
</cffunction>

<cffunction name="setPackage" hint="set the package that the class must match explicitly" access="public" returntype="void" output="false">
	<cfargument name="package" type="string" required="true">
	<cfset instance.package = arguments.package />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="matchInstanceType" hint="Can the currently class instance type be assigned to the provided class / interface" access="private" returntype="boolean" output="false">
	<cfargument name="methodMetadata" type="struct" required="yes" />
	<cfargument name="classMetadata" type="struct" required="yes" />

	<cfscript>
		if(getInstanceType() == meta.const.NONE)
		{
			return false;
		}
		else if(getInstanceType() == meta.const.ANY)
		{
			return true;
		}

		return getCFCMetaUtil().isAssignableFrom(arguments.classMetadata.name, getInstanceType());
    </cfscript>
</cffunction>

<cffunction name="matchSubPackage" hint="Does the package that the class type must be part of, or of a sub package of match" access="private" returntype="boolean" output="false">
	<cfargument name="methodMetadata" type="struct" required="yes" />
	<cfargument name="classMetadata" type="struct" required="yes" />
	<cfscript>
		var package = 0;
		if(getSubPackage() == meta.const.NONE)
		{
			return false;
		}
		else if(getSubPackage() == meta.const.ANY)
		{
			return true;
		}
		else
		{
			package = getCFCMetaUtil().getPackage(arguments.classMetadata.name);

			return Lcase(package).startsWith(getSubPackage());
		}
    </cfscript>
</cffunction>

<cffunction name="matchPackage" hint="Does the package that the class type match our set package?" access="private" returntype="boolean" output="false">
	<cfargument name="methodMetadata" type="struct" required="yes" />
	<cfargument name="classMetadata" type="struct" required="yes" />
	<cfscript>
		var package = 0;
		if(getPackage() == meta.const.NONE)
		{
			return false;
		}
		else if(getPackage() == meta.const.ANY)
		{
			return true;
		}
		else
		{
			package = getCFCMetaUtil().getPackage(arguments.classMetadata.name);

			return package eq getPackage();
		}
    </cfscript>
</cffunction>

<cffunction name="getCFCMetaUtil" access="private" returntype="coldspring.util.CFCMetaUtil" output="false">
	<cfreturn instance.cfcMetaUtil />
</cffunction>

<cffunction name="setCFCMetaUtil" access="private" returntype="void" output="false">
	<cfargument name="cfcMetaUtil" type="coldspring.util.CFCMetaUtil" required="true">
	<cfset instance.cfcMetaUtil = arguments.cfcMetaUtil />
</cffunction>

</cfcomponent>