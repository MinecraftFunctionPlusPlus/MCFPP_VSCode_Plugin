grammar Mcfpp

import './token'

//一个mcfpp文件
entry CompilationUnit
    :   NamespaceDeclaration=NamespaceDeclaration?
        importDeclaration+=ImportDeclaration*
        typealiasDeclaration+=TypealiasDeclaration*
        topStatement=TopStatement
        typeDeclaration+=TypeDeclaration*
        EOF
    ;

TopStatement
    : statement+=Statement*
    ;

//命名空间声明
NamespaceDeclaration
    :   DocComment? NAMESPACE Id+=Identifier (DOT Id+=Identifier)* SEMICOLON
    ;

ImportDeclaration
    :   IMPORT importType=ImportType (AS asIdentifier=Identifier)? (FROM fromIdentifier=Identifier)? SEMICOLON
    ;

ImportType
    :   namespace+=Identifier (DOT namespace+=Identifier)* COLON id=(Identifier|MULT)
    ;

TypealiasDeclaration
    :   TYPEALIAS type=Type AS id=Identifier SEMICOLON
    ;

//类或函数声明
TypeDeclaration
    :   DocComment? declarations=Declarations
    ;

//类或函数声明
Declarations
    :   clazz=ClassDeclaration
    |   genericClass=GenericClassImplement
    |   objectClass=ObjectClassDeclaration
    |   function=FunctionDeclaration
    |   inlineFunction=InlineFunctionDeclaration
    |   nativeFunction=NativeFuncDeclaration
    |   compileTimeFunction=CompileTimeFuncDeclaration
    |   compileTimeClass=CompileTimeClassDeclaration
    |   nativeClass=NativeClassDeclaration
    |   template=TemplateDeclaration
    |   objectTemplate=ObjectTemplateDeclaration
    |   extensionFunction=ExtensionFunctionDeclaration
    |   iface=InterfaceDeclaration
    |   enum=EnumDeclaration
    |   annotation=Annotation
    ;

//类声明
ClassDeclaration
    :   (isStatic?=STATIC)? (isFinal?=FINAL)? (isAbstract?=ABSTRACT)? CLASS id=ClassWithoutNamespace params=ReadOnlyParams? (COLON extendedClassName+=ClassName (COMMA extendedClassName+=ClassName)*)? (body=ClassBody | SEMICOLON)
    ;

ObjectClassDeclaration
    :   (isFinal?=FINAL)? OBJECT CLASS id=ClassWithoutNamespace params=ReadOnlyParams? (COLON extendedClassName+=ClassName (COMMA extendedClassName+=ClassName)*)? (body=ClassBody | SEMICOLON)
    ;

CompileTimeClassDeclaration
    :   CONST CLASS id=ClassWithoutNamespace (COLON extendedClassName+=ClassName (COMMA extendedClassName+=ClassName)*)? (body=ClassBody | SEMICOLON)
    ;

NativeClassDeclaration
    :   CLASS id=ClassWithoutNamespace ASSIGNMENT javaRefer=JavaRefer SEMICOLON
    ;

ClassMemberDeclaration
    :   accessModifier=AccessModifier? classMember=ClassMember
    ;

ClassBody
    :   LCURL (doc_comment+=DocComment? classMemberDeclaration+=ClassMemberDeclaration)* RCURL
    ;

//类成员
ClassMember
    :   function=ClassFunctionDeclaration
    |   field=ClassFieldDeclaration
    |   constructor=ClassConstructorDeclaration
    |   nativeFunction=NativeClassFunctionDeclaration
    |   abstractFunction=AbstractClassFunctionDeclaration
    |   annotation=Annotation
    |   operationOverride=OperationOverrideDeclaration
    |   nativeOperationOverride=NativeOperationOverrideDeclaration
    ;

ClassFunctionDeclaration
    :   (isOverride?=OVERRIDE)? FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL functionBody=FunctionBody RCURL
    ;

AbstractClassFunctionDeclaration
    :   (isOverride?=OVERRIDE)? FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? SEMICOLON
    ;

NativeClassFunctionDeclaration
    :   (isOverride?=OVERRIDE)? FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? ASSIGNMENT javaRefer=JavaRefer SEMICOLON
    ;

OperationOverrideDeclaration
    :   OPERATOR op=SupportOperator params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL functionBody=FunctionBody RCURL
    ;

