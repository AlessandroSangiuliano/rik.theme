#import "Rik.h"
#import "Rik+Drawings.h"

@interface Rik(RikTable)

@end

@implementation Rik(RikTable)


- (NSRect) tableHeaderCellDrawingRectForBounds: (NSRect)theRect
{
  NSSize borderSize;

  // This adjustment must match the drawn border
  borderSize = NSMakeSize(0, 0);

  return NSInsetRect(theRect, borderSize.width, borderSize.height);
}
- (NSColor *) tableHeaderTextColorForState: (GSThemeControlState)state
{
  NSColor *color;

  if (state == GSThemeHighlightedState)
    color = [NSColor controlTextColor];
  else
    color = [NSColor controlTextColor];
  return color;
}

- (void) drawTableCornerView: (NSView*)cornerView
                   withClip: (NSRect)aRect
{
  NSRect divide;
  NSRect rect;

  if ([cornerView isFlipped])
    {
      NSDivideRect(aRect, &divide, &rect, 1.0, NSMaxYEdge);
    }
  else
    {
      NSDivideRect(aRect, &divide, &rect, 1.0, NSMinYEdge);
    }

      NSColor * basecolor = [[NSColor controlBackgroundColor] shadowWithLevel: 0.1];
      NSGradient* buttonBackgroundGradient = [self _bezelGradientWithColor: basecolor];
      [buttonBackgroundGradient drawInRect: rect angle: -90];
      NSBezierPath* linesPath = [NSBezierPath bezierPath];
      [linesPath setLineWidth: 1];
      [linesPath moveToPoint: NSMakePoint(rect.origin.x, NSMinY(rect))];
      [linesPath lineToPoint: NSMakePoint(rect.origin.x + rect.size.width, NSMinY(rect))];

        [linesPath moveToPoint: NSMakePoint(rect.origin.x, NSMaxY(rect))];
        [linesPath lineToPoint: NSMakePoint(rect.origin.x + rect.size.width, NSMaxY(rect))];
        NSColor * strokeColor = [NSColor colorWithCalibratedRed: 0.70
                                                          green: 0.70
                                                          blue: 0.70
                                                          alpha: 1.0];
              [strokeColor setStroke];
              [linesPath stroke];
}

- (void) drawTableHeaderCell: (NSTableHeaderCell *)cell
                   withFrame: (NSRect)cellFrame
                      inView: (NSView *)controlView
                       state: (GSThemeControlState)state
{
      // TS: unused
      // NSRect rect;

      // Leave a 1pt thick horizontal line underneath the header
      if (![controlView isFlipped])
        {
          cellFrame.origin.y++;
        }
      //cellFrame.size.height--;
      NSColor * basecolor;
      if (state == GSThemeHighlightedState)
        {
          basecolor = [NSColor selectedControlColor];
        }
      else
        {
          basecolor = [[NSColor controlBackgroundColor] shadowWithLevel: 0.1];
        }
        NSGradient* buttonBackgroundGradient = [self _bezelGradientWithColor: basecolor];
        [buttonBackgroundGradient drawInRect: cellFrame angle: -90];

        NSBezierPath* linesPath = [NSBezierPath bezierPath];
        [linesPath setLineWidth: 1];
        [linesPath moveToPoint: NSMakePoint(cellFrame.origin.x-0.5, NSMinY(cellFrame) + 5)];
        [linesPath lineToPoint: NSMakePoint(cellFrame.origin.x-0.5, NSMaxY(cellFrame) - 5)];

        [linesPath moveToPoint: NSMakePoint(cellFrame.origin.x, NSMinY(cellFrame))];
        [linesPath lineToPoint: NSMakePoint(cellFrame.origin.x + cellFrame.size.width, NSMinY(cellFrame))];

        [linesPath moveToPoint: NSMakePoint(cellFrame.origin.x, NSMaxY(cellFrame))];
        [linesPath lineToPoint: NSMakePoint(cellFrame.origin.x + cellFrame.size.width, NSMaxY(cellFrame))];

        NSColor * strokeColor = [NSColor colorWithCalibratedRed: 0.70
                                                          green: 0.70
                                                          blue: 0.70
                                                          alpha: 1.0];
              [strokeColor setStroke];
              [linesPath stroke];
}

@end
