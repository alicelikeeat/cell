import SwiftUI
import CellSheetCore

@MainActor
final class WorkbookStore: ObservableObject {
    @Published private(set) var workbooks: [Workbook] = []

    @discardableResult
    func create(title: String) -> UUID {
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let workbook = Workbook(title: trimmed.isEmpty ? "未命名工作簿" : trimmed)
        workbooks.insert(workbook, at: 0)
        return workbook.id
    }

    func workbook(id: UUID) -> Workbook? { workbooks.first { $0.id == id } }

    func send(_ command: WorkbookCommand, to id: UUID) {
        guard let index = workbooks.firstIndex(where: { $0.id == id }) else { return }
        command.apply(to: &workbooks[index])
    }
}
