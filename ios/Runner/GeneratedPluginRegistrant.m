//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<e2e/E2EPlugin.h>)
#import <e2e/E2EPlugin.h>
#else
@import e2e;
#endif

#if __has_include(<flutter_blue/FlutterBluePlugin.h>)
#import <flutter_blue/FlutterBluePlugin.h>
#else
@import flutter_blue;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [E2EPlugin registerWithRegistrar:[registry registrarForPlugin:@"E2EPlugin"]];
  [FlutterBluePlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterBluePlugin"]];
}

@end
