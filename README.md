# CellSheet — 阶段 01

原生 iOS / iPadOS 自由画布电子表格应用。最低 iOS 17，使用 SwiftUI，无第三方依赖。

## 运行

在 macOS 使用 Xcode 15 或更新版本打开 `CellSheet.xcodeproj`，选择 `CellSheet` scheme 和 iPhone / iPad 模拟器，运行。
真机运行前需自行配置开发团队和唯一 Bundle Identifier。

```sh
swift test
xcodebuild -project CellSheet.xcodeproj -scheme CellSheet -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' CODE_SIGNING_ALLOWED=NO build
```

首页右上角“+”创建工作簿，创建后进入空白自由画布；返回首页可重新打开工作簿。顶部切换自由画布和表格模式。表格模式当前只有空态，不提供单元格编辑。

**阶段 01 使用内存存储，关闭 App 后数据不保留。** 未实现对象编辑、公式计算、媒体导入、自动保存、AI、视频处理或云端功能。

## 结构

- `Core/`：可独立测试的 Codable 数据模型、命令、服务协议；不依赖 SwiftUI。
- `CellSheet/`：SwiftUI App、首页、工作簿导航、画布空态及主线程内存 Store。
- `Tests/`：模型默认值、独立模式状态、JSON 往返和命令测试。
- `.github/workflows/check.yml`：macOS 核心测试及 iOS 模拟器编译。
- `docs/Phase01.md`：架构边界、子任务交付与验收记录。

本次执行环境为 Linux，未安装 Swift、Xcode 或 iOS SDK，未执行 Swift 单元测试或 iOS 编译。CI 配置已建立，尚无通过结果。macOS 待验证清单见阶段记录。
