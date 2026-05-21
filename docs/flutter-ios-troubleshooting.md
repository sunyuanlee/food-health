# Flutter iOS 真机调试问题汇总

> 适用场景：从零搭建 Flutter 项目并部署到 iOS 真机  
> 环境：macOS + Flutter 3.41.9 + iOS 真机（iOS 26）+ Xcode

---

## 问题 1：设备不被项目支持

**错误信息**

```
The following devices were found, but are not supported by this project
```

**原因**  
通过脚手架方式只生成了 `lib/` 代码目录，缺少 `ios/`、`android/` 等平台原生目录。

**解决方案**  
在项目根目录执行，自动补齐所有平台目录（不会覆盖已有 `lib/` 和 `pubspec.yaml`）：

```bash
flutter create --org com.your_org --project-name your_app .
```

---

## 问题 2：iOS 真机签名失败

**错误信息**

```
Provisioning profile "iOS Team Provisioning Profile: *" doesn't include signing certificate "Apple Development: xxx"
Provisioning profile doesn't include the currently selected device
```

**原因**  
Xcode 未配置开发者账号，或真机设备尚未注册到 Provisioning Profile。

**解决方案**

1. Xcode → Settings → Accounts → 添加 Apple ID
2. 用 `.xcworkspace` 打开项目：`open ios/Runner.xcworkspace`
3. 选中 TARGETS → Runner → **Signing & Capabilities**
4. 勾选 **Automatically manage signing**，Team 选择自己的账号
5. Xcode 弹出 "Register Device" 时点击确认

> 免费 Apple ID 也可真机调试，但签名证书有效期为 7 天，到期需重新运行。

---

## 问题 3：Apple 开发者协议未更新（PLA）

**错误信息**

```
Unable to process request - PLA Update available
You currently don't have access to this membership resource.
```

**原因**  
Apple 更新了 Program License Agreement，未同意前拒绝所有签名服务请求。

**解决方案**

1. 打开 <https://developer.apple.com/account>
2. 登录 Apple ID，同意页面顶部黄色横幅中的最新协议
3. 回到 Xcode → Product → **Clean Build Folder**，重新运行

---

## 问题 4：Dart VM 连接超时

**错误信息**

```
The Dart VM Service was not discovered after 60 seconds.
This is taking much longer than expected...
```

**原因**  
iOS 14+ 要求 App 在 `Info.plist` 中声明本地网络权限，否则系统阻止 Flutter 调试连接。

**解决方案**  
在 `ios/Runner/Info.plist` 的 `<dict>` 内添加：

```xml
<key>NSLocalNetworkUsageDescription</key>
<string>该应用需要访问本地网络以支持调试和设备通信。</string>
<key>NSBonjourServices</key>
<array>
    <string>_dartobservatory._tcp</string>
    <string>_dart._tcp</string>
</array>
```

**注意事项**

- Mac 和 iPhone 必须连接同一 WiFi
- 首次运行时 iPhone 会弹出本地网络权限弹窗，点击「允许」
- 如仍超时，可用 `flutter run --release` 绕过（不支持热重载）

---

## 问题 5：iOS 26 真机 JIT 崩溃（mprotect）

**错误信息**

```
mprotect failed: 13 (Permission denied)
dart::StubCode::Init() ...
Crash occurred when compiling unknown function in unoptimized JIT mode
```

**原因**  
iOS 26 收紧了 JIT 内存写+执行权限策略，Flutter 3.27.1（Dart VM 3.6.0）不兼容。

**解决方案**

临时绕过（不支持热重载）：

```bash
flutter run --release -d <device-id>
```

根本解决（推荐）：

```bash
flutter upgrade
# 升级到 Flutter 3.41.9+，已修复 iOS 26 JIT 兼容性
```

---

## 问题 6：Flutter 升级后依赖冲突

**错误信息**

```
Because custom_lint >=0.6.5 <0.7.1 depends on analyzer ^6.6.0 ...
dazi_app depends on custom_lint ^0.6.7, version solving failed.
```

**原因**  
Flutter 升级后 Dart SDK 版本随之升级，旧版 `custom_lint` / `riverpod_lint` 与新 SDK 不兼容。

**解决方案**  
在 `pubspec.yaml` 中升级 dev 依赖：

