import { AstNode } from "langium";
import {
    AbstractSemanticTokenProvider,
    SemanticTokenAcceptor,
} from "langium/lsp";
import {
    isAbstractClassFunctionDeclaration,
    isAdditiveExpression,
    isAnnotation,
    isAnonymousTemplateType,
    isCastExpression,
    isClassConstructorDeclaration,
    isClassDeclaration,
    isClassFieldDeclaration,
    isClassFunctionDeclaration,
    isClassMemberDeclaration,
    isCommonBinaryOperatorExpression,
    isCompileTimeClassDeclaration,
    isCompileTimeFuncDeclaration,
    isConditionalAndExpression,
    isConditionalExpression,
    isConditionalOrExpression,
    isCoordinate,
    isDoWhileStatement,
    isElseIfStatement,
    isElseStatement,
    isEnumDeclaration,
    isEnumMember,
    isEqualityExpression,
    isExecuteContext,
    isExecuteStatement,
    isExtensionFunctionDeclaration,
    isFieldDeclaration,
    isFunctionCall,
    isFunctionDeclaration,
    isGenericClassImplement,
    isGetter,
    isIfStatement,
    isImportDeclaration,
    isImportType,
    isInlineFunctionDeclaration,
    isInterfaceDeclaration,
    isInterfaceFunctionDeclaration,
    isJvmAccessExpression,
    isMultiplicativeExpression,
    isNamespaceDeclaration,
    isNativeClassDeclaration,
    isNativeClassFunctionDeclaration,
    isNativeFuncDeclaration,
    isNativeOperationOverrideDeclaration,
    isNBTByteArray,
    isNBTIntArray,
    isNBTKeyValuePair,
    isNBTLongArray,
    isNbtValue,
    isObjectClassDeclaration,
    isObjectTemplateDeclaration,
    isOperationOverrideDeclaration,
    isParameter,
    isPrimary,
    isPropertyOperatorExpression,
    isRange,
    isRelationalExpression,
    isReturnStatement,
    isSetter,
    isStatement,
    isTemplateConstructorDeclaration,
    isTemplateDeclaration,
    isTemplateFieldDeclaration,
    isTemplateFunctionDeclaration,
    isTemplateMemberDeclaration,
    isTryStoreStatement,
    isTypealiasDeclaration,
    isUnaryExpression,
    isVarWithSuffix,
    isWhileStatement,
} from "../generated/ast.js";
import { SemanticTokenTypes } from "vscode-languageserver";

