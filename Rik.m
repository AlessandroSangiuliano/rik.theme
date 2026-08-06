#import "Rik.h"

#import <AppKit/AppKit.h>
#import <GNUstepGUI/GSWindowDecorationView.h>

// add this declaration to quiet the compiler
@interface Rik(RikButton)
- (NSColor*) buttonColorInCell:(NSCell*) cell forState: (GSThemeControlState) state;
@end
  
@implementation Rik

+ (NSColor *) controlStrokeColor
{

  return RETAIN([NSColor colorWithCalibratedRed: 0.4
                                          green: 0.4
                                           blue: 0.4
                                          alpha: 1]);
}
- (void) drawPathButton: (NSBezierPath*) path
                     in: (NSCell*)cell
			            state: (GSThemeControlState) state
{
  NSColor	*backgroundColor = [self buttonColorInCell: cell forState: state];
  NSColor* strokeColorButton = [Rik controlStrokeColor];
  NSGradient* buttonBackgroundGradient = [self _bezelGradientWithColor: backgroundColor];
  [buttonBackgroundGradient drawInBezierPath: path angle: -90];
  [strokeColorButton setStroke];
  [path setLineWidth: 1];
  [path stroke];
}
@end

