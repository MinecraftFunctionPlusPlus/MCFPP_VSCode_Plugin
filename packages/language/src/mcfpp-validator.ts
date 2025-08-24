import type { ValidationAcceptor, ValidationChecks } from 'langium';
import type { McfppAstType, CompilationUnit } from './generated/ast.js';
import type { McfppServices } from './mcfpp-module.js';

/**
 * Register custom validation checks.
 */
export function registerValidationChecks(services: McfppServices) {
    const registry = services.validation.ValidationRegistry;
    const validator = services.validation.McfppValidator;
    const checks: ValidationChecks<McfppAstType> = {
    };
    registry.register(checks, validator);
}

/**
 * Implementation of custom validations.
 */
export class McfppValidator {

}
