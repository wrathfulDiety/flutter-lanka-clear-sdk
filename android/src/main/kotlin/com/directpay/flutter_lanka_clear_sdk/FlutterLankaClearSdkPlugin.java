package com.directpay.flutter_lanka_clear_sdk;

import android.app.Activity;

import com.lankaclear.justpay.LCTrustedSDK;
import com.lankaclear.justpay.callbacks.CreateIdentityCallback;
import com.lankaclear.justpay.callbacks.SignMessageCallback;

import java.util.HashMap;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class FlutterLankaClearSdkPlugin implements MethodChannel.MethodCallHandler {
    Activity activity;
    LCTrustedSDK lcTrustedSDK;

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_lanka_clear_sdk");
        channel.setMethodCallHandler(new FlutterLankaClearSdkPlugin(registrar.activity()));
    }

    FlutterLankaClearSdkPlugin(Activity activity) {
        this.activity = activity;
        lcTrustedSDK = new LCTrustedSDK(activity);
    }

    @Override
    public void onMethodCall(final MethodCall methodCall, final MethodChannel.Result result) {
        if (methodCall.method.equals("clearCertificate")) {
            lcTrustedSDK.clearIdentity();
        } else if (methodCall.method.equals("signMessage")) {
            String message = methodCall.argument("message");

            lcTrustedSDK.signMessage(message, new SignMessageCallback() {
                @Override
                public void onSuccess(final String message, String status) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(message);
                        }
                    });
                }

                @Override
                public void onFailed(final int i, final String s) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.error(String.valueOf(i), s, null);
                        }
                    });
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
                    final HashMap<String, Object> resultMap = new HashMap<>();
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.success(true);
                        }
                    });
                }

                @Override
                public void onFailed(final int i, final String s) {
                    activity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            result.error(String.valueOf(i), s, null);
                        }
                    });
                }
            });
        } else {
            result.notImplemented();
        }
    }
}
