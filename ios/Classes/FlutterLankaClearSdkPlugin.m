#import "FlutterLankaClearSdkPlugin.h"
#import <flutter_lanka_clear_sdk/flutter_lanka_clear_sdk-Swift.h>

@implementation FlutterLankaClearSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLankaClearSdkPlugin registerWithRegistrar:registrar];
}
@end