const highlightMap: Array<{
    check: Array<(node: AstNode) => boolean>;
    props: Record<string, SemanticTokenTypes>;
}> = [
        {
            check: [isNamespaceDeclaration],
            props: { 
                id: SemanticTokenTypes.namespace,
                kw: SemanticTokenTypes.keyword
            },
        },
        {
            check: [isImportDeclaration],
            props: {
                asIdentifier: SemanticTokenTypes.type,
                fromIdentifier: SemanticTokenTypes.namespace,
                kw: SemanticTokenTypes.keyword
            },
        },
        {
            check: [isImportType],
            props: {
                namespace: SemanticTokenTypes.namespace,
                id: SemanticTokenTypes.type,
            },
        },
        { 
            check: [isTypealiasDeclaration], 
            props: { 
                type_: SemanticTokenTypes.type,
                id: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            } 
        },
        { 
            check: [isClassDeclaration, isObjectClassDeclaration, isCompileTimeClassDeclaration, isGenericClassImplement], 
            props: { 
                id: SemanticTokenTypes.struct,
                extendedClassName: SemanticTokenTypes.struct,//TODO 继承结构的时候的着色依然用的class
                isStatic: SemanticTokenTypes.keyword,
                isFinal: SemanticTokenTypes.keyword,
                isAbstract: SemanticTokenTypes.keyword,
                kw: SemanticTokenTypes.keyword
            }
        },
        { 
            check: [isNativeClassDeclaration], 
            props: { 
                id: SemanticTokenTypes.struct,
                javaRefer: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            }
        },
        { 
            check: [isClassFunctionDeclaration, isAbstractClassFunctionDeclaration, isTemplateFunctionDeclaration],  
            props: { 
                id: SemanticTokenTypes.function,
                returnType: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword,
                isOverride: SemanticTokenTypes.keyword
            }
        },
        { 
            check: [isInterfaceFunctionDeclaration, isCompileTimeFuncDeclaration, isInlineFunctionDeclaration, isFunctionDeclaration],
            props: { 
                id: SemanticTokenTypes.function,
                returnType: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            }
        },
        { 
            check:  [isNativeClassFunctionDeclaration],  
            props: { 
                id: SemanticTokenTypes.function,
                returnType: SemanticTokenTypes.type,
                javaRefer: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword,
                isOverride: SemanticTokenTypes.keyword
            }
        },
        { 
            check:  [isNativeFuncDeclaration],  
            props: { 
                id: SemanticTokenTypes.function,
                returnType: SemanticTokenTypes.type,
                javaRefer: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            }
        },
        { 
            check: [isOperationOverrideDeclaration, isNativeOperationOverrideDeclaration], 
            props: { 
                op: SemanticTokenTypes.operator,
                returnType: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isClassMemberDeclaration, isTemplateMemberDeclaration],
            props: {
                accessModifier: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isClassFieldDeclaration, isTemplateFieldDeclaration],
            props: {
                id: SemanticTokenTypes.property,
                type_: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isGetter, isSetter],
            props: {
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isTemplateDeclaration, isObjectTemplateDeclaration],
            props: {
                id: SemanticTokenTypes.class,
                extendedTemplateName: SemanticTokenTypes.class,
                type_: SemanticTokenTypes.type
            }
        },
        {
            check: [isInterfaceDeclaration],
            props: {
                id: SemanticTokenTypes.interface,
                extendedInterfaceName: SemanticTokenTypes.interface
            }
        },
        {
            check: [isExtensionFunctionDeclaration],
            props: {
                id: SemanticTokenTypes.function,
                targetType: SemanticTokenTypes.type,
                returnType: SemanticTokenTypes.type
            }
        },
        {
            check: [isEnumDeclaration],
            props: {
                id: SemanticTokenTypes.enum,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isEnumMember],
            props: {
                id: SemanticTokenTypes.enumMember
            }
        },
        {
            check: [isClassConstructorDeclaration, isTemplateConstructorDeclaration],
            props: {
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isFieldDeclaration],
            props: {
                id: SemanticTokenTypes.variable,
                type_: SemanticTokenTypes.type,
                fieldModifier: SemanticTokenTypes.keyword,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isParameter],
            props: {
                id: SemanticTokenTypes.parameter,
                type_: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isConditionalExpression, isCommonBinaryOperatorExpression, isConditionalOrExpression, isConditionalAndExpression, isEqualityExpression, isRelationalExpression, isAdditiveExpression, isMultiplicativeExpression, isUnaryExpression],
            props: {
                op: SemanticTokenTypes.operator
            }
        },
        {
            check: [isCastExpression],
            props: {
                type_: SemanticTokenTypes.type,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isJvmAccessExpression],
            props: {
                op: SemanticTokenTypes.operator,
                id: SemanticTokenTypes.property
            }
        },
        {
            check: [isPropertyOperatorExpression],
            props: {
                id: SemanticTokenTypes.property
            }
        },
        {
            check: [isPrimary],
            props: {
                this_: SemanticTokenTypes.keyword,
                super_: SemanticTokenTypes.keyword,
                type_: SemanticTokenTypes.type
            }
        },
        {
            check: [isFunctionCall],
            props: { 
                namespaceID: SemanticTokenTypes.function 
            },
        },
        {
            check: [isStatement],
            props: {
                controlStatement: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isExecuteStatement, isIfStatement, isElseIfStatement, isElseStatement, isWhileStatement, isDoWhileStatement, isTryStoreStatement, isReturnStatement],
            props: {
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isExecuteContext],
            props: {
                executeExpression: SemanticTokenTypes.property
            }
        },
        {
            check: [isTryStoreStatement],
            props: {
                id: SemanticTokenTypes.variable
            }
        },
        {
            check: [isAnonymousTemplateType],
            props: {
                extendedTemplateName: SemanticTokenTypes.class,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isCoordinate],
            props: {
                coordinateDimension: SemanticTokenTypes.number
            }
        },
        {
            check: [isAnnotation],
            props: {
                id: SemanticTokenTypes.decorator,
                kw: SemanticTokenTypes.keyword
            }
        },
        {
            check: [isRange],
            props: {
                op: SemanticTokenTypes.operator
            }
        },
        {
            check: [isNbtValue],
            props: {
                str: SemanticTokenTypes.string,
                bool: SemanticTokenTypes.keyword,
                byte: SemanticTokenTypes.number,
                short: SemanticTokenTypes.number,
                long: SemanticTokenTypes.number,
                float: SemanticTokenTypes.number,
                double: SemanticTokenTypes.number
            }
        },
        {
            check: [isNBTByteArray, isNBTIntArray, isNBTLongArray],
            props: {
                e: SemanticTokenTypes.number
            }
        },
        {
            check: [isNBTKeyValuePair],
            props: {
                key: SemanticTokenTypes.property
            }
        }
    ];

function isInSelector(node: AstNode): boolean {
    if(!isVarWithSuffix(node)) return false;
    return !isPrimary(node.$container.$container);
}

export class MCFPPSemanticTokenProvider extends AbstractSemanticTokenProvider {
    protected override highlightElement(
        node: AstNode,
        acceptor: SemanticTokenAcceptor
    ): void {
        for (const entry of highlightMap) {
            if (entry.check.some(fn => fn(node))) {
                for (const [property, type] of Object.entries(entry.props)) {
                    if(property in node){
                        acceptor({
                            node,
                            property,
                            type,
                        });
                    }
                }
                break;
            }
        }
        if(isVarWithSuffix(node)){
            acceptor({
                    node,
                    property: 'id',
                    type: isInSelector(node)?SemanticTokenTypes.property:SemanticTokenTypes.variable
                });
        }
    }
}
