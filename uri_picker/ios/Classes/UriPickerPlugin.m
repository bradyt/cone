#import "UriPickerPlugin.h"
#if __has_include(<uri_picker/uri_picker-Swift.h>)
#import <uri_picker/uri_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "uri_picker-Swift.h"
#endif

@implementation UriPickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUriPickerPlugin registerWithRegistrar:registrar];
}
@end