```yaml
dev_dependencies:
  custom_lint: ^0.7.6 # 原 ^0.6.7
  riverpod_lint: ^2.6.5 # 原 ^2.3.13
```

然后执行：

```bash
flutter pub get
```

> ⚠️ 注意：`custom_lint 0.7.x` 与 `riverpod_lint 3.x` 不兼容，不能同时升到最新版，需保持 `riverpod_lint ^2.6.5`。

---

## 问题 7：Flutter 升级后 API 破坏性变更

**错误信息**

```
The argument type 'CardTheme' can't be assigned to the parameter type 'CardThemeData?'
```

**原因**  
Flutter 3.41.9 将 `ThemeData.cardTheme` 的参数类型从 `CardTheme` 改为 `CardThemeData`。

**解决方案**

```dart
// 修改前
cardTheme: CardTheme( ... )

// 修改后
cardTheme: CardThemeData( ... )
```

> 每次大版本升级后执行以下命令，集中定位所有破坏性变更：
>
> ```bash
> dart analyze lib/
> ```

---

## 问题 8：Framework 'Pods_Runner' not found

**错误信息（Xcode 构建时）**

```
Framework 'Pods_Runner' not found
Linker command failed with exit code 1
```

**原因**  
Flutter 升级后，iOS 的 CocoaPods 依赖未重新安装。

**解决方案**

```bash
cd ios && pod install
```

同时在 `ios/Podfile` 中取消注释并指定最低 iOS 版本（消除 warning）：

```ruby
platform :ios, '16.0'
```

> ⚠️ 重要：打开 iOS 项目时必须使用 `.xcworkspace`，不能使用 `.xcodeproj`：
>
> ```bash
> open ios/Runner.xcworkspace
> ```

---

## 快速检查清单

遇到 `flutter run` 失败时，按顺序排查：

| 序号 | 检查项                        | 命令 / 位置                                            |
| ---- | ----------------------------- | ------------------------------------------------------ |
| 1    | 平台原生目录是否存在          | `ls ios/ android/`                                     |
| 2    | Flutter 依赖是否安装          | `flutter pub get`                                      |
| 3    | CocoaPods 是否安装            | `cd ios && pod install`                                |
| 4    | 用 xcworkspace 打开项目       | `open ios/Runner.xcworkspace`                          |
| 5    | Xcode 代码签名是否配置        | Signing & Capabilities → Automatically manage signing  |
| 6    | Apple 开发者协议是否最新      | <https://developer.apple.com/account>                    |
| 7    | Info.plist 是否有本地网络权限 | `NSLocalNetworkUsageDescription` + `NSBonjourServices` |
| 8    | Flutter 版本是否兼容目标 iOS  | `flutter upgrade`                                      |

> ⚠️ 重要：打开 iOS 项目时必须使用 `.xcworkspace`，不能使用 `.xcodeproj`：
>
> ```bash
> open ios/Runner.xcworkspace
> ```

---

## 快速检查清单

遇到 `flutter run` 失败时，按顺序排查：

| 序号 | 检查项                        | 命令 / 位置                                            |
| ---- | ----------------------------- | ------------------------------------------------------ |
| 1    | 平台原生目录是否存在          | `ls ios/ android/`                                     |
| 2    | Flutter 依赖是否安装          | `flutter pub get`                                      |
| 3    | CocoaPods 是否安装            | `cd ios && pod install`                                |
| 4    | 用 xcworkspace 打开项目       | `open ios/Runner.xcworkspace`                          |
| 5    | Xcode 代码签名是否配置        | Signing & Capabilities → Automatically manage signing  |
| 6    | Apple 开发者协议是否最新      | <https://developer.apple.com/account>                  |
| 7    | Info.plist 是否有本地网络权限 | `NSLocalNetworkUsageDescription` + `NSBonjourServices` |
| 8    | Flutter 版本是否兼容目标 iOS  | `flutter upgrade`                                      |

---

## 阿里云号码认证（ATAuthSDK）集成问题汇总

> 适用场景：Flutter + NestJS 项目集成阿里云手机号一键登录  
> SDK 版本：ATAuthSDK v2.14.17（静态库，手动集成）

---

### 问题 A：ATAuthSDK 是静态库，必须加 `-ObjC` 链接标记

**现象**  
运行时崩溃：`unrecognized selector sent to instance`，涉及 `dismissController:model:isFullScreen:completion:` 等方法。

