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
	instance.static.TARGET = "target";
	instance.static.WITHIN = "within";
	instance.static.PUBLIC_SCOPE = "public";
	instance.static.EXPRESSION_DELIMITER = ".";
	instance.static.ANY_ARGUMENTS = "..";
</cfscript>

<!---
TODO:
	Should <aop:aspect ref> be required?
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
		setJavaLoader(getComponentMetadata("coldspring.core.java.JavaLoader").singleton.instance);
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

		checkParserForErrors(arguments.expression, parser);

		//writeOutput(htmlDisplayTree(tree)); abort;

		//then we know we only have 1 element, and it's not negated, no point creating a composite
		if(tree.getType() > 0 && tree.getType() != parser.NOT)
		{
			return parseSingleExpression(arguments.expression, tree, parser);
		}
		else
		{
			return parseCompositeExpression(arguments.expression, tree, parser);
		}
    </cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="checkParserForErrors" hint="check to see if there was an error in parsing, and if so, throw the required exception" access="private" returntype="void" output="false">
	<cfargument name="expression" hint="the original expression" type="string" required="Yes">
	<cfargument name="parser" hint="the parser in question." type="any" required="Yes">
	<cfscript>
		var local = {};
		var errorList = parser.getErrorList();

		if(!arrayIsEmpty(errorList))
		{
			//may be more than 1 error, but we'll deal with 1 at a time for now.
			local.error = errorList[1];
			local.exception = local.error[arguments.parser.EXCEPTION_KEY];
			local.message = local.error[arguments.parser.MESSAGE_KEY];

			createObject("component", "coldspring.aop.expression.exception.InvalidExpressionException").init(arguments.expression, local.exception.line,
																										local.exception.charPositionInLine, local.message);
		}
    </cfscript>
</cffunction>

<cffunction name="parseCompositeExpression" hint="parse multipe expressions that are composite" access="private" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="expression" hint="the original expression" type="string" required="Yes">
	<cfargument name="tree" hint="the AST" type="any" required="Yes">
	<cfargument name="parser" hint="the parser in question. Useful for constants" type="any" required="Yes">
	<cfscript>
		var child = 0;
		var singlePointcut = 0;
		var negate = false;
		var compositePointcut = 0;
		var counter = 1;
		var len = 0;
		var booleanLogic = 0;


		//setup initial pointcut
		if(tree.getType() == parser.NOT)
		{
			negate = true;
		}

		//writeOutput(htmlDisplayTree(arguments.tree));

		singlePointcut = parseSingleExpression(arguments.expression, arguments.tree.getChild(0), arguments.parser);

		compositePointcut = createObject("component", "coldspring.aop.support.CompositePointcut").init(singlePointcut, negate);

		len = arguments.tree.getChildCount();
		for(; counter < len; counter++)
		{
			negate = false;

			child = arguments.tree.getChild(counter);

			//what sort of boolean logic are we using?
			if(child.getType() == parser.AND)
			{
				booleanLogic = "and";
			}
			else if(child.getType() == parser.OR)
			{
				booleanLogic = "or";
			}

			//are we negating?
			if(child.getChild(0).getType() eq arguments.parser.NOT)
			{
				negate = true;

				//pass it down one level
				child = child.getChild(0);
			}

			singlePointcut = parseSingleExpression(arguments.expression, child.getChild(0), arguments.parser);

			switch(booleanLogic)
			{
				case "and":
					compositePointcut.addAndPointcut(singlePointcut, negate);
				break;

				case "or":
					compositePointcut.addOrPointcut(singlePointcut, negate);
				break;
			}
		}

		return compositePointcut;
    </cfscript>
</cffunction>

