export interface FunctionSymbol {
    name: string;
    params: string[];
    variables: string[];
    returnType: string;   
}

export interface WorkspaceSymbols {
    functions: FunctionSymbol[];
}