grammar Mcfpp

import './token'

//一个mcfpp文件
entry CompilationUnit
    :   namespaceDeclaration=NamespaceDeclaration?
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
    :   DocComment? kw=NAMESPACE id=DOTIdentifier SEMICOLON
    ;

ImportDeclaration
    :   kw+=IMPORT importType=ImportType (kw+=AS asIdentifier=Identifier)? (kw+=FROM fromIdentifier=Identifier)? SEMICOLON
    ;

ImportType
    :   namespace=DOTIdentifier COLON id=(Identifier|MULT)
    ;

TypealiasDeclaration
    :   kw+=TYPEALIAS type_=Type kw+=AS id=Identifier SEMICOLON
    ;

//类或函数声明
TypeDeclaration
    :   DocComment? declaration=Declaration
    ;

//类或函数声明
Declaration
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
    :   (isStatic?=STATIC)? (isFinal?=FINAL)? (isAbstract?=ABSTRACT)? kw=CLASS id=Identifier params=ReadOnlyParams? (COLON inheritance=ClassInHeritance)? (body=ClassBody | SEMICOLON)
    ;

ClassInHeritance
    :   extendedClassName+=([ClassDeclaration:Identifier]) | extendedClassName+=([InterfaceDeclaration:Identifier]) (COMMA extendedClassName+=[ClassDeclaration:Identifier] | COMMA extendedClassName+=[InterfaceDeclaration:Identifier])*
    ;
    

ObjectClassDeclaration
    :   (isFinal?=FINAL)? kw+=OBJECT kw+=CLASS id=Identifier params=ReadOnlyParams? (COLON inheritance=ClassInHeritance)? (body=ClassBody | SEMICOLON)
    ;

CompileTimeClassDeclaration
    :   kw+=CONST kw+=CLASS id=Identifier (COLON inheritance=ClassInHeritance)? (body=ClassBody | SEMICOLON)
    ;

NativeClassDeclaration
    :   kw=CLASS id=Identifier ASSIGNMENT javaRefer=DOTIdentifier SEMICOLON
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
    :   (isOverride?=OVERRIDE)? kw=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL functionBody=FunctionBody RCURL
    ;

AbstractClassFunctionDeclaration
    :   (isOverride?=OVERRIDE)? kw=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? SEMICOLON
    ;

NativeClassFunctionDeclaration
    :   (isOverride?=OVERRIDE)? kw=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? ASSIGNMENT javaRefer=DOTIdentifier SEMICOLON
    ;

OperationOverrideDeclaration
    :   kw=OPERATOR op=SupportOperator params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL functionBody=FunctionBody RCURL
    ;

NativeOperationOverrideDeclaration
    :   kw=OPERATOR op=SupportOperator params=FunctionParams (ARROW returnType=FunctionReturnType)? ASSIGNMENT javaRefer=DOTIdentifier SEMICOLON
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
//    |   Identifier
    ;

ClassFieldDeclaration
    :   kw+=VAR? id=Identifier (kw+=AS type_=Type)? (ASSIGNMENT initExpr=Expression)? accessor=Accessor? SEMICOLON
    ;

Accessor
    :   LCURL getter=Getter? setter=Setter? RCURL
    ;

Getter
    :   kw=GET LCURL functionBody=FunctionBody RCURL
    |   kw=GET ASSIGNMENT javaRefer=DOTIdentifier SEMICOLON
    |   kw=GET ASSIGNMENT expression=Expression SEMICOLON
    |   kw=GET SEMICOLON
    ;

Setter
    :   kw=SET LCURL functionBody=FunctionBody RCURL
    |   kw=SET ASSIGNMENT javaRefer=DOTIdentifier SEMICOLON
    |   kw=SET ASSIGNMENT expression=Expression SEMICOLON
    |   kw=SET SEMICOLON
    ;

GenericClassImplement
    :   kw+=IMPL (isStatic?=STATIC)? (isFinal?=FINAL)? (isAbstract?=ABSTRACT)? kw+=CLASS id=Identifier args=ReadOnlyArgs (COLON inheritance=ClassInHeritance)? (body=ClassBody | SEMICOLON)
    ;

//数据模板
TemplateDeclaration
    :   (isFinal?=FINAL)? kw+=DATA id=Identifier params=ReadOnlyParams? ((COLON TemplateInheritance) | kw+=AS type_=Type)? (body=TemplateBody | SEMICOLON)
    ;

TemplateInheritance
    :   extendedTemplateName+=[TemplateDeclaration:Identifier] (COMMA extendedTemplateName+=[TemplateDeclaration:Identifier])*
    ;

