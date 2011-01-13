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

<cfcomponent hint="Pointcut that takes a AOP expression and matches against it" implements="coldspring.aop.Pointcut" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cffunction name="init" hint="Constructor" access="public" returntype="ExpressionPointcut" output="false">
	<cfscript>
		//make sure the Expression Parser singleton has been created
		var singleton = getComponentMetadata("coldspring.util.Singleton").singleton.instance;
		singleton.createInstance("coldspring.aop.expression.ExpressionParser");

		return this;
	</cfscript>
</cffunction>

<cffunction name="matches" hint="Does given method, for the given class, match for this pointcut" access="public" returntype="boolean" output="false">
	<cfargument name="method" hint="The method to match" type="coldspring.core.reflect.Method" required="Yes">
	<cfargument name="class" hint="The class to match" type="coldspring.core.reflect.Class" required="Yes">
	<!---
	we do this here, as if we build the pointcut in the setExpression property
	if somethign goes wrong it gets swallowed by setter injection catches.
	 --->
	<cfset buildExpressionPointcut()>
	<cfreturn getExpressionPointcut().matches(arguments.method, arguments.class) />
</cffunction>

<cffunction name="getExpression" hint="get the AOP Expression to define this pointcut" access="public" returntype="string" output="false">
	<cfreturn instance.expression />
</cffunction>

<cffunction name="setExpression" hint="set the AOP Expression to define this pointcut" access="public" returntype="void" output="false">
	<cfargument name="expression" type="string" required="true">
	<cfset instance.expression = arguments.expression />
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="buildExpressionPointcut" hint="builds the composite pointcut if it hasn't been built before" access="public" returntype="void" output="false">
	<cfscript>
		var parser = 0;
    </cfscript>
	<cfif !hasExpressionPointcut()>
    	<cflock name="coldspring.aop.expression.ExpressionPointcut.buildExpressionPointcut.#createObject('java', 'java.lang.System').identityHashCode(this)#" throwontimeout="true" timeout="60">
    	<cfscript>
    		if(!hasExpressionPointcut())
    		{
				parser = getComponentMetadata("coldspring.aop.expression.ExpressionParser").singleton.instance;
				setexpressionPointcut(parser.parse(getExpression()));
    		}
    	</cfscript>
    	</cflock>
    </cfif>
</cffunction>

<cffunction name="getExpressionPointcut" access="private" returntype="coldspring.aop.Pointcut" output="false">
	<cfreturn instance.expressionPointcut />
</cffunction>

<cffunction name="setExpressionPointcut" access="private" returntype="void" output="false">
	<cfargument name="expressionPointcut" type="coldspring.aop.Pointcut" required="true">
	<cfset instance.expressionPointcut = arguments.expressionPointcut />
</cffunction>

<cffunction name="hasExpressionPointcut" hint="whether this object has a ExpressionPointcut" access="private" returntype="boolean" output="false">
	<cfreturn StructKeyExists(instance, "expressionPointcut") />
</cffunction>

</cfcomponent>