**原因**  
ATAuthSDK 是 `current ar archive`（静态库），其内部的 Objective-C Category（如 `UIViewController(PNSAnimation)`）在链接时默认不会被加载，导致运行时找不到方法。

**解决方案**  
在 `ios/Flutter/Debug.xcconfig` 和 `Release.xcconfig` 中添加：

```
OTHER_LDFLAGS = $(inherited) -ObjC
```

> ⚠️ 不要在 Swift 里手动添加 `UIViewController` Extension 来"补齐"缺失方法——SDK 的 Category 加载后会与自定义 Extension 冲突。`-ObjC` 才是正确解法。

---

### 问题 B：TXCustomModel 被 ARC 提前释放导致 EXC_BAD_ACCESS

**现象**  
点击"一键登录"按钮后 App 崩溃，崩溃在 `objc_retain`，调用栈涉及 ATAuthSDK 回调。

**原因**  
`TXCustomModel` 对象在方法局部变量作用域结束后被 ARC 释放，而 SDK 的异步回调持有了该对象的指针。

**解决方案**  
将 `TXCustomModel` 保存为 `AppDelegate` 的实例变量：

```swift
class AppDelegate: FlutterAppDelegate {
    private var loginModel: TXCustomModel?

    private func handleGetLoginToken(...) {
        let model = TXCustomModel()
        self.loginModel = model  // 持有引用，防止 ARC 释放
        // ...
        // 回调完成后清理
        self.loginModel = nil
    }
}
```

---

### 问题 C：SDK 回调的"中间状态码"被误判为错误

**现象**  
点击"一键登录"按钮后，iOS 层立即回调错误给 Flutter，报错 code 700002（"点击了登录按钮"）。

**原因**  
ATAuthSDK 的 completion 回调会多次调用，包含多种中间状态事件码（700xxx 系列）。代码未过滤这些事件码，将其当作错误处理。

**解决方案**  
在回调中过滤掉中间状态码，只处理最终结果：

```swift
// 600000 = 成功，700xxx = 各类中间事件（不是错误），600001 = 授权页已展示
let intermediaryCodes = ["600001", "700000", "700001", "700002", "700003", "700004", "700005"]

if intermediaryCodes.contains(code) {
    return  // 忽略中间状态，继续等待最终结果
}
if code == "600000" {
    // 登录成功
} else {
    // 真正的错误
}
```

---

### 问题 D：iOS ATS 阻止 HTTP 请求

**现象**  
真机无法访问局域网 IP 或非 HTTPS 地址，`flutter: DioException connection refused`。

**原因**  
iOS 9+ 的 App Transport Security (ATS) 默认只允许 HTTPS 请求。`NSExceptionDomains` 对 IP 地址不生效。

**解决方案（仅开发环境）**  
在 `ios/Runner/Info.plist` 中添加：

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

> ⚠️ 生产环境务必移除，改用 HTTPS 域名 + `NSExceptionDomains` 白名单。

---

### 问题 E：号码认证 SDK 必须走移动数据网络

**现象**  
纯 WiFi 环境下调用 `prefetch` 或 `getLoginToken`，SDK 报超时错误：  
`NSURLErrorDomain Code=-1001 "The request timed out."`，目标地址为 `dypnsapi-dualstack.aliyuncs.com`。

**原因**  
号码认证原理是通过运营商移动数据通道验证本机号码，必须使用移动数据网络。纯 WiFi 无法建立运营商通道。

**解决方案**  
测试时在手机上开启蜂窝数据（WiFi 可同时保持连接）：  
设置 → 蜂窝网络 → 打开蜂窝数据

---

### 问题 F：app 启动白屏（main() 中 await 网络请求阻塞 runApp）

**现象**  
App 启动后长时间白屏（最长 10 秒），等于 `connectTimeout` 时长。

**原因**  
`main()` 中在 `runApp()` 之前 `await restoreSession()`，而 `restoreSession` 会请求 `/auth/me`。当 baseUrl 的服务器不可达时（例如 localhost.run 隧道过期），该请求需等待超时才能继续，期间 Flutter 引擎已初始化但没有 Widget 可渲染 → 白屏。

