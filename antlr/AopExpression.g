grammar AopExpression;

options 
{
	output=AST;
}

tokens 
{
	ARGUMENTS;
}

@lexer::members 
{
	boolean expressionStart = false;
}

/* parser */

prog	:	expr
	;

expr	: 	(NOT?(executionExpr | simpleExpr | annotationExr))^ ((AND | OR) expr)?
	;

simpleExpr
	:	EXPRESSION_TYPE^ '('! DESCRIPTOR ')'!
	;

executionExpr 
	:	EXECUTION_EXPRESSION_TYPE^ '('! SCOPE type? type executionArgs ')'!
	;
	
executionArgs
	: 	'(' ANY_ARGUMENT ')' -> ^(ARGUMENTS ANY_ARGUMENT)
	| 	'(' type (',' type)* ')' -> ^(ARGUMENTS type+)
	;

annotationExr
	: 	ANNOTATION_EXPRESSION_TYPE^ '('! DESCRIPTOR ('='! STRING)? ')'!
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

AND	:	'&&'
	{ expressionStart = false; }
	;
	
OR	:	'||'
	{ expressionStart = false; }
	;

NOT	:	'!'
	;
	
WS  :   ( ' '
        | '\t'
        | '\r'
        | '\n'
        ) {$channel=HIDDEN;}
    ;
    
STRING
    :  '"' ( ESC_SEQ | ~('\\'|'"') )* '"'
    {System.out.println("STRING");}
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

