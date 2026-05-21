import Flutter
import UIKit
import ATAuthSDK

// UIViewController(PNSAnimation) 分类由 ATAuthSDK 静态库提供（需 -ObjC 链接标志），
// 无需在此手动声明 presentController/dismissController。

@main
@objc class AppDelegate: FlutterAppDelegate {

  private let channelName = "com.dazi.phone_auth"
  // 强引用 model，防止 ARC 在 SDK 异步回调前回收它
  private var loginModel: TXCustomModel?

  private var aliAppKey: String {
    Bundle.main.object(forInfoDictionaryKey: "AliAppKey") as? String ?? ""
  }

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GeneratedPluginRegistrant.register(with: self)
    let result = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    // 初始化阿里云号码认证 SDK
    TXCommonHandler.sharedInstance().setAuthSDKInfo(aliAppKey) { _ in }

    // 使用 FlutterPluginRegistry API 注册 channel（兼容 UISceneDelegate）
    let registrar = self.registrar(forPlugin: channelName)!
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: registrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, flutterResult in
      guard let self else { return }
      switch call.method {
      case "prefetch":
        self.handlePrefetch(result: flutterResult)
      case "getLoginToken":
        self.handleGetLoginToken(call: call, result: flutterResult)
      default:
        flutterResult(FlutterMethodNotImplemented)
      }
    }

    return result
  }

  // MARK: - 获取当前最顶层 ViewController

  private func topViewController() -> UIViewController? {
    let windowScene = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .first { $0.activationState == .foregroundActive }
    let rootVC = windowScene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
    return rootVC
  }

  // MARK: - 预取号

  private func handlePrefetch(result: @escaping FlutterResult) {
    TXCommonHandler.sharedInstance().checkEnvAvailable(with: .loginToken) { response in
      let code = response?["resultCode"] as? String
      if code == "600000" {
        result(nil)
      } else {
        let msg = response?["msg"] as? String ?? "预取号失败"
        result(FlutterError(code: "PREFETCH_FAILED", message: msg, details: nil))
      }
    }
  }

  // MARK: - UI 辅助

  /// 生成指定颜色、圆角的纯色 UIImage（用于 loginBtnBgImgs）
  private func solidRoundedImage(color: UIColor, size: CGSize = CGSize(width: 200, height: 50), cornerRadius: CGFloat = 25) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { ctx in
      color.setFill()
      UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius).fill()
    }
  }

  // MARK: - 获取登录 Token

  private func handleGetLoginToken(call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let rootVC = topViewController() else {
      result(FlutterError(code: "NO_VC", message: "无法获取 ViewController", details: nil))
      return
    }

    // 标记是否已回调（getLoginToken 的 completion 可能多次调用）
    var hasCalledBack = false

    // App 主色：活力绿 #52C41A
    let primaryGreen   = UIColor(red: 0x52/255.0, green: 0xC4/255.0, blue: 0x1A/255.0, alpha: 1.0)
    let pressedGreen   = UIColor(red: 0x38/255.0, green: 0x9E/255.0, blue: 0x0D/255.0, alpha: 1.0)
    let disabledGreen  = UIColor(red: 0x52/255.0, green: 0xC4/255.0, blue: 0x1A/255.0, alpha: 0.4)

    let model = TXCustomModel()
    model.checkBoxIsChecked = true   // 预勾选协议，使"一键登录"按钮可点击

    // 登录按钮：绿色圆角背景
    model.loginBtnBgImgs = [
      solidRoundedImage(color: primaryGreen),   // 正常态
      solidRoundedImage(color: disabledGreen),  // 禁用态
      solidRoundedImage(color: pressedGreen),   // 高亮/按压态
    ]
    model.loginBtnText = NSAttributedString(
      string: "本机号码一键登录",
      attributes: [
        .foregroundColor: UIColor.white,
        .font: UIFont.systemFont(ofSize: 17, weight: .medium),
      ]
    )

    loginModel = model  // 强引用，防止 ARC 提前释放

    TXCommonHandler.sharedInstance().getLoginToken(
      withTimeout: 5.0,
      controller: rootVC,
      model: model
    ) { response in
      let code = response["resultCode"] as? String ?? ""

      // 中间事件回调（页面展示、按钮点击等）：全部忽略，等待最终结果
      let intermediaryCodes: Set<String> = [
        "600001",  // 授权页唤起成功
        "700002",  // 点击登录按钮
        "700003",  // 点击 CheckBox
        "700004",  // 点击协议富文本
        "700006",  // 拉起二次弹窗
        "700007",  // 二次弹窗关闭
        "700008",  // 二次弹窗确认继续
        "700009",  // 二次弹窗协议点击
        "700010",  // 中断页消失
        "700020",  // 授权页已销毁
      ]
      if intermediaryCodes.contains(code) { return }

      // 避免多次 result 调用导致崩溃
      guard !hasCalledBack else { return }
      hasCalledBack = true

      if code == "600000" {
        let token = response["token"] as? String ?? ""
        // 主动关闭 SDK 授权页，否则会遮挡 Flutter 页面
        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true) { [weak self] in
          self?.loginModel = nil
          result(token)
        }
      } else {
        // 关闭授权页后再回调错误
        TXCommonHandler.sharedInstance().cancelLoginVC(animated: true) { [weak self] in
          self?.loginModel = nil
          let isCancel = code == "700000" || code == "700001"
          let msg = isCancel ? "用户取消" : (response["msg"] as? String ?? "获取 token 失败")
          result(FlutterError(code: isCancel ? "CANCELLED" : "TOKEN_FAILED", message: msg, details: code))
        }
      }
    }
  }
}

