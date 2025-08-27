import { DefaultCompletionProvider} from "langium/lsp";
//import { WorkspaceSymbols } from "../mcfpp/symbols.js";
// import { LangiumDocument} from "langium";
// import { CancellationToken } from "vscode-jsonrpc";
// import { CompletionList, CompletionParams } from "vscode-languageserver-protocol";
import { McfppServices } from "../mcfpp-module.js";

export class MCFPPCompletionProvider extends DefaultCompletionProvider {
    constructor(service: McfppServices, /*private symbols: WorkspaceSymbols*/){
        super(service)
    }
    
    // override getCompletion(document: LangiumDocument, params: CompletionParams, _cancelToken?: CancellationToken): Promise<CompletionList | undefined> {
        
    //     return [];
    // }
}