**解决方案**  
去掉 `await`，让 `runApp()` 立即执行，由 Splash 页面监听 auth 状态变化后跳转：

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.instance.init();

  final container = ProviderContainer();
  container.read(authProvider.notifier).restoreSession(); // 不 await
  runApp(UncontrolledProviderScope(container: container, child: const DaziApp()));
}
```

```dart
// splash_page.dart - 监听 auth 状态，完成后自动跳转
ref.listen<AuthState>(authProvider, (_, state) {
  if (state is AuthAuthenticated) context.go(AppRoutes.home);
});
```

---

### 问题 G：阿里云 GetMobile SDK 参数名错误

**现象**  
后端调用阿里云 `getMobile` 接口时始终报 `MissingAccessToken: code: 400`。

**原因**  
`@alicloud/dypnsapi20170525` SDK 的 `GetMobileRequest` 参数名是 `accessToken`，误写成了 `accessCode`。

**解决方案**

```typescript
// 错误
const request = new GetMobileRequest({ accessCode: token });

// 正确
const request = new GetMobileRequest({ accessToken: token });
```

> 验证方法：用错误 token 测试，应返回 `isv.ACCESS_CODE_ILLEGAL` 而不是 `MissingAccessToken`。前者说明鉴权通过、token 本身无效；后者说明参数传错了。

---

### 问题 H：GetMobile 响应中手机号的字段路径错误

**现象**  
阿里云返回 200 成功，但后端取到的手机号是 `undefined`，Prisma 写库报错 → 500。

**原因**  
手机号不在 `response.body.mobile`，而在嵌套对象 `response.body.getMobileResultDTO.mobile`。

**解决方案**

```typescript
// 错误
return body.mobile!;

// 正确
const mobile = body.getMobileResultDTO?.mobile;
if (!mobile) throw new UnauthorizedException("号码认证失败: 未返回手机号");
return mobile;
```

> 排查方法：查看 SDK 类型定义文件确认字段路径：
>
> ```bash
> cat node_modules/@alicloud/dypnsapi20170525/dist/models/GetMobileResponseBody.d.ts
> ```

---

### 问题 I：Prisma 数据库表不存在（P2021）

**现象**  
后端报错：`The table 'main.User' does not exist in the current database`。

**原因**  
数据库文件存在，但从未执行过迁移（或迁移文件与数据库不同步）。

**解决方案**

```bash
# 开发环境：强制同步 schema（会清空数据）
cd dazi-app-server && npx prisma db push --force-reset

# 生产环境：执行迁移
npx prisma migrate deploy
```

> 状态检查：`npx prisma migrate status`

---

### 问题 J：flutter run 卡在 "Installing and launching..."

**现象**  
Xcode 编译成功，但 `flutter run` 卡在 "Installing and launching..." 超过 10 分钟。

**原因及解决方案**

| 可能原因                           | 解决方式                                                                           |
| ---------------------------------- | ---------------------------------------------------------------------------------- |
| 手机需要信任开发者证书             | 设置 → 通用 → VPN与设备管理 → 信任                                                 |
| macOS 本地网络权限未授予           | 系统设置 → 隐私与安全性 → 本地网络 → 开启 dart                                     |
| Flutter CLI 与 iOS 26 设备通信异常 | 改用 Xcode 直接运行（`open ios/Runner.xcworkspace`），再用 `flutter attach` 热重载 |

**推荐开发工作流（iOS 26 真机）**

```bash
# 1. 用 Xcode 安装 App 到设备（稳定）
open ios/Runner.xcworkspace  # Cmd+R 运行

# 2. 安装成功后，用 flutter attach 接管热重载
flutter attach -d <device-id>
```

---

### 本次调试总结：外网隧道方案对比

需要 HTTPS 域名让真机访问本地后端时：

| 方案                        | 优点               | 缺点                                  |
| --------------------------- | ------------------ | ------------------------------------- |
| `localhost.run`（SSH 隧道） | 无需注册           | URL 每次重连变化，会话短暂            |
| `ngrok`（需注册）           | 免费固定域名，稳定 | 需注册账号并配置 authtoken            |
| VS Code 端口转发            | 零配置，直接用     | 需依赖 VS Code + GitHub 账号          |
| 局域网 IP（同 WiFi）        | 永不过期，最快     | 需开 `NSAllowsArbitraryLoads`，纯本地 |

**ngrok 快速配置：**

```bash
ngrok config add-authtoken <your-token>
ngrok http 3000  # 生成 https://xxx.ngrok-free.app
```