//数据模板
ObjectTemplateDeclaration
    :   (isFinal?=FINAL)? kw+=OBJECT kw+=DATA id=Identifier params=ReadOnlyParams? (COLON TemplateInheritance)? (body=TemplateBody | SEMICOLON)
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
    :   (isOverride?=OVERRIDE)? kw=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

TemplateFieldDeclaration
    :   (isConst?=CONST)? kw+=VAR? id=Identifier (kw+=AS type_=TemplateType)? (ASSIGNMENT initExpr=Expression)? accessor=Accessor? SEMICOLON
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
    :   kw=INTERFACE id=Identifier (COLON InterfaceInheritance)? (body=InterfaceBody | SEMICOLON)
    ;

InterfaceInheritance
    :   extendedInterfaceName+=[InterfaceDeclaration:Identifier] (COMMA extendedInterfaceName+=[InterfaceDeclaration:Identifier])*
    ;

InterfaceBody
    :   LCURL( doc_comment+=DocComment? annotation+=Annotation? interfaceFunctionDeclaration+=InterfaceFunctionDeclaration )* RCURL
    ;

InterfaceFunctionDeclaration
    :   kw=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? SEMICOLON
    ;

CompileTimeFuncDeclaration
    :   kw+=CONST kw+=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

InlineFunctionDeclaration
    :   kw+=INLINE kw+=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

