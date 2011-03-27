grammar AopExpression;

/*
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
*/

options 
{
	output=AST;
}

tokens 
{
	ARGUMENTS;
}

@members 
{
    private List<Map<String, Object>> errorList = new ArrayList<Map<String, Object>>();
    public static final String EXCEPTION_KEY = "exception";
    public static final String MESSAGE_KEY = "message";

    public void displayRecognitionError(String[] tokenNames, RecognitionException e) 
    {   	
        Map<String, Object> error = new HashMap<String, Object>();
        
        error.put(MESSAGE_KEY, getErrorMessage(e, tokenNames));
	error.put(EXCEPTION_KEY, e);
	
	errorList.add(error);
              
        super.displayRecognitionError(tokenNames, e);
    }
    
    public List<Map<String, Object>> getErrorList()
    {
    	return errorList;
    }
}

@lexer::header {
	package com.coldspring.aop.expression;
	
	//import java.util.*;
	
}

@lexer::members 
{
	boolean expressionStart = false;
}

@parser::header {
	package com.coldspring.aop.expression;
	
	import java.util.List;
	import java.util.Map;
	import java.util.ArrayList;
	import java.util.HashMap;
}

/* parser */

prog	:	expr
	;

expr	: 	(NOT^?(executionExpr | simpleExpr | annotationExr))^ logicExpr?
	;
	
logicExpr
	:	((AND | OR)^ expr)
	;

simpleExpr
	:	EXPRESSION_TYPE^ '('! DESCRIPTOR CLOSE_PAREN!
	;

executionExpr 
	:	EXECUTION_EXPRESSION_TYPE^ '('! SCOPE type? type executionArgs CLOSE_PAREN!
	;
	
executionArgs
	: 	'(' ANY_ARGUMENT? CLOSE_PAREN -> ^(ARGUMENTS ANY_ARGUMENT?)
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
	{ expressionStart = true;}
	;

EXECUTION_EXPRESSION_TYPE
	/* we don't expression start here, we allow SCOPE to come first */
	: {!expressionStart}?=>	'execution'
	;


EXPRESSION_TYPE
	: {!expressionStart}?=>	( 'within' | 'target' | 'bean')
	{ expressionStart = true;}
	;
	
SCOPE	: {!expressionStart}?=>('public' | 'private' | '*')
	{ expressionStart = true;}
	;

CF_TYPE : {expressionStart}?=> ('string' | 'boolean' | 'query' | 'xml' | 'component' | 'any' | 'struct' | 'array' | 'binary' )
	;

DESCRIPTOR  
	: {expressionStart}?=> (('a'..'z'|'A'..'Z'|'_'|'*') ('a'..'z'|'A'..'Z'|'0'..'9'|'_'|'.'|'*'|':')*)
	| /* give it another option so it doesn't infinite loop out when the predicate fails */
	{ input.seek(input.size()); }
      	;
      	
ANY_ARGUMENT
	:	'..'
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
    }
    ;
    
STRING_SINGLE_QUOTE
    :  '\'' ( ESC_SEQ | ~('\\'|'\'') )* '\''
    {
   	setText(getText().substring(1, getText().length()-1));
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

