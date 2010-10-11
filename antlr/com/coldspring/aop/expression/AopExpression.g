grammar AopExpression;

options 
{
	output=AST;
}

tokens 
{
	ARGUMENTS;
}

@lexer::header {
	package com.coldspring.aop.expression;
}

@lexer::members 
{
	boolean expressionStart = false;
}

@parser::header {
	package com.coldspring.aop.expression;
}

/* parser */

prog	:	expr
	;

expr	: 	(NOT?(executionExpr | simpleExpr | annotationExr))^ ((AND | OR) expr)?
	;

simpleExpr
	:	EXPRESSION_TYPE^ '('! DESCRIPTOR CLOSE_PAREN!
	;

executionExpr 
	:	EXECUTION_EXPRESSION_TYPE^ '('! SCOPE type? type executionArgs CLOSE_PAREN!
	;
	
executionArgs
	: 	'(' ANY_ARGUMENT CLOSE_PAREN -> ^(ARGUMENTS ANY_ARGUMENT)
	| 	'(' type (',' type)* CLOSE_PAREN -> ^(ARGUMENTS type+)
	;

annotationExr
	: 	ANNOTATION_EXPRESSION_TYPE^ '('! DESCRIPTOR ('='! string)? CLOSE_PAREN!
	;

string
	: STRING_DOUBLE_QUOTE | STRING_SINGLE_QUOTE
	;

type 	:	CF_TYPE | DESCRIPTOR
	;

/* tokens */


ANNOTATION_EXPRESSION_TYPE
	: {!expressionStart}?=>	('@annotation' | '@target')
	{ expressionStart = true; System.out.println("ANNOTATION_EXPRESSION_TYPE");}
	;

EXECUTION_EXPRESSION_TYPE
	: {!expressionStart}?=>	'execution'
	/* we don't expression start here, we allow SCOPE to come first */
	{System.out.println("EXECUTION_EXPRESSION_TYPE");}
	;


EXPRESSION_TYPE
	: {!expressionStart}?=>	( 'within' | 'target' | 'bean')
	{ expressionStart = true; System.out.println("EXPRESSION_TYPE");}
	;
	
SCOPE	: {!expressionStart}?=>('public' | 'private' | '*')
	{ expressionStart = true; System.out.println("SCOPE");}
	;

CF_TYPE : {expressionStart}?=> ('string' | 'boolean' | 'query' | 'xml' | 'component' | 'any' | 'struct' | 'array' | 'binary' )
	{System.out.println("CF_TYPE");}
	;

DESCRIPTOR  
	: {expressionStart}?=> (('a'..'z'|'A'..'Z'|'_'|'*') ('a'..'z'|'A'..'Z'|'0'..'9'|'_'|'.'|'*'|':')*)
	{System.out.println("DESCRIPTOR");}
      	;
      	
ANY_ARGUMENT
	:	'..'
	{System.out.println("ANY_ARGUMENT");}
	;

AND	:	'&&' | 'and' | 'AND'
	{ expressionStart = false; }
	;
	
OR	:	'||' | 'or' | 'OR'
	{ expressionStart = false; }
	;

NOT	:	'!'
	;

CLOSE_PAREN
	:	')'
	{ expressionStart = false; }	
	;
	
WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;
    

STRING_DOUBLE_QUOTE
    :  '"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    {
    	setText(getText().substring(1, getText().length()-1));
    	System.out.println("STRING_DOUBLE:" + getText());
    }
    ;
    
STRING_SINGLE_QUOTE
    :  '\'' ( ESC_SEQ | ~('\\'|'\'') )* '\''
    {
   	setText(getText().substring(1, getText().length()-1));
   	System.out.println("STRING_SINGLE: " + getText());
    }
    ;    

fragment
HEX_DIGIT : ('0'..'9'|'a'..'f'|'A'..'F') ;

fragment
ESC_SEQ
    :   '\\' ('b'|'t'|'n'|'f'|'r'|'\"'|'\''|'\\')
    |   UNICODE_ESC
    |   OCTAL_ESC
    ;

fragment
OCTAL_ESC
    :   '\\' ('0'..'3') ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7') ('0'..'7')
    |   '\\' ('0'..'7')
    ;

fragment
UNICODE_ESC
    :   '\\' 'u' HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT
    ;