NativeOperationOverrideDeclaration
    :   OPERATOR op=SupportOperator params=FunctionParams (ARROW returnType=FunctionReturnType)? ASSIGNMENT javaRefer=JavaRefer SEMICOLON
    ;

SupportOperator returns string
    :   ADD
    |   SUB
    |   MULT
    |   DIV
    |   MOD
    |   RANGLE
    |   LANGLE
    |   GE
    |   LE
    |   EQEQ
    |   EXCL_EQ
    |   WVEQ
    |   DISJ
    |   CONJ
    |   PIPE
    |   Identifier
    ;

ClassFieldDeclaration
    :   accessModifier=AccessModifier? VAR? id=Identifier (AS type_=Type)? (ASSIGNMENT initExpr=Expression)? accessor=Accessor? SEMICOLON
    ;

Accessor
    :   LCURL getter=Getter? setter=Setter? RCURL
    ;

Getter
    :   GET LCURL functionBody=FunctionBody RCURL
    |   GET ASSIGNMENT javaRefer=JavaRefer SEMICOLON
    |   GET ASSIGNMENT expression=Expression SEMICOLON
    |   GET SEMICOLON
    ;

Setter
    :   SET LCURL functionBody=FunctionBody RCURL
    |   SET ASSIGNMENT javaRefer=JavaRefer SEMICOLON
    |   SET ASSIGNMENT expression=Expression SEMICOLON
    |   SET SEMICOLON
    ;

GenericClassImplement
    :   IMPL (isStatic?=STATIC)? (isFinal?=FINAL)? (isAbstract?=ABSTRACT)? CLASS id=ClassWithoutNamespace args=ReadOnlyArgs (COLON extendedClassName+=ClassName (COMMA extendedClassName+=ClassName)*)? (body=ClassBody | SEMICOLON)
    ;

//数据模板
TemplateDeclaration
    :   (isFinal?=FINAL)? DATA id=ClassWithoutNamespace params=ReadOnlyParams? ((COLON extendedTemplateName+=ClassName (COMMA extendedTemplateName+=ClassName)*) | AS type_=Type)? (body=TemplateBody | SEMICOLON)
    ;

//数据模板
ObjectTemplateDeclaration
    :   (isFinal?=FINAL)? OBJECT DATA id=ClassWithoutNamespace params=ReadOnlyParams? (COLON extendedTemplateName+=ClassName (COMMA extendedTemplateName+=ClassName)*)? (body=TemplateBody | SEMICOLON)
    ;

TemplateBody
    :   LCURL (doc_comment+=DocComment? templateMemberDeclaration+=TemplateMemberDeclaration)* RCURL
    ;

TemplateMemberDeclaration
    :   accessModifier=AccessModifier? templateMember=TemplateMember
    ;

TemplateMember
    :   function=TemplateFunctionDeclaration
    |   field=TemplateFieldDeclaration
    |   constructor=TemplateConstructorDeclaration
    |   operationOverride=OperationOverrideDeclaration
    |   nativeOperationOverride=NativeOperationOverrideDeclaration
    |   annotation=Annotation
    ;

TemplateFunctionDeclaration
    :   (isOverride?=OVERRIDE)? FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

TemplateFieldDeclaration
    :   (accessModifier=AccessModifier)? (isConst?=CONST)? VAR? id=Identifier (AS type_=TemplateType)? (ASSIGNMENT  initExpr=Expression)? accessor=Accessor? SEMICOLON
    ;

TemplateType
    :   singleType=SingleTemplateFieldType | unionType=UnionTemplateFieldType
    ;

SingleTemplateFieldType
    :   type_=Type (isNullable?=QUEST)?
    ;

UnionTemplateFieldType
    :   LPAREN type_+=Type (PIPE type_+=Type)* RPAREN (isNullable?=QUEST)?
    ;

//接口声明
InterfaceDeclaration
    :   INTERFACE id=ClassWithoutNamespace (ARROW extendedInterfaceName+=ClassName (COMMA extendedInterfaceName+=ClassName)*)? (body=InterfaceBody | SEMICOLON)
    ;

InterfaceBody
    :   LCURL( doc_comment+=DocComment? annotation+=Annotation? interfaceFunctionDeclaration+=InterfaceFunctionDeclaration )* RCURL
    ;

InterfaceFunctionDeclaration
    :   FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? SEMICOLON
    ;

