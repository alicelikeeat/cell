import Foundation

public struct Point: Codable, Equatable, Sendable {
    public var x: Double = 0
    public var y: Double = 0
    public init(x: Double = 0, y: Double = 0) { self.x = x; self.y = y }
}

public struct ObjectFrame: Codable, Equatable, Sendable {
    public var origin = Point()
    public var width: Double = 320
    public var height: Double = 200
    public init() {}
}

public enum CellValue: Codable, Equatable, Sendable {
    case text(String), number(Double), formula(String)
}

public struct CellAddress: Codable, Hashable, Sendable {
    public let row: Int
    public let column: Int
    public init(row: Int, column: Int) { self.row = row; self.column = column }
}

public struct TableObject: Identifiable, Codable, Equatable, Sendable {
    public var id = UUID()
    public var name = "表格"
    public var rowCount = 100
    public var columnCount = 26
    public var cells: [CellAddress: CellValue] = [:]
    public init() {}
}

public struct MediaReference: Codable, Equatable, Sendable {
    public enum Kind: String, Codable, Sendable { case image, audio, video }
    public var assetID: UUID
    public var kind: Kind
    public init(assetID: UUID, kind: Kind) { self.assetID = assetID; self.kind = kind }
}

public enum ObjectContent: Codable, Equatable, Sendable {
    case text(String), table(TableObject), media(MediaReference)
}

public struct CanvasObject: Identifiable, Codable, Equatable, Sendable {
    public var id = UUID()
    public var frame = ObjectFrame()
    public var content: ObjectContent
    public init(content: ObjectContent) { self.content = content }
}

public struct CanvasState: Codable, Equatable, Sendable {
    public var offset = Point()
    public var zoom: Double = 1
    public var selectedObjectID: UUID?
    public init() {}
}

public struct TableState: Codable, Equatable, Sendable {
    public var activeTableID: UUID?
    public var selectedCell: CellAddress?
    public var scrollOffset = Point()
    public init() {}
}

public enum EditorMode: String, CaseIterable, Codable, Sendable {
    case canvas, table
}

public struct Workbook: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var title: String
    public var updatedAt: Date
    public var objects: [CanvasObject] = []
    public var mode: EditorMode = .canvas
    public var canvas = CanvasState()
    public var table = TableState()
    public init(id: UUID = UUID(), title: String = "未命名工作簿", updatedAt: Date = Date()) {
        self.id = id; self.title = title; self.updatedAt = updatedAt
    }
}
