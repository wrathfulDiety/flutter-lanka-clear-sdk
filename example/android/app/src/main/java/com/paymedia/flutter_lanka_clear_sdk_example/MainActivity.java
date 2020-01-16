package com.paymedia.flutter_lanka_clear_sdk_example;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.lankaclear.justpay.LCTrustedSDK;
import com.lankaclear.justpay.callbacks.CreateIdentityCallback;
import com.lankaclear.justpay.callbacks.SignMessageCallback;
import com.paymedia.flutter_lanka_clear_sdk.FlutterLankaClearSdkPlugin;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "flutter_lanka_clear_sdk";
  private static String TAG= "SDKPlugin";
    //LCTrustedSDK lcTrustedSDK=new LCTrustedSDK(MainActivity.this);
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

  }
}
