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
<cfcomponent hint="Parser for expressions that returns a CompositePointcut" output="false">

<!------------------------------------------- PUBLIC ------------------------------------------->

<cfscript>
	instance.static = {};

	instance.static.CLASS_ANNOTATION = "@target";
	instance.static.METHOD_ANNOTATION = "@annotation";
</cfscript>

<!---
TODO:
	Error handling
	Should <aop:aspect ref> be required?
	Unsupported Exception - for * and private, and for bean()
	throw an error on MethodInvocationAdvice if the adviecType is not 'before,afterReturning,around,throws'
 --->

<cffunction name="init" hint="Constructor" access="public" returntype="ExpressionParser" output="false">
	<cfscript>
		var singleton = createObject("component", "Singleton").init();

		return singleton.createInstance(getMetaData(this).name);
	</cfscript>
</cffunction>

<cffunction name="configure" hint="configure method for singleton setup" access="public" returntype="void" output="false">
	<cfscript>
		setJavaLoader(getComponentMetadata("coldspring.util.java.JavaLoader").singleton.instance);
    </cfscript>
</cffunction>

<cffunction name="parse" hint="parse an expression, and return an appropriate pointcut" access="public" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="expression" hint="the expression to parse" type="string" required="Yes">
	<cfscript>
		var stream = getJavaLoader().create("org.antlr.runtime.ANTLRStringStream").init(arguments.expression);
		var lexer = getJavaLoader().create("com.coldspring.aop.expression.AopExpressionLexer").init(stream);
		var tokens = getJavaLoader().create("org.antlr.runtime.TokenRewriteStream").init(lexer);

		var parser = getJavaLoader().create("com.coldspring.aop.expression.AopExpressionParser").init(tokens);

		var result = parser.prog();

		var tree = result.getTree();

		//then we know we only have 1 element, and it's not negated, no point creating a composite
		if(tree.getType() > 0)
		{
			return parseSingleExpression(tree, parser);
		}
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->


<cffunction name="parseSingleExpression" hint="parses a single expression, and returns a pointcut" access="public" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="tree" hint="the AST" type="any" required="Yes">
	<cfargument name="parser" hint="the parser in question. Useful for constants" type="any" required="Yes">
	<cfscript>
		if(tree.getType() eq parser.ANNOTATION_EXPRESSION_TYPE)
		{
			return parseAnnotation(arguments.tree, arguments.parser);
		}
    </cfscript>
</cffunction>

<cffunction name="parseAnnotation" hint="parses an annotation pointcut - @target or @annotation" access="public" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="tree" hint="the AST" type="any" required="Yes">
	<cfargument name="parser" hint="the parser in question. Useful for constants" type="any" required="Yes">
	<cfscript>
		var pointcut = createObject("component", "coldspring.aop.support.AnnotationPointcut").init();
		var annotation = {};
		var value = "*";

		if(arguments.tree.getChildCount() == 2)
		{
			value = arguments.tree.getChild(1).getText();
		}

		annotation[arguments.tree.getChild(0).getText()] = value;

		if(arguments.tree.getText() eq instance.static.METHOD_ANNOTATION)
		{
			pointcut.setMethodAnnotations(annotation);
		}
		else if(arguments.tree.getText() eq instance.static.CLASS_ANNOTATION)
		{
			pointcut.setClassAnnotations(annotation);
		}

		return pointcut;
    </cfscript>
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldspring.util.java.JavaLoader" output="false">
	<cfreturn instance.JavaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="JavaLoader" type="coldspring.util.java.JavaLoader" required="true">
	<cfset instance.JavaLoader = arguments.JavaLoader />
</cffunction>

<cffunction name="htmlDisplayTree" hint="walks the tree, and makes a string" access="private" returntype="string" output="false">
	<cfargument name="tree" hint="The tree node to walk" type="any" required="Yes">
	<cfargument name="level" hint="" type="numeric" required="No" default="0">
	<cfscript>
		var child = 0;
		var counter = 0;
		var padding = RepeatString("&nbsp;&nbsp;&nbsp;", arguments.level);
		var str = "<br/>"& padding &"{<br/>" & padding & "[" & arguments.level & "] " & arguments.tree.getText();

		for(; counter lt arguments.tree.getChildCount(); counter = counter + 1)
		{
			child = arguments.tree.getChild(JavaCast("int", counter));
			str = str & htmlDisplayTree(child, arguments.level + 1);
		}

		str = str & "<br/>"& padding &"}<br/>";

		return str;
	</cfscript>
</cffunction>

</cfcomponent>