<cffunction name="parseSingleExpression" hint="parses a single expression, and returns a pointcut" access="private" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="expression" hint="the original expression" type="string" required="Yes">
	<cfargument name="tree" hint="the AST" type="any" required="Yes">
	<cfargument name="parser" hint="the parser in question. Useful for constants" type="any" required="Yes">
	<cfscript>
		if(tree.getType() eq parser.ANNOTATION_EXPRESSION_TYPE)
		{
			return parseAnnotation(arguments.tree, arguments.parser);
		}
		else if(tree.getType() eq parser.EXPRESSION_TYPE)
		{
			//target, within, bean (bean not supported right now)
			if(arguments.tree.getText() eq instance.static.TARGET)
			{
				return parseTarget(arguments.tree, arguments.parser);
			}
			else if(arguments.tree.getText() eq instance.static.WITHIN)
			{
				return parseWithin(arguments.expression, arguments.tree, arguments.parser);
			}
		}
		else if(tree.getType() eq parser.EXECUTION_EXPRESSION_TYPE)
		{
			return parseExecution(arguments.expression, arguments.tree, arguments.parser);
		}
    </cfscript>
</cffunction>

<cffunction name="parseExecution" hint="parses an execution pointcut - execution()" access="private" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="expression" hint="the original expression" type="string" required="Yes">
	<cfargument name="tree" hint="the AST" type="any" required="Yes">
	<cfargument name="parser" hint="the parser in question. Useful for constants" type="any" required="Yes">
	<cfscript>
		var pointcut = createObject("component", "coldspring.aop.support.ExecutionPointcut").init();

		parseExecutionScope(arguments.expression, arguments.tree.getChild(0));

		//4 items -> scope, return, package & method, arguments
		if(arguments.tree.getChildCount() == 4)
		{
			pointcut.setReturnType(arguments.tree.getChild(1).getText());
			parseExecutionPackageClassAndMethod(arguments.tree.getChild(2), pointcut);
			parseArguments(arguments.tree.getChild(3), pointcut);
		}

		//3 items -> scope, package & method, arguments
		if(arguments.tree.getChildCount() == 3)
		{
			parseExecutionPackageClassAndMethod(arguments.tree.getChild(1), pointcut);
			parseArguments(arguments.tree.getChild(2), pointcut);
		}

		return pointcut;
    </cfscript>
</cffunction>

<cffunction name="parseExecutionScope" hint="Parse the scope part of a execution() pointcut" access="private" returntype="void" output="false">
	<cfargument name="expression" hint="the original expression" type="string" required="Yes">
	<cfargument name="tree" hint="the scope part of the AST" type="any" required="Yes">
	<cfscript>
		//we only support public right now
		if(arguments.tree.getText() != instance.static.PUBLIC_SCOPE)
		{
			//there is an error!
			createObject("component", "coldspring.aop.expression.exception.InvalidExpressionException").init(arguments.expression,
																										arguments.tree.getLine(),
																										arguments.tree.getCharPositionInLine(),
																										"Only the public scope is currently supported by ColdSpring. '*' and 'private' scoped pointcuts may be supported at a later date.");
		}
    </cfscript>
</cffunction>

<cffunction name="parseExecutionPackageClassAndMethod" hint="parses the execution() pointcut package/class and method portion and sets the relevent details on the pointcut"
	access="private" returntype="void" output="false">
	<cfargument name="tree" hint="the package, class and method part of the AST" type="any" required="Yes">
	<cfargument name="pointcut" hint="the expression pointcut" type="coldspring.aop.support.ExecutionPointcut" required="Yes">
	<cfscript>
		var local = {};
		local.expression = arguments.tree.getText();

		/*
			Different options for the package, class and method section
			unittests.aop..*.*
			unittests.aop.com.Hello.*
			unittests.aop.*.*
			unittests.aop.com..*.*
			set*
		*/

		local.len = ListLen(local.expression, instance.static.EXPRESSION_DELIMITER);

		//if no '.', then is just a method declaration
		if(local.len == 1)
		{
			arguments.pointcut.setMethodName(local.expression);
		}
		else
		{
			local.methodName = ListGetAt(local.expression, local.len, instance.static.EXPRESSION_DELIMITER);
			arguments.pointcut.setMethodName(local.methodName);

			//strip the method name off it.
			local.expression = Left(local.expression, (Len(local.expression) - (Len(local.methodName) + 1)));

			if(local.expression.endsWith("..*"))
			{
				local.package = Left(local.expression, Len(local.expression) - 3);

				arguments.pointcut.setSubPackage(local.package);
			}
			else if(local.expression.endsWith(".*"))
			{
				local.package = Left(local.expression, Len(local.expression) - 2);

				arguments.pointcut.setPackage(local.package);
			}
			else
			{
				//if it doesn't end with those values, must be a class def.
				arguments.pointcut.setInstanceType(local.expression);
			}
		}
    </cfscript>
