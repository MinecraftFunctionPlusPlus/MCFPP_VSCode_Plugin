import { AstNode, AstNodeDescription, AstUtils, DefaultScopeComputation, LangiumDocument, LocalSymbols, MultiMap } from "langium";
import { LangiumServices } from "langium/lsp";
import { CancellationToken } from "vscode-jsonrpc";
import { CompilationUnit, isCompilationUnit, isFunctionDeclaration } from "./generated/ast.js";

export class MCFPPScopeComputation extends DefaultScopeComputation {
    constructor(services: LangiumServices){
        super(services);
    }

    override async collectExportedSymbols(document: LangiumDocument, cancelToken?: CancellationToken): Promise<AstNodeDescription[]> {
        const exportedDescriptions: AstNodeDescription[] = [];
        for(const childNode of (document.parseResult.value as CompilationUnit).typeDeclaration.filter(e => e.declaration.function).map(e => e.declaration.function)){
            if(isFunctionDeclaration(childNode)){
                const fullyQualifiedName = this.getQualifiedName(childNode, childNode.id);
                exportedDescriptions.push(this.descriptions.createDescription(childNode, fullyQualifiedName, document));
            }
        }
        return exportedDescriptions;
        
    }

    override async collectLocalSymbols(document: LangiumDocument, cancelToken?: CancellationToken): Promise<LocalSymbols> {
        const scopes = new MultiMap<AstNode, AstNodeDescription>();
        const localDescriptions: AstNodeDescription[] = []
        for(const childNode of (document.parseResult.value as CompilationUnit).typeDeclaration.filter(e => e.declaration.function).map(e => e.declaration.function)){
            if(isFunctionDeclaration(childNode)){
                localDescriptions.push(this.descriptions.createDescription(childNode, childNode.id, document));
            }
        }
        scopes.addAll(document.parseResult.value, localDescriptions);
        return scopes;
    }

    private getQualifiedName(node: AstNode, name: string): string{
        const namespace = this.getDeclaredNamespace(node);
        return namespace ? `${namespace}:${name}` : name;
    }

    private getDeclaredNamespace(node: AstNode): string | undefined {
        let root = AstUtils.findRootNode(node);
        if(isCompilationUnit(root)){
            return root.namespaceDeclaration?.id
        }
        return undefined;
    }
}