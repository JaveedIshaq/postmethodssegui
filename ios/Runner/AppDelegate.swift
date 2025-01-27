import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let batteryChannel = FlutterMethodChannel(
            name: "com.example.battery/status",
            binaryMessenger: controller.binaryMessenger)
        
        batteryChannel.setMethodCallHandler({
            [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard call.method == "getBatteryStatus" else {
                result(FlutterMethodNotImplemented)
                return
            }
            
            UIDevice.current.isBatteryMonitoringEnabled = true
            
            let batteryLevel = Int(UIDevice.current.batteryLevel * 100)
            let isCharging = UIDevice.current.batteryState == .charging || UIDevice.current.batteryState == .full
            
            let statusString: String
            switch UIDevice.current.batteryState {
            case .charging:
                statusString = "charging"
            case .full:
                statusString = "full"
            case .unplugged:
                statusString = "discharging"
            default:
                statusString = "unknown"
            }
            
            let batteryStatus: [String: Any] = [
                "level": batteryLevel,
                "isCharging": isCharging,
                "status": statusString
            ]
            
            result(batteryStatus)
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}