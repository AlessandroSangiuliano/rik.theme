#import "Rik.h"
#import "Rik+Button.h"

@implementation Rik(RikSegmented)

- (void) drawSegmentedControlSegment: (NSCell *)cell
                           withFrame: (NSRect)cellFrame
                              inView: (NSView *)controlView
                               style: (NSSegmentStyle)style
                               state: (GSThemeControlState)state
                         roundedLeft: (BOOL)roundedLeft
                        roundedRight: (BOOL)roundedRight
{
    NSColor * c = [[NSColor controlBackgroundColor] shadowWithLevel: 0.1];
    NSGradient* normalButtongradient = [self _bezelGradientWithColor: c];

    // TS: unused
    // NSColor* buttonStroke = [Rik controlStrokeColor];
    NSColor* buttonFill = [NSColor colorWithCalibratedRed: 0.58 green: 0.58 blue: 0.58 alpha: 1];
    NSColor* buttonFillLight = [NSColor colorWithCalibratedRed: 0.663 green: 0.663 blue: 0.663 alpha: 1];

    NSGradient* buttonGradient = [[NSGradient alloc] initWithColorsAndLocations:
      buttonFill, 0.0,
      buttonFill, 0.64,
      buttonFillLight, 1.0, nil];

    CGFloat button2CornerRadius = 4;
    NSRect button2Rect = cellFrame;
    NSRect button2InnerRect = NSInsetRect(button2Rect, button2CornerRadius, button2CornerRadius);
    NSBezierPath* buttonPath;
    if(roundedRight)
      {
        buttonPath = [NSBezierPath bezierPath];
        [buttonPath moveToPoint: NSMakePoint(NSMinX(button2Rect), NSMinY(button2Rect))];
        [buttonPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(button2InnerRect), NSMinY(button2InnerRect)) radius: button2CornerRadius startAngle: 270 endAngle: 360];
        [buttonPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMaxX(button2InnerRect), NSMaxY(button2InnerRect)) radius: button2CornerRadius startAngle: 0 endAngle: 90];
        [buttonPath lineToPoint: NSMakePoint(NSMinX(button2Rect), NSMaxY(button2Rect))];
        [buttonPath closePath];
      }
    else if(roundedLeft)
      {
        buttonPath = [NSBezierPath bezierPath];
        [buttonPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(button2InnerRect), NSMinY(button2InnerRect)) radius: button2CornerRadius startAngle: 180 endAngle: 270];
        [buttonPath lineToPoint: NSMakePoint(NSMaxX(button2Rect), NSMinY(button2Rect))];
        [buttonPath lineToPoint: NSMakePoint(NSMaxX(button2Rect), NSMaxY(button2Rect))];
        [buttonPath appendBezierPathWithArcWithCenter: NSMakePoint(NSMinX(button2InnerRect), NSMaxY(button2InnerRect)) radius: button2CornerRadius startAngle: 90 endAngle: 180];
        [buttonPath closePath];
      }
    else
      {
        buttonPath = [NSBezierPath bezierPathWithRect: button2Rect];
      }
    if(state == GSThemeSelectedState)
      [buttonGradient drawInBezierPath: buttonPath angle: 90];
    else
      [normalButtongradient drawInBezierPath: buttonPath angle: 90];

}
@end
