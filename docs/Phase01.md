# 阶段 01 交付记录

## 架构

Workbook 持有独立对象列表、模式和两套编辑状态。CanvasObject 使用带关联值的枚举区分文字、独立表格、媒体引用；对象使用稳定 UUID 和逻辑坐标 Frame。TableObject 使用稀疏单元格地址映射，公式仅存储表达式。当前 JSON 使用 Swift 合成 Codable 格式；正式文件格式与迁移策略留待持久化阶段确定。

UI → WorkbookStore → WorkbookCommand → Workbook。Store 使用 MainActor 隔离，SwiftUI 通过 Published 刷新。Command 统一修改模型与更新时间，为后续撤销、持久化和 AI 建议预留入口；当前不实现撤销栈或命令日志。画布和表格各自维护视口与选择状态，切换模式不相互覆盖。

WorkbookRepository 提供读写删除边界，AutosaveScheduling 提供排程和 flush 边界，MediaProviding 解析资产引用，AICommandProviding 仅返回待处理命令，FormulaEvaluating 隔离未来计算引擎。均无虚假服务实现；不调用网络。

采用系统列表、导航、分段控件和语义颜色，适应深色模式与动态字体。当前无浮动控件，因此未强加 Liquid Glass；后续若加入浮动工具栏，可在合适系统版本采用原生玻璃 API。

## 子任务记录

| 子任务 | 修改文件 | 检查 / 测试 | 遗留事项 |
| --- | --- | --- | --- |
| 仓库与工程 | CellSheet.xcodeproj、Package.swift、.gitignore | 远端元数据为空仓库；本地新建；工程静态结构检查 | Xcode 解析、包解析及编译待验证 |
| 模型与命令 | Core/Models.swift、Commands.swift、Services.swift | 已编写 4 项 XCTest；当前无 Swift 工具链，未运行 | 后续版本化文件格式、模型约束、撤销与服务实现 |
| 首页与导航 | CellSheetApp.swift、WorkbookStore.swift、LibraryView.swift | 静态检查创建后推入工作簿 ID、首页链接复用同一 Store | iPhone / iPad 实际交互待验证；仅内存存储 |
| 画布和模式 | WorkbookView.swift | 模型测试覆盖切换保留独立状态，未运行 | 画布当前为空态；平移缩放、对象编辑、表格编辑属后续阶段 |
| 检查与说明 | Tests/、.github/workflows/check.yml、README.md、本文 | 本地文件及工程引用静态检查；git diff --check | CI 尚未执行，不宣称构建或测试通过 |

## macOS 验收清单

1. 打开工程并确认本地 CellSheetCore 包解析成功；运行 `swift test`，确认 4 项测试通过。
2. 执行 README 中模拟器构建命令，确认 SwiftUI 与 iOS SDK 编译成功。
3. iPhone 和 iPad 分别运行：首页创建命名和空名称工作簿，默认进入自由画布。
4. 返回首页再打开；连续创建两个工作簿，确认标题与模式不串联。
5. 切换到表格空态再返回画布；确认无崩溃，导航返回正常。
6. 检查横竖屏、分屏、深色模式、较大字体与 VoiceOver 标签。
7. 确认用户可见的“仅本次运行保存”提示；退出后不应误以为有持久化。

阶段 01 待上述 macOS 验收后确认通过，未开始阶段 02。
