import Flutter
import UIKit
import LCTrustedSDK

public class SwiftFlutterLankaClearSdkPlugin: NSObject, FlutterPlugin, LCIdentityDelegate{
    var signResult:FlutterResult? = nil, identityResult:FlutterResult? = nil
    let lcSDK:LCTrustedSDK = LCTrustedSDK()
    
    public func onIdentitySuccess() {
        if(self.identityResult != nil){
            print("IDENITY_SUCCESS")
            let result:NSDictionary = [
                "status": true,
                "code" : 0,
                "message" : "success"
            ]
            
            identityResult!(result)
        }
    }
    
    public func onIdentityFailed(_ errorCode: Int32, message errorMessage: String!) {
        if(self.identityResult != nil){
            print("IDENITY_FAILED", errorCode, errorMessage)
            let result:NSDictionary = [
                "status": false,
                "code" : errorCode,
                "message" : errorMessage
            ]
            
            identityResult!(result)
        }
    }
    
    public func onMessageSignSuccess(_ signedMessage: String!, status: String!) {
        if(self.signResult != nil){
            let result:NSDictionary = [
                "status" : true,
                "statusCode" : status,
                "message" : signedMessage
            ]
            
            self.signResult!(result)
        }
    }
    
    public func onMessageSignFailed(_ errorCode: Int32, message errorMessage: String!) {
        print("MESSAGE_SIGN_FAILED", errorCode, errorMessage)
        if(self.signResult != nil){
            let result:NSDictionary = [
                "status" : false,
                "statusCode" : String(errorCode),
                "message" : errorMessage
            ]
            
            self.signResult!(result)
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
