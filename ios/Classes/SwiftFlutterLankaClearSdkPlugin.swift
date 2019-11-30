import Flutter
import UIKit
import LCTrustedSDK

public class SwiftFlutterLankaClearSdkPlugin: NSObject, FlutterPlugin, LCIdentityDelegate{
    var signResult:FlutterResult? = nil, identityResult:FlutterResult? = nil
    let lcSDK:LCTrustedSDK = LCTrustedSDK()
    
    public func onIdentitySuccess() {
        if(self.identityResult != nil){
            print("IDENITY_SUCCESS")
            self.processResult(result: self.identityResult!, data: true)
        }
    }
    
    public func onIdentityFailed(_ errorCode: Int32, message errorMessage: String!) {
        if(self.identityResult != nil){
            print("IDENITY_FAILED", errorCode, errorMessage)
            self.processResult(result: self.identityResult!, data: FlutterError(code: String(errorCode), message: errorMessage, details: nil))
        }
    }
    
    public func onMessageSignSuccess(_ signedMessage: String!, status: String!) {
        if(self.signResult != nil){
            self.processResult(result: self.signResult!, data: signedMessage)
        }
    }
    
    public func onMessageSignFailed(_ errorCode: Int32, message errorMessage: String!) {
        print("MESSAGE_SIGN_FAILED", errorCode, errorMessage)
        if(self.signResult != nil){
            self.processResult(result: self.signResult!, data: FlutterError(code: String(errorCode), message: errorMessage, details: nil))
        }
    }
    
    func processResult(result:@escaping FlutterResult, data: Any){
        DispatchQueue.main.async {
            result(data)
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_lanka_clear_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterLankaClearSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        lcSDK.delegate = self
        if(call.method == "clearCertificate"){
            lcSDK.clearIdentity()
        }else if(call.method == "signMessage"){
            let arguments = call.arguments as! NSDictionary
            let message:String = arguments.value(forKey: "message") as! String
            print("SIGNING_MESSAGE", message)
            self.signResult = result
            lcSDK.signMessage(message)
        }else if(call.method == "isIdentityExist"){
            result(lcSDK.isIdentityExist())
        }else if(call.method == "getVersion"){
            result(lcSDK.getVersion())
        }else if(call.method == "getDeviceID"){
            result(UIDevice.current.identifierForVendor!.uuidString)
        }else if(call.method == "createIdentity"){
            let arguments = call.arguments as! NSDictionary
            let challenge:String = arguments.value(forKey: "challenge") as! String
            self.identityResult = result
            lcSDK.createIdentity(challenge)
        }
    }
}
