import Flutter
import UIKit

public class SwiftFlutterLankaClearSdkPlugin: NSObject, FlutterPlugin{
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_lanka_clear_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterLankaClearSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if(call.method == "clearCertificate"){
            result(true)
        }else if(call.method == "signMessage"){
            result("Signed")
        }else if(call.method == "isIdentityExist"){
            result(true)
        }else if(call.method == "getVersion"){
            result("1.0.0")
        }else if(call.method == "getDeviceID"){
            result("TEST_ID_0000000000000001")
        }else if(call.method == "createIdentity"){
            result(true)
        }
    }
}
