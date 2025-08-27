import { AstNode, AstUtils, LangiumDocument } from "langium";
import { McfppServices } from "../mcfpp-module.js";
import { FunctionSymbol, WorkspaceSymbols } from "./symbols.js";
import { isFunctionDeclaration } from "../generated/ast.js";

export class WorkspaceIndexer {
    private symbols: WorkspaceSymbols = {functions:[]}

    constructor(private services: McfppServices){}

    async indexWorkspace(){
        const allDocs = this.services.shared.workspace.LangiumDocuments.all;
        for (const doc of allDocs) {
            this.collectSymbols(doc);
        }
    }

    collectSymbols(document: LangiumDocument<AstNode>) {
        const root = document.parseResult.value;
        AstUtils.streamAst(root).forEach(node => {
            if(isFunctionDeclaration(node)){
                const func: FunctionSymbol = {
                    name: node.id,
                    params: node.params?.normalParams?.parameterList?.parameter?.map(p => p.id!) ?? [],
                    variables: [],
                    returnType: node.returnType?.$cstNode?.text ?? "void"
                };
                this.symbols.functions.push(func);
            }
        })
    }
}