CompileTimeFuncDeclaration
    :   CONST FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

InlineFunctionDeclaration
    :   INLINE FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

//函数声明
FunctionDeclaration
    :   FUNCTION id=Identifier params=FunctionParams? (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

ExtensionFunctionDeclaration
    :   FUNCTION (targetType=Type DOT)? id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

//枚举
EnumDeclaration
    :   ENUM id=Identifier LCURL body=EnumBody RCURL
    ;

EnumBody
    :   enumMember+=EnumMember (COMMA enumMember+=EnumMember)*
    ;

EnumMember
    :   id=Identifier (ASSIGNMENT value=NbtValue)?
    ;


NamespaceID
    : (namespace+=Identifier ( DOT namespace+=Identifier)* COLON)? id=Identifier
    ;

NativeFuncDeclaration
    :   FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? ASSIGNMENT javaRefer=JavaRefer SEMICOLON
    ;

JavaRefer returns string
    :   Identifier (DOT Identifier)*
    ;

AccessModifier returns string
    :   PRIVATE
    |   PROTECTED
    |   PUBLIC
    ;

//构造函数声明
ClassConstructorDeclaration
    :   accessModifier=AccessModifier? CONSTRUCTOR params=NormalParams LCURL body=FunctionBody RCURL
    ;

//构造函数声明
TemplateConstructorDeclaration
    :   accessModifier=AccessModifier? CONSTRUCTOR params=NormalParams LCURL body=FunctionBody RCURL
    ;

//变量声明
FieldDeclaration
    :   fieldModifier=FieldModifier? VAR id=Identifier (AS type_=Type)? (ASSIGNMENT initExpr=Expression)?
    ;

FieldModifier returns string : CONST|DYNAMIC|IMPORT;

FunctionParams
    :   readOnlyParams=ReadOnlyParams? normalParams=NormalParams
    ;

ReadOnlyParams
    :   LANGLE parameterList=ParameterList? RANGLE
    ;

NormalParams
    :   LPAREN parameterList=ParameterList? RPAREN
    ;

//参数列表
ParameterList
    :   parameter+=Parameter (COMMA parameter+=Parameter)*
    ;

//参数
Parameter
    :   (isStatic?=STATIC)? VAR? (id=Identifier AS)? type_=Type (ASSIGNMENT defaultValue=Value)?
    ;

//表达式
Expression
    :   primary=Primary
    |   commonBinaryOperatorExpression=CommonBinaryOperatorExpression
    ;

//能作为语句的表达式
StatementExpression
    :   (leftExpr=VarWithSelector ASSIGNMENT)? rightExpr=Expression
    ;

//条件表达式
ConditionalExpression
    :   commonBinaryOperatorExpression=CommonBinaryOperatorExpression ( QUEST thenExpr=Expression COLON elseExpr=Expression)?
    ;

//其他运算符
CommonBinaryOperatorExpression
    :   conditionalOrExpression+=ConditionalOrExpression (op+=CommonBinaryOperator conditionalOrExpression+=ConditionalOrExpression)*
    ;

CommonBinaryOperator returns string: PIPE | Identifier;

//或
ConditionalOrExpression
    :   conditionalAndExpression+=ConditionalAndExpression ( DISJ conditionalAndExpression+=ConditionalAndExpression )*
    ;

//与
ConditionalAndExpression
    :   equalityExpression+=EqualityExpression ( CONJ equalityExpression+=EqualityExpression )*
    ;

//等同
EqualityExpression
    :   relationalExpression+=RelationalExpression ( op=(EQEQ | EXCL_EQ | WVEQ) relationalExpression+=RelationalExpression )?
    ;

//比较关系
RelationalExpression
    :   additiveExpression+=AdditiveExpression ( op=RelationalOp additiveExpression+=AdditiveExpression )?
    ;

//比较关系运算符
RelationalOp returns string
    :   LE
    |   GE
    |   LANGLE
    |   RANGLE
    ;

//加减
AdditiveExpression
    :   multiplicativeExpression+=MultiplicativeExpression ( op+=(ADD | SUB) multiplicativeExpression+=MultiplicativeExpression )*
    ;
    
//乘除
MultiplicativeExpression
    :   unaryExpression+=UnaryExpression ( op+=( MULT | DIV | MOD ) unaryExpression+=UnaryExpression )*
    ;

//一元表达式
UnaryExpression
    :   EXCL unaryExpression=UnaryExpression
    |   castExpression=CastExpression
    |   rightVarExpression=RightVarExpression
    ;

//右侧计算式取出的变量
RightVarExpression
    :   varWithSelector=VarWithSelector
    ;

//强制类型转换表达式
CastExpression
    :  rightVarExpression=RightVarExpression AS type_=Type
    ;

VarWithSelector
    : jvmAccessExpression=JvmAccessExpression selector+=Selector*
    ;

JvmAccessExpression
    :   propertyOperator=PropertyOperator (COLONCOLON id=Identifier)?
    ;

//字段操作器
PropertyOperator
    :   primary=Primary (LSQUARE propertyOperatorExpression+=PropertyOperatorExpression (COMMA propertyOperatorExpression+=PropertyOperatorExpression)* RSQUARE)?
    ;

PropertyOperatorExpression
    :   id=Identifier ASSIGNMENT expr=Expression
    ;

//初级表达式
Primary
    :   range=Range
    |   value=Value
    |   var=Var
    |   this=THIS
    |   super=SUPER
    |   type_=Type
    ;

Var
    :   bucketExpression=BucketExpression
    |   varWithSuffix=VarWithSuffix
    |   functionCall=FunctionCall
    ;

BucketExpression
    :   LPAREN expression=Expression RPAREN
    ;

VarWithSuffix
    :   Identifier identifierSuffix+=IdentifierSuffix*
    ;

FunctionCall
    :   namespaceID=NamespaceID arguments=Arguments
    ;

IdentifierSuffix
    :   LSQUARE conditionalExpression=ConditionalExpression RSQUARE
    |   LSQUARE objectInitializer+=ObjectInitializer  (COMMA objectInitializer+=ObjectInitializer)* RSQUARE
    |   LSQUARE RSQUARE //empty bucket
    ;

ObjectInitializer
    :   id=Identifier ASSIGNMENT expr=Expression
    ;

Selector
    :   DOT var_=Var
    ;

Arguments
    :   readOnlyArgs=ReadOnlyArgs? normalArgs=NormalArgs
    ;

ReadOnlyArgs
    :   LANGLE expressionList=ExpressionList? RANGLE
    ;

NormalArgs
    :   LPAREN expressionList=ExpressionList? RPAREN
    ;

FunctionBody
    :   statement+=Statement*
    ;

Statement
    :   fieldDeclaration=FieldDeclaration SEMICOLON
    |   statementExpression=StatementExpression SEMICOLON
    |   ifStatement=IfStatement
    |   whileStatement=WhileStatement
    |   doWhileStatement=DoWhileStatement SEMICOLON
    |   SEMICOLON
    |   tryStoreStatement=TryStoreStatement
    |   controlStatement=ControlStatement SEMICOLON
//    |   orgCommand
    |   returnStatement=ReturnStatement SEMICOLON
    |   executeStatement=ExecuteStatement
    ;

ExecuteStatement
    :   EXECUTE LPAREN executeContext+=ExecuteContext (COMMA executeContext+=ExecuteContext)* RPAREN block=Block
    ;

ExecuteContext
    :   executeExpression=ExecuteExpression ASSIGNMENT expr=Expression
    ;

ExecuteExpression
    :   var_+=Var (DOT var_+=Var)*
    ;

ControlStatement returns string
    :   BREAK
    |   CONTINUE
    ;

IfStatement
    :   IF LPAREN conditionExpr=Expression RPAREN block=Block elseIfStatement+=ElseIfStatement* elseStatement=ElseStatement?
    ;

ElseIfStatement
    :   ELSE IF LPAREN conditionExpr=Expression RPAREN block=Block
    ;

ElseStatement
    :   ELSE block=Block
    ;

WhileStatement
    :   WHILE LPAREN conditionExpr=Expression RPAREN block=Block
    ;

DoWhileStatement
    :   DO block=Block WHILE LPAREN conditionExpr=Expression RPAREN
    ;

TryStoreStatement
    :   TRY block=Block STORE LPAREN identifier=Identifier RPAREN SEMICOLON
    ;

ReturnStatement
    : RETURN Expression?
    ;

Block
    :   LCURL statement+=Statement* RCURL
    |   statement+=Statement
    ;

ExpressionList
    :   expression+=Expression (COMMA expression+=Expression)*
    ;

Type
    :   typeWithoutExcl=TypeWithoutExcl (isConcrete?=EXCL)?
    ;

TypeWithoutExcl
    :   normalType=NormalType
    |   vecType=VecType
    |   isList?=LIST LANGLE genericType=Type RANGLE
    |   isMap?=MAP LANGLE Type RANGLE
    |   isDict?=DICT LANGLE Type RANGLE
    |   isEntity?=ENTITY LANGLE entityLimit=NbtInt RANGLE
    |   isEntity?=ENTITY LANGLE entityType+=LineString (COMMA entityType+=LineString)* RANGLE
    |   isEntity?=ENTITY LANGLE entityLimit=NbtInt COMMA entityType+=LineString (COMMA entityType+=LineString)* RANGLE
    |   className=ClassName args=ReadOnlyArgs?
    |   id=Identifier
    |   unionTemplateType=UnionTemplateType
    |   anonymousTemplateType=AnonymousTemplateType
    ;

AnonymousTemplateType
    :   DATA (COLON extendedTemplateName+=ClassName (COMMA extendedTemplateName+=ClassName)*)? body=TemplateBody
    ;

UnionTemplateType
    :   LPAREN type_+=Type (UNION type_+=Type)* RPAREN
    ;

NormalType returns string
    :   INT
    |   ENTITY
    |   BOOL
    |   BYTE
    |   SHORT
    |   LONG
    |   FLOAT
    |   DOUBLE
    |   SELECTOR
    |   STRING
    |   TEXT
    |   NBT
    |   TYPE
    |   ANY
    |   BYTEARRAY
    |   INTARRAY
    |   LONGARRAY
    ;

FunctionReturnType
    :   type_=Type
    |   isVoid?=VOID
    ;

Value
    :   coordinate=Coordinate
    |   lineString=LineString
    |   nbtValue=NbtValue
    |   targetSelector=TargetSelector
    |   isNull?=NULL
    ;

Coordinate
    :   coordinateDimension+=CoordinateDimension coordinateDimension+=CoordinateDimension coordinateDimension+=CoordinateDimension?
    ;

CoordinateDimension
    :   (relativeValue=RelativeValue | nbtInt=NbtInt | nbtFloat=NbtFloat | nbtDouble=NbtDouble)
    ;

ClassName returns string
    :   (Identifier (DOT Identifier)* COLON)? ClassWithoutNamespace
    ;

ClassWithoutNamespace returns string
    :   Identifier
    ;

Annotation
    :   AT id=Identifier args=AnnotationArgs?
    ;

AnnotationArgs
    :   LANGLE (value+=Value (COMMA value+=Value)*)? RANGLE
    ;

Range
    :   num1=Var RANGE num2=Var
    |   num1=Var RANGE
    |   RANGE num2=Var
    ;

NbtValue
    :   LineString
    |   NbtBool
    |   NbtByte
    |   NbtShort
    |   NbtInt
    |   NbtLong
    |   NbtFloat
    |   NbtDouble
    |   NBTCompound
    |   NBTList
    |   NBTByteArray
    |   NBTIntArray
    |   NBTLongArray
    ;

NbtByte returns number: NBTByte;
NbtShort returns number: NBTShort;
NbtInt returns number: NBTInt;
NbtLong returns number: NBTLong;
NbtFloat returns number: NBTFloat;
NbtDouble returns number: NBTDouble;
NbtBool returns boolean: NBTBool;

NBTByteArray: NBT_BYTE_ARRAY_BEGIN nbtByte+=NbtByte (COMMA nbtByte+=NbtByte)* RSQUARE;
NBTIntArray: NBT_INT_ARRAY_BEGIN nbtInt+=NbtInt (COMMA nbtInt+=NbtInt)* RSQUARE;
NBTLongArray: NBT_LONG_ARRAY_BEGIN nbtLong+=NbtLong (COMMA nbtLong+=NbtLong)* RSQUARE;

NBTList: LSQUARE (expression += Expression (COMMA expression += Expression)* )* RSQUARE;
NBTKeyValuePair: key=Identifier COLON expression=Expression;
NBTCompound: LCURL( nbtKeyValuePair += NBTKeyValuePair (COMMA nbtKeyValuePair += NBTKeyValuePair)* )*RCURL;

//
// Whitespace and comments
//

DocComment
    :   doc=DOC_COMMENT
    ;