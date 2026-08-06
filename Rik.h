#import <AppKit/AppKit.h>
#import <Foundation/NSUserDefaults.h>
#import <GNUstepGUI/GSTheme.h>

// To enable debugging messages in the _overrideClassMethod_foo mechanism
#if 0
#define RIKLOG(args...) NSLog(args)
#else
#define RIKLOG(args...) 
#endif

@interface Rik: GSTheme
+ (NSColor *) controlStrokeColor;
- (void) drawPathButton: (NSBezierPath*) path
                     in: (NSCell*)cell
			            state: (GSThemeControlState) state;
@end


#import "Rik+Drawings.h"
