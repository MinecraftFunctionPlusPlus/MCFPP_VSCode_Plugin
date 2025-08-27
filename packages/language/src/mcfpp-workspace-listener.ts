import { URI } from "langium";
import { McfppServices } from "./mcfpp-module.js";
import { WorkspaceIndexer } from "./mcfpp/indexer.js";

let indexer: WorkspaceIndexer;

export function registerWorkspaceListener(services: McfppServices) {
    indexer = new WorkspaceIndexer(services);
    const docs = services.shared.workspace.TextDocuments;
    docs.onDidChangeContent(e => {
        const uri = URI.parse(e.document.uri);
        const doc = services.shared.workspace.LangiumDocuments.getDocument(uri)!;
        services.shared.workspace.DocumentBuilder.build([doc]);
        indexer.collectSymbols(doc);
    })
}