package com.paymedia.flutter_lanka_clear_sdk;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.lankaclear.justpay.LCTrustedSDK;
import com.lankaclear.justpay.callbacks.CreateIdentityCallback;
import com.lankaclear.justpay.callbacks.SignMessageCallback;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterLankaClearSdkPlugin */
public class FlutterLankaClearSdkPlugin implements FlutterPlugin, MethodCallHandler {
  Activity activity;
Context context;
LCTrustedSDK lcTrustedSDK;
 static String TAG="SDKPlugin";


  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "flutter_lanka_clear_sdk");
    channel.setMethodCallHandler(this);
    this.context = flutterPluginBinding.getApplicationContext();
      lcTrustedSDK = new LCTrustedSDK(this.context);
    Log.i(TAG, "onAttachedToEngine: ");

  }
  public FlutterLankaClearSdkPlugin() {
    Log.i(TAG, "FlutterLankaClearSdkPlugin: called from GeneratedPluginReg");
  }
 public FlutterLankaClearSdkPlugin(Context context) {
    this.activity = activity;
    this.context=context;
   lcTrustedSDK = new LCTrustedSDK(context);
   Log.i(TAG, "FlutterLankaClearSdkPlugin: called with args");
  }

  // This static function is optional and equivalent to onAttachedToEngine. It supports the old
  // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
  // plugin registration via this function while apps migrate to use the new Android APIs
  // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
  //
  // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
  // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
  // depending on the user's project. onAttachedToEngine or registerWith must both be defined
  // in the same class.
  public static void registerWith(Registrar registrar) {
      Log.i(TAG, "onRegisterWithCall: ");
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_lanka_clear_sdk");
    final Activity activity = registrar.activity();
    channel.setMethodCallHandler(new FlutterLankaClearSdkPlugin(registrar.activity()));

  }

  @Override
  public void onMethodCall(@NonNull MethodCall methodCall, @NonNull final Result result) {
    Log.i(TAG, "onMethodCall: ");
    if (methodCall.method.equals("clearCertificate")) {
      lcTrustedSDK.clearIdentity();
    }
    else if (methodCall.method.equals("signMessage")) {
      String message = methodCall.argument("message");

      lcTrustedSDK.signMessage(message, new SignMessageCallback() {
        @Override
        public void onSuccess(final String message, String status) {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              result.success(message);
              // Call the desired channel message here.
            }
          });

        }

        @Override
        public void onFailed(final int i, final String s) {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              result.error(String.valueOf(i), s, null);
              // Call the desired channel message here.
            }
          });
        }
      });
    }
    else if (methodCall.method.equals("isIdentityExist")) {
      result.success(lcTrustedSDK.isIdentityExist());
    } else if (methodCall.method.equals("init")) {
      result.success(lcTrustedSDK.init());
    } else if (methodCall.method.equals("getVersion")) {
      result.success(lcTrustedSDK.getVersion());
    } else if (methodCall.method.equals("getDeviceID")) {
      result.success(lcTrustedSDK.getDeviceID());
    }else if (methodCall.method.equals("createIdentity")) {
      String challenge = methodCall.argument("challenge");

      lcTrustedSDK.createIdentity(challenge, new CreateIdentityCallback() {
        @Override
        public void onSuccess() {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
              result.success(true);
            }
          });
        }

        @Override
        public void onFailed(final int i, final String s) {
          new Handler(Looper.getMainLooper()).post(new Runnable() {
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

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
