
//Base Character Set
terminal RESERVED: '...' ;
terminal DOT: '.' ;
terminal COMMA: ',' ;
terminal LPAREN: '(';
terminal RPAREN: ')';
terminal LSQUARE: '[';
terminal RSQUARE: ']';
terminal LCURL: '{';
terminal RCURL: '}';
terminal MULT: '*' ;
terminal MOD: '%' ;
terminal DIV: '/';
terminal ARROW: '->' ;
terminal ADD: '+' ;
terminal SUB: '-' ;
terminal CONJ: '&&' ;
terminal DISJ: '||' ;
terminal EXCL_EQ: '!=' ;
terminal EXCL: '!' ;
terminal COLONCOLON: '::' ;
terminal COLON: ':' ;
terminal SEMICOLON: ';' ;
terminal EQEQ: '==' ;
terminal ASSIGNMENT: '=' ;
terminal ADD_ASSIGNMENT: '+=' ;
terminal SUB_ASSIGNMENT: '-=' ;
terminal MULT_ASSIGNMENT: '*=' ;
terminal DIV_ASSIGNMENT: '/=' ;
terminal MOD_ASSIGNMENT: '%=' ;
terminal DOUBLE_ARROW: '=>' ;
terminal RANGE: '..' ;
//DOUBLE_SEMICOLON: ';;' ;
terminal HASH: '#' ;
terminal AT: '@' ;
terminal QUEST: '?' ;
terminal LE: '<=' ;
terminal GE: '>=' ;
terminal LANGLE: '<' ;
terminal RANGLE: '>' ;
//EXCL_EQEQ: '!==' ;
//EQEQEQ: '===' ;
terminal WVEQ: '~=';
terminal SINGLE_QUOTE: '\'' ;
//RIGHT_SHIFT_ARITHMETIC:           '>>';
//LEFT_SHIFT_ARITHMETIC:            '<<';
//RIGHT_SHIFT_LOGICAL:              '>>>';
terminal UNION:                         '&';
//BIT_X_OR:                         '^';
//BIT_OR:                          '|';
//LEFT_SHIFT_ARITHMETIC_ASSIGN:      '<<=';
//RIGHT_SHIFT_ARITHMETIC_ASSIGN:     '>>=';
//RIGHT_SHIFT_LOGICAL_ASSIGN:        '>>>=';
//BIT_AND_ASSIGN:                   '&=';
//BIT_XOR_ASSIGN:                   '^=';
//BIT_OR_ASSIGN:                    '|=';
terminal PIPE: '|';
terminal TRIPLE_QUOTE_OPEN: '"""';

terminal CLASS:'class';
terminal OBJECT:'object';
terminal INTERFACE:'interface';
terminal DATA:'data';
terminal FUNCTION:'func';
terminal ENUM:'enum';
terminal OPERATOR:'operator';
terminal TYPEALIAS: 'typealias';

terminal NAMESPACE:  'namespace';
terminal VEC:        'vec';
terminal INT:        'int';
terminal ENTITY:     'entity';
terminal BOOL:       'bool';
terminal BYTE:       'byte';
terminal SHORT:      'short';
terminal LONG:       'long';
terminal FLOAT:      'float';
terminal DOUBLE:     'double';
terminal SELECTOR:   'selector';
terminal STRING:     'string';
terminal TEXT:      'text';
terminal NBT:        'nbt';
terminal ANY:        'any';
terminal VOID:       'void';
terminal LIST:       'list';
terminal MAP:        'map';
terminal DICT:       'dict';
terminal TYPE:       'Type';
terminal BYTEARRAY:  'ByteArray';
terminal INTARRAY:   'IntArray';
terminal LONGARRAY:  'LongArray';

//KeyWords
terminal THIS:'this';
terminal SUPER:'super';
terminal IF:'if';
terminal ELSE:'else';
terminal WHILE:'while';
terminal FOR:'for';
terminal DO:'do';
terminal TRY:'try';
terminal STORE:'store';
terminal AS:'as';
terminal FROM:'from';
terminal EXECUTE:'execute';

