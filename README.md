# 成分雷达 (dazi_app)

拍一下配料表，看懂你吃的东西。

## 项目简介

成分雷达是一款 Flutter 移动应用，帮助用户通过拍照识别食品配料表，了解食物成分对健康的影响。

## 环境要求

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **>= 3.19.0**（含 Dart SDK >= 3.3.0）
- 后端服务（可本地启动，默认地址：`http://localhost:3000/api/v1`）

## 快速开始

### 1. 克隆项目

```bash
git clone https://github.com/sunyuanlee/food-health.git
cd food-health
```

### 2. 初始化环境

运行以下命令，自动创建 `env.development` 并安装依赖：

```bash
make setup
```

这会将 `env.development.example` 复制为 `env.development`，并执行 `flutter pub get`。

> **注意**：如果你的后端不在本机，请编辑 `env.development`，将 `BASE_URL` 改为实际地址（例如 ngrok 地址）：
> ```
> BASE_URL=https://your-ngrok-domain.ngrok-free.dev/api/v1
> ```

### 3. 运行项目

```bash
make dev
```

或直接使用 Flutter：

```bash
flutter run --dart-define-from-file=env.development
```

如需在特定设备上运行（如 iOS 模拟器或 Android 模拟器）：

```bash
flutter devices          # 查看可用设备
flutter run -d <device_id> --dart-define-from-file=env.development
```

## 常用命令

| 命令 | 说明 |
|------|------|
| `make setup` | 初始化环境（创建 env 文件 + 安装依赖） |
| `make dev` | Debug 模式运行 |
| `make dev-release` | Release 模式运行 |
| `make build-ios` | 打包 iOS |
| `flutter pub get` | 安装/更新依赖 |
| `flutter test` | 运行测试 |

## 环境变量说明

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `BASE_URL` | 后端 API 地址 | `http://localhost:3000/api/v1` |

参考 `env.development.example` 创建 `env.development`（已在 `.gitignore` 中，不会提交到仓库）。

## 项目结构

```
lib/
├── main.dart           # 入口
├── app.dart            # App 根组件
├── core/               # 核心模块（网络、路由、主题、存储等）
├── features/           # 功能模块（按页面/功能划分）
├── models/             # 数据模型
└── shared/             # 公共组件
```

## 技术栈

- **状态管理**：Riverpod
- **路由**：GoRouter
- **网络请求**：Dio
- **本地存储**：SharedPreferences + FlutterSecureStorage
- **图片选择**：ImagePicker + Camera
- **图表**：FL Chart
