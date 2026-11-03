import Foundation

// Contracts only. No background saving, media import or network/AI implementation in phase 01.
public protocol WorkbookRepository: Sendable {
    func loadAll() async throws -> [Workbook]
    func save(_ workbook: Workbook) async throws
    func delete(id: UUID) async throws
}

public protocol AutosaveScheduling: Sendable {
    func schedule(_ workbook: Workbook) async
    func flush() async throws
}

public protocol MediaProviding: Sendable {
    func resolve(_ reference: MediaReference) async throws -> URL
}

public protocol AICommandProviding: Sendable {
    func proposeCommands(prompt: String, workbook: Workbook) async throws -> [WorkbookCommand]
}

public protocol FormulaEvaluating: Sendable {
    func evaluate(_ expression: String, in table: TableObject) throws -> CellValue
}
