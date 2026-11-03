import SwiftUI

@main
struct CellSheetApp: App {
    @StateObject private var store = WorkbookStore()
    var body: some Scene {
        WindowGroup {
            LibraryView().environmentObject(store)
        }
    }
}