terminal BREAK:'break';
terminal CONTINUE:'continue';
terminal RETURN:'return';

terminal STATIC:'static';
terminal EXTENDS:'extends';
terminal NATIVE:'native';
terminal CONCRETE:'concrete';
terminal FINAL:'final';

terminal PUBLIC:'public';
terminal PROTECTED:'protected';
terminal PRIVATE:'private';

terminal OVERRIDE: 'override';
terminal ABSTRACT: 'abstract';
terminal IMPL: 'impl';

terminal CONSTRUCTOR:'constructor';

terminal CONST:'const';
terminal DYNAMIC:'dynamic';
terminal IMPORT: 'import';

terminal INLINE:'inline';

terminal GLOBAL:'global';
terminal VAR:'var';

terminal GET:'get';
terminal SET:'set';

terminal TRUE:   'true';
terminal FALSE:  'false';
terminal NULL:   'null';

terminal VecType: VEC DigitSequence;

//Identifiers
terminal TargetSelector
    :   '@' ('a'|'r'|'p'|'s'|'e')
    ;

terminal DigitSequence: /[0-9]+/;
terminal HexSequence: /[0-9a-fA-F]+/;
terminal OctalSequence: /[0-7]+/;

terminal DecimalConstant: DigitSequence;
terminal HexadecimalConstant: '0x' HexSequence;
terminal OctalConstant: '0' | '0' OctalSequence;
terminal FractionalConstant: DigitSequence DOT DigitSequence;

terminal ExponentPart
    :   /[eE]/ (ADD|SUB)? DigitSequence;

terminal IntConstant : DecimalConstant|HexadecimalConstant|OctalConstant;

terminal DOTIdentifier: /[_\p{L}][_\p{L}\p{Nd}]*(\.[_\p{L}][_\p{L}\p{Nd}]*)*/u;
terminal Identifier: /[_\p{L}][_\p{L}\p{Nd}]*/u;
terminal Letter: /[\p{L}]/u;
terminal UnicodeDigit: /[\p{Nd}]/u;

terminal NBT_BYTE_ARRAY_BEGIN: '[B;';
terminal NBT_INT_ARRAY_BEGIN: '[I;';
terminal NBT_LONG_ARRAY_BEGIN: '[L;';

terminal NBTByteSuffix: /[bB]/;
terminal NBTShortSuffix: /[sS]/;
terminal NBTLongSuffix: /[lL]/;
terminal NBTFloatSuffix: /[fF]/;
terminal NBTDoubleSuffix: /[dD]/;

terminal NBTByte: IntConstant NBTByteSuffix;
terminal NBTShort: IntConstant NBTShortSuffix;
terminal NBTInt: IntConstant;
terminal NBTLong: IntConstant NBTLongSuffix;
terminal NBTFloat: (FractionalConstant ExponentPart? NBTFloatSuffix?) | (IntConstant NBTFloatSuffix?);
terminal NBTDouble: (DigitSequence|FractionalConstant) ExponentPart? NBTDoubleSuffix;
terminal NBTBool: BooleanConstant;

terminal FloatConstant
    : DigitSequence NBTFloatSuffix
    | FractionalConstant ExponentPart? NBTFloatSuffix?
    ;

terminal RelativeValue
    :   '~'
    |   '^'
    |   '~' IntConstant?
    |   '~' FloatConstant?
    |   '^' IntConstant?
    |   '^' FloatConstant?
    ;

terminal BooleanConstant
    :   TRUE
    |   FALSE
    ;

terminal LineString: /"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*/;

hidden terminal WS: /[ \t\r\n\u000C]+/;

terminal DOC_COMMENT: /#\{[\s\S]*?\}#/;
terminal SIMPLE_DOC_COMMENT: /#>.*?\n/;
hidden terminal BLOCK_COMMENT: /##[\s\S]*?##/;
hidden terminal LINE_COMMENT: /#[^\r\n]*/;