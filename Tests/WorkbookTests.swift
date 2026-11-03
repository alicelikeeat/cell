import XCTest
@testable import CellSheetCore

final class WorkbookTests: XCTestCase {
    func testNewWorkbookStartsInFreeCanvas() {
        let workbook = Workbook()
        XCTAssertEqual(workbook.mode, .canvas)
        XCTAssertTrue(workbook.objects.isEmpty)
        XCTAssertNil(workbook.table.activeTableID)
    }

    func testModeSwitchPreservesIndependentStates() {
        var workbook = Workbook()
        var canvas = CanvasState()
        canvas.offset = Point(x: 120, y: 80)
        canvas.zoom = 2
        var table = TableState()
        table.activeTableID = UUID()
        table.selectedCell = CellAddress(row: 3, column: 5)
        WorkbookCommand.setCanvasState(canvas).apply(to: &workbook)
        WorkbookCommand.setMode(.table).apply(to: &workbook)
        WorkbookCommand.setTableState(table).apply(to: &workbook)
        WorkbookCommand.setMode(.canvas).apply(to: &workbook)
        XCTAssertEqual(workbook.canvas, canvas)
        XCTAssertEqual(workbook.table, table)
    }

    func testDocumentRoundTripIncludingObjectsAndCells() throws {
        var workbook = Workbook(title: "预算")
        var table = TableObject()
        table.cells[CellAddress(row: 0, column: 0)] = .formula("=1+2")
        workbook.objects = [CanvasObject(content: .table(table)),
                            CanvasObject(content: .text("备注")),
                            CanvasObject(content: .media(MediaReference(assetID: UUID(), kind: .image)))]
        let data = try JSONEncoder().encode(workbook)
        XCTAssertEqual(try JSONDecoder().decode(Workbook.self, from: data), workbook)
    }

    func testCommandsRejectDuplicateAndBlankTitle() {
        var workbook = Workbook(title: "原名")
        let object = CanvasObject(content: .text("A"))
        WorkbookCommand.insert(object).apply(to: &workbook)
        WorkbookCommand.insert(object).apply(to: &workbook)
        XCTAssertEqual(workbook.objects.count, 1)
        WorkbookCommand.rename(" \n ").apply(to: &workbook)
        XCTAssertEqual(workbook.title, "原名")
        let date = Date(timeIntervalSince1970: 100)
        WorkbookCommand.rename(" 新名 ").apply(to: &workbook, at: date)
        XCTAssertEqual(workbook.title, "新名")
        XCTAssertEqual(workbook.updatedAt, date)
        WorkbookCommand.remove(object.id).apply(to: &workbook)
        XCTAssertTrue(workbook.objects.isEmpty)
    }
}
