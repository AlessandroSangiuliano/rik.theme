#import "Rik.h"
#import <AppKit/NSPopUpButton.h>

@interface NSPopUpButton (RikTheme)
- (void) RIKmouseDown: (NSEvent*)theEvent;
@end

@implementation Rik (NSPopUpButton)
- (void) _overrideNSPopUpButtonMethod_mouseDown: (NSEvent*)theEvent {
  RIKLOG(@"_overrideNSPopUpButtonMethod_mouseDown:");
  NSPopUpButton *xself = (NSPopUpButton*)self;
  [xself RIKmouseDown:theEvent];
}
@end

@implementation NSPopUpButton (RikTheme)

- (void) RIKmouseDown: (NSEvent*)theEvent
{ 
  [_cell trackMouse: theEvent 
	     inRect: [self bounds] 
	     ofView: self 
       untilMouseUp: NO];
}

@end

