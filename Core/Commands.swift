import Foundation

public enum WorkbookCommand: Sendable {
    case rename(String)
    case setMode(EditorMode)
    case insert(CanvasObject)
    case remove(UUID)
    case setCanvasState(CanvasState)
    case setTableState(TableState)

    public func apply(to workbook: inout Workbook, at date: Date = Date()) {
        switch self {
        case .rename(let title):
            let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            workbook.title = trimmed
        case .setMode(let mode): workbook.mode = mode
        case .insert(let object):
            guard !workbook.objects.contains(where: { $0.id == object.id }) else { return }
            workbook.objects.append(object)
        case .remove(let id): workbook.objects.removeAll { $0.id == id }
        case .setCanvasState(let state): workbook.canvas = state
        case .setTableState(let state): workbook.table = state
        }
        workbook.updatedAt = date
    }
}