</cffunction>

<cffunction name="parseArguments" hint="parse the argument section of the exectution pointcut" access="private" returntype="any" output="false">
	<cfargument name="tree" hint="the package, class and method part of the AST" type="any" required="Yes">
	<cfargument name="pointcut" hint="the expression pointcut" type="coldspring.aop.support.ExecutionPointcut" required="Yes">
	<cfscript>
		var local = {};
		local.argumentCount = arguments.tree.getChildCount();

		if(local.argumentCount == 0)
		{
			arguments.pointcut.setMatchAnyArguments(false);
		}
		else if(local.argumentCount == 1 AND arguments.tree.getChild(0).getText() eq instance.static.ANY_ARGUMENTS)
		{
			//true is default, but doesn't hurt
			arguments.pointcut.setMatchAnyArguments(true);
		}
		else
		{
			for(local.counter = 1; local.counter <= local.argumentCount; local.counter++)
			{
				arguments.pointcut.addArgumentType(arguments.tree.getChild(0).getText());
			}
		}
    </cfscript>
</cffunction>

<cffunction name="parseAnnotation" hint="parses an annotation pointcut - @target or @annotation" access="private" returntype="coldspring.aop.Pointcut" output="false">
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

<cffunction name="parseTarget" hint="parses a Target pointcut - target" access="private" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="tree" hint="the AST" type="any" required="Yes">
	<cfargument name="parser" hint="the parser in question. Useful for constants" type="any" required="Yes">
	<cfscript>
		var pointcut = createObject("component", "coldspring.aop.support.ExecutionPointcut").init();
		pointcut.setInstanceType(arguments.tree.getChild(0).getText());

		return pointcut;
    </cfscript>
</cffunction>

<cffunction name="parseWithin" hint="parses an within pointcut - within()" access="private" returntype="coldspring.aop.Pointcut" output="false">
	<cfargument name="expression" hint="the original expression" type="string" required="Yes">
	<cfargument name="tree" hint="the AST" type="any" required="Yes">
	<cfargument name="parser" hint="the parser in question. Useful for constants" type="any" required="Yes">
	<cfscript>
		var pointcut = createObject("component", "coldspring.aop.support.ExecutionPointcut").init();

		var package = arguments.tree.getChild(0).getText();

		if(package.endsWith("..*"))
		{
			package = Left(package, Len(package) - 3);

			pointcut.setSubPackage(package);

			return pointcut;
		}
		else if(package.endsWith(".*"))
		{
			package = Left(package, Len(package) - 2);

			pointcut.setPackage(package);

			return pointcut;
		}
		else
		{
			//there is an error!
			createObject("component", "coldspring.aop.expression.exception.InvalidExpressionException").init(arguments.expression,
																										arguments.tree.getChild(0).getLine(),
																										arguments.tree.getChild(0).getCharPositionInLine(),
																										"A within pointcut needs to end in either '.*' or '..*' to define if the Aspect should match to the specific package (.*), or that package and any sub package (..*)");
		}
    </cfscript>
</cffunction>

<cffunction name="getJavaLoader" access="private" returntype="coldspring.core.java.JavaLoader" output="false">
	<cfreturn instance.JavaLoader />
</cffunction>

<cffunction name="setJavaLoader" access="private" returntype="void" output="false">
	<cfargument name="JavaLoader" type="coldspring.core.java.JavaLoader" required="true">
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