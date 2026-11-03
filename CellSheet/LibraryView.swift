import SwiftUI
import CellSheetCore

struct LibraryView: View {
    @EnvironmentObject private var store: WorkbookStore
    @State private var path: [UUID] = []
    @State private var creating = false
    @State private var title = ""

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    Label("自由组织你的想法", systemImage: "square.grid.3x3")
                        .font(.headline).padding(.vertical, 8)
                    Text("阶段 01 预览：工作簿仅保存在本次运行内，关闭 App 后不会保留。")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                Section("工作簿") {
                    if store.workbooks.isEmpty {
                        ContentUnavailableView("创建第一个工作簿", systemImage: "doc.badge.plus",
                                               description: Text("从一张空白自由画布开始。"))
                    }
                    ForEach(store.workbooks) { workbook in
                        NavigationLink(value: workbook.id) {
                            Label {
                                VStack(alignment: .leading) {
                                    Text(workbook.title)
                                    Text(workbook.updatedAt, style: .date)
                                        .font(.caption).foregroundStyle(.secondary)
                                }
                            } icon: { Image(systemName: "doc.richtext").foregroundStyle(.tint) }
                        }
                    }
                }
            }
            .navigationTitle("CellSheet")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { title = ""; creating = true } label: {
                        Label("新建工作簿", systemImage: "plus")
                    }.accessibilityIdentifier("createWorkbook")
                }
            }
            .alert("新建工作簿", isPresented: $creating) {
                TextField("工作簿名称", text: $title)
                Button("取消", role: .cancel) {}
                Button("创建") { path.append(store.create(title: title)) }
            }
            .navigationDestination(for: UUID.self) { id in WorkbookView(id: id) }
        }
    }
}
