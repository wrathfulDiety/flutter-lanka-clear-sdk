package com.directpay.flutter_lanka_clear_sdk;

import android.content.Context;

import com.lankaclear.justpay.LCTrustedSDK;
import com.lankaclear.justpay.callbacks.CreateIdentityCallback;
import com.lankaclear.justpay.callbacks.SignMessageCallback;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterLankaClearSdkPlugin implements MethodChannel.MethodCallHandler {
    Context context;
    LCTrustedSDK lcTrustedSDK;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_lanka_clear_sdk");
        channel.setMethodCallHandler(new FlutterLankaClearSdkPlugin(registrar.activity()));
    }

    FlutterLankaClearSdkPlugin(Context context) {
        this.context = context;
        lcTrustedSDK = new LCTrustedSDK(context);
    }

    @Override
    public void onMethodCall(final MethodCall methodCall, final MethodChannel.Result result) {
        if (methodCall.method.equals("clearCertificate")) {
            lcTrustedSDK.clearIdentity();
        } else if (methodCall.method.equals("signMessage")) {
            String message = methodCall.argument("message");

            lcTrustedSDK.signMessage(message, new SignMessageCallback() {
                @Override
                public void onSuccess(String message, String status) {
                    result.success(message);
                }

                @Override
                public void onFailed(int i, String s) {
                    result.error("FAILED TO CREATE IDENTITY", s, i);
                }
            });
        } else if (methodCall.method.equals("isIdentityExist")) {
            result.success(lcTrustedSDK.isIdentityExist());
        } else if (methodCall.method.equals("init")) {
            result.success(lcTrustedSDK.init());
        } else if (methodCall.method.equals("getVersion")) {
            result.success(lcTrustedSDK.getVersion());
        } else if (methodCall.method.equals("getDeviceID")) {
            result.success(lcTrustedSDK.getDeviceID());
        } else if (methodCall.method.equals("createIdentity")) {
            String challenge = methodCall.argument("challenge");

            lcTrustedSDK.createIdentity(challenge, new CreateIdentityCallback() {
                @Override
                public void onSuccess() {
                    result.success(true);
                }

                @Override
                public void onFailed(int i, String s) {
                    result.error("FAILED TO CREATE IDENTITY", s, i);
                }
            });
        } else {
            result.notImplemented();
        }
    }
}