//函数声明
FunctionDeclaration
    :   kw=FUNCTION id=Identifier params=FunctionParams? (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

ExtensionFunctionDeclaration
    :   kw=FUNCTION (targetType=Type DOT)? id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? LCURL body=FunctionBody RCURL
    ;

//枚举
EnumDeclaration
    :   kw=ENUM id=Identifier LCURL body=EnumBody RCURL
    ;

EnumBody
    :   enumMember+=EnumMember (COMMA enumMember+=EnumMember)*
    ;

EnumMember
    :   id=Identifier (ASSIGNMENT value=NbtValue)?
    ;

NamespaceID
    : (namespace=DOTIdentifier COLON)? id=Identifier
    ;

NativeFuncDeclaration
    :   kw=FUNCTION id=Identifier params=FunctionParams (ARROW returnType=FunctionReturnType)? ASSIGNMENT javaRefer=DOTIdentifier SEMICOLON
    ;

AccessModifier returns string
    :   PRIVATE
    |   PROTECTED
    |   PUBLIC
    ;

//构造函数声明
ClassConstructorDeclaration
    :   kw=CONSTRUCTOR params=NormalParams LCURL body=FunctionBody RCURL
    ;

//构造函数声明
TemplateConstructorDeclaration
    :   kw=CONSTRUCTOR params=NormalParams LCURL body=FunctionBody RCURL
    ;

//变量声明
FieldDeclaration
    :   fieldModifier=FieldModifier? kw+=VAR id=Identifier (kw+=AS type_=Type)? (ASSIGNMENT initExpr=Expression)?
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
    :   (isStatic?=STATIC)? kw+=VAR? (id=Identifier kw+=AS)? type_=Type (ASSIGNMENT defaultValue=Value)?
    ;

//表达式
Expression
    :   commonBinaryOperatorExpression=CommonBinaryOperatorExpression
    ;

//能作为语句的表达式
StatementExpression
    :   (leftExpr=VarWithSelector ASSIGNMENT)? rightExpr=Expression
    ;

//条件表达式
ConditionalExpression
    :   commonBinaryOperatorExpression=CommonBinaryOperatorExpression ( op+=QUEST thenExpr=Expression op+=COLON elseExpr=Expression)?
    ;

//其他运算符
CommonBinaryOperatorExpression
    :   conditionalOrExpression+=ConditionalOrExpression (op+=CommonBinaryOperator conditionalOrExpression+=ConditionalOrExpression)*
    ;

CommonBinaryOperator returns string: PIPE /*| Identifier*/;

//或
ConditionalOrExpression
    :   conditionalAndExpression+=ConditionalAndExpression ( op+=DISJ conditionalAndExpression+=ConditionalAndExpression )*
    ;

//与
ConditionalAndExpression
    :   equalityExpression+=EqualityExpression ( op+=CONJ equalityExpression+=EqualityExpression )*
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
    :   op=EXCL unaryExpression=UnaryExpression
    |   castExpression=CastExpression
    |   rightVarExpression=RightVarExpression
    ;

//右侧计算式取出的变量
RightVarExpression
    :   varWithSelector=VarWithSelector
    ;

//强制类型转换表达式
CastExpression
    :  rightVarExpression=RightVarExpression kw=AS type_=Type
    ;

VarWithSelector
    : jvmAccessExpression=JvmAccessExpression selector+=Selector*
    ;

JvmAccessExpression
    :   propertyOperator=PropertyOperator (op=COLONCOLON id=Identifier)?
    ;

//字段操作器
PropertyOperator
    :   primary=Primary (LSQUARE propertyOperatorExpression+=PropertyOperatorExpression (COMMA propertyOperatorExpression+=PropertyOperatorExpression)* RSQUARE)?
    ;

PropertyOperatorExpression
    :   id=[ClassFieldDeclaration:Identifier] | id=[TemplateFieldDeclaration:Identifier] ASSIGNMENT expr=Expression
    ;

//初级表达式
Primary
    :   range=Range
    |   value=Value
    |   var=Var
    |   this_=THIS
    |   super_=SUPER
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
    :   id=Identifier identifierSuffix+=IdentifierSuffix*
    ;

FunctionCall
    :   namespaceID=NamespaceID arguments=Arguments
    ;

IdentifierSuffix
    :   LSQUARE conditionalExpression=ConditionalExpression RSQUARE
    |   LSQUARE RSQUARE //empty bucket
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
    :   kw=EXECUTE LPAREN executeContext+=ExecuteContext (COMMA executeContext+=ExecuteContext)* RPAREN block=Block
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
    :   kw+=IF LPAREN conditionExpr=Expression RPAREN block=Block elseIfStatement+=ElseIfStatement* elseStatement=ElseStatement?
    ;

ElseIfStatement
    :   kw+=ELSE kw+=IF LPAREN conditionExpr=Expression RPAREN block=Block
    ;

ElseStatement
    :   kw+=ELSE block=Block
    ;

WhileStatement
    :   kw+=WHILE LPAREN conditionExpr=Expression RPAREN block=Block
    ;

DoWhileStatement
    :   kw+=DO block=Block kw+=WHILE LPAREN conditionExpr=Expression RPAREN
    ;

TryStoreStatement
    :   kw+=TRY block=Block kw+=STORE LPAREN identifier=Identifier RPAREN SEMICOLON
    ;

ReturnStatement
    :   kw+=RETURN Expression?
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
    |   className=NamespaceID args=ReadOnlyArgs?
    |   id=Identifier
    |   unionTemplateType=UnionTemplateType
    |   anonymousTemplateType=AnonymousTemplateType
    ;

AnonymousTemplateType
    :   kw=DATA (COLON extendedTemplateName+=NamespaceID (COMMA extendedTemplateName+=NamespaceID)*)? body=TemplateBody
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

Annotation
    :   kw=AT id=Identifier args=AnnotationArgs?
    ;

AnnotationArgs
    :   LANGLE (value+=Value (COMMA value+=Value)*)? RANGLE
    ;

Range
    :   num1=Var op=RANGE num2=Var
    |   num1=Var op=RANGE
    |   op=RANGE num2=Var
    ;

NbtValue
    :   str=LineString
    |   bool=NbtBool
    |   byte=NbtByte
    |   short=NbtShort
    |   int=NbtInt
    |   long=NbtLong
    |   float=NbtFloat
    |   double=NbtDouble
    |   compound=NBTCompound
    |   list=NBTList
    |   byteArray=NBTByteArray
    |   intArray=NBTIntArray
    |   longArray=NBTLongArray
    ;

NbtByte returns number: NBTByte;
NbtShort returns number: NBTShort;
NbtInt returns number: NBTInt;
NbtLong returns number: NBTLong;
NbtFloat returns number: NBTFloat;
NbtDouble returns number: NBTDouble;
NbtBool returns boolean: NBTBool;

NBTByteArray: NBT_BYTE_ARRAY_BEGIN e+=NbtByte (COMMA e+=NbtByte)* RSQUARE;
NBTIntArray: NBT_INT_ARRAY_BEGIN e+=NbtInt (COMMA e+=NbtInt)* RSQUARE;
NBTLongArray: NBT_LONG_ARRAY_BEGIN e+=NbtLong (COMMA e+=NbtLong)* RSQUARE;

NBTList: LSQUARE (expression += Expression (COMMA expression += Expression)* )* RSQUARE;
NBTKeyValuePair: key=Identifier COLON expression=Expression;
NBTCompound: LCURL( nbtKeyValuePair += NBTKeyValuePair (COMMA nbtKeyValuePair += NBTKeyValuePair)* )*RCURL;

DOTIdentifier returns string: Identifier (DOT Identifier)*;


//
// Whitespace and comments
//

DocComment
    :   doc=DOC_COMMENT
    ;