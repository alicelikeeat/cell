import SwiftUI
import CellSheetCore

struct WorkbookView: View {
    @EnvironmentObject private var store: WorkbookStore
    let id: UUID

    var body: some View {
        Group {
            if let workbook = store.workbook(id: id) {
                VStack(spacing: 0) {
                    Picker("编辑模式", selection: Binding(
                        get: { workbook.mode },
                        set: { store.send(.setMode($0), to: id) }
                    )) {
                        Text("自由画布").tag(EditorMode.canvas)
                        Text("表格").tag(EditorMode.table)
                    }
                    .pickerStyle(.segmented).padding()
                    if workbook.mode == .canvas {
                        BlankCanvasView()
                    } else {
                        ContentUnavailableView("尚无表格", systemImage: "tablecells",
                                               description: Text("表格编辑将在后续阶段开放。切换模式会保留各自状态。"))
                    }
                }
                .navigationTitle(workbook.title)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                ContentUnavailableView("找不到工作簿", systemImage: "doc.questionmark")
            }
        }
    }
}

private struct BlankCanvasView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(uiColor: .systemBackground)
                Canvas { context, size in
                    let spacing: CGFloat = 24
                    for x in stride(from: spacing, to: size.width, by: spacing) {
                        for y in stride(from: spacing, to: size.height, by: spacing) {
                            context.fill(Path(ellipseIn: CGRect(x: x, y: y, width: 2, height: 2)),
                                         with: .color(.secondary.opacity(0.18)))
                        }
                    }
                }
                VStack(spacing: 12) {
                    Image(systemName: "square.dashed").font(.largeTitle)
                    Text("空白自由画布").font(.title3.weight(.semibold))
                    Text("这里将承载独立表格、文字和媒体对象。")
                        .font(.subheadline).multilineTextAlignment(.center)
                }
                .foregroundStyle(.secondary).padding(24)
                .frame(maxWidth: min(geometry.size.width, 400))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("freeCanvas")
    }
}
