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
<cfcomponent hint="Pointcut specifically for matching either class or function level annotations. <br/>
		For both classAnnotations and Method annotations, the key in the structure is the annotation name to match against,
		and the value is the value the annotation should be set to.<br/>
		If the value is '*', the check will only be that the annotation exists (i.e. any value)"
		implements="coldspring.aop.Pointcut" output="false">

<cfscript>
	meta = getMetadata(this);

	if(!structKeyExists(meta, "const"))
	{
		const =
		{
			WILDCARD = "*"
			,CLASS_MATCHES_CLOSURE = createObject("component", "coldspring.util.Closure").init(checkClassForAnnotation)
		};

		const.CLASS_MATCHES_CLOSURE.bind("WILDCARD", const.WILDCARD);

		meta.const = const;
	}
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="AnnotationPointcut" output="false">
	<cfscript>
		setClassAnnotations(StructNew());
		setMethodAnnotations(StructNew());

		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Does given method, for the given class, match for this pointcut" access="public" returntype="boolean" output="false">
	<cfargument name="methodMetadata" type="struct" required="yes" />
	<cfargument name="classMetadata" type="struct" required="yes" />
	<cfscript>
		var annotation = 0;
		var args = {};
		var cfcMetaUtil = 0;
		var annotations = getMethodAnnotations();

		for(annotation in getMethodAnnotations())
		{
			if(structKeyExists(arguments.methodMetadata, annotation)
				AND
				(
					annotations[annotation] == meta.const.WILDCARD
					||
					annotations[annotation] == arguments.methodMetadata[annotation]
				)
			)
			{
				return true;
			}
		}

		//result in struct for pass by ref
		args.result.result = false;
		args.annotations = getClassAnnotations();

		//need to define this first, dunno why, cf doesn't like me calling methods on meta data based singletons.
		cfcMetaUtil = getComponentMetadata("coldspring.util.CFCMetaUtil").singleton.instance;
		cfcMetaUtil.eachClassInTypeHierarchy(arguments.classMetadata.name, meta.const.CLASS_MATCHES_CLOSURE, args);

		return args.result.result;
    </cfscript>

</cffunction>

<cffunction name="getClassAnnotations"
	access="public" returntype="struct" output="false" colddoc:generic="string,string">
	<cfreturn instance.classAnnotations />
</cffunction>

<cffunction name="setClassAnnotations" hint="Key value pair of annotations on a CFC to look for."
	access="public" returntype="void" output="false">
	<cfargument name="classAnnotations" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.classAnnotations = arguments.classAnnotations />
</cffunction>

<cffunction name="getMethodAnnotations" access="public" returntype="struct" output="false" colddoc:generic="string,string">
	<cfreturn instance.methodAnnotations />
</cffunction>

<cffunction name="setMethodAnnotations" access="public" returntype="void" output="false">
	<cfargument name="methodAnnotations" type="struct" required="true" colddoc:generic="string,string">
	<cfset instance.methodAnnotations = arguments.methodAnnotations />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<!--- closure function --->

<cffunction name="checkClassForAnnotation" hint="closure method for checking a class for a given annotation" access="public" returntype="boolean" output="false">
	<cfargument name="className" hint="the class name" type="string" required="Yes">
	<cfargument name="annotations" hint="the annotations to check" type="struct" required="Yes" colddoc:generic="string,string">
	<cfscript>
		var meta = getComponentMetadata(arguments.className);
		var annotation = 0;

		//loop around and do stuff
		var annotation = 0;
		var args = {};

		for(annotation in arguments.annotations)
		{
			if(structKeyExists(meta, annotation)
				AND
				(
					arguments.annotations[annotation] == variables.WILDCARD
					||
					arguments.annotations[annotation] == meta[annotation]
				)
			)
			{
				arguments.result.result = true;

				//break out
				return false;
			}
		}

		return true;
    </cfscript>
</cffunction>

<!--- /closure functions --->

</cfcomponent>