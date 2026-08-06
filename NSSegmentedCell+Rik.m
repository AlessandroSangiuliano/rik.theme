#include "Rik.h"

// @interface NSSegmentedCell(RikTheme)
@interface Rik(NSSegmentedCell)
@end
@implementation Rik(NSSegmentedCell)


// - (NSColor*) textColor
- (NSColor*) _overrideNSSegmentedCellMethod_textColor
{
  RIKLOG(@"_overrideNSSegmentedCellMethod_textColor");
  //IT DOES NOT WORKS
  NSSegmentedCell *xself = (NSSegmentedCell*) self;
  
  if([xself state] == GSThemeSelectedState)
    return [NSColor whiteColor];
  if ([xself isEnabled] == NO)
    return [NSColor disabledControlTextColor];
  else
    return [NSColor controlTextColor];
}
// - (void) _drawBorderAndBackgroundWithFrame: (NSRect)cellFrame
//                                     inView: (NSView*)controlView
- (void) _overrideNSSegmentedCellMethod__drawBorderAndBackgroundWithFrame: (NSRect)cellFrame
                                    inView: (NSView*)controlView
{
  RIKLOG(@"_overrideNSSegmentedCellMethod__drawBorderAndBackgroundWithFrame");
  NSSegmentedCell *xself = (NSSegmentedCell*) self;
  CGFloat radius = 4;
  cellFrame = NSInsetRect(cellFrame, 0.5, 0.5);
  NSColor* strokeColorButton = [Rik controlStrokeColor];
  NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: cellFrame
                                                                       xRadius: radius
                                                                       yRadius: radius];
  [strokeColorButton setStroke];
  [roundedRectanglePath setLineWidth: 1];
  [roundedRectanglePath stroke];
  NSInteger i;
  NSUInteger count = [xself segmentCount];
  NSRect frame = cellFrame;
  NSRect controlFrame = [controlView frame];

  NSBezierPath* linesPath = [NSBezierPath bezierPath];
  [linesPath setLineWidth: 1];
  CGFloat offsetX = 0;
  for (i = 0; i < count-1;i++)
    {
      frame.size.width = [xself widthForSegment: i];
      if(frame.size.width == 0.0)
        {
          frame.size.width = (controlFrame.size.width - frame.origin.x) / (count);
        }
      offsetX += frame.size.width;
      offsetX = floor(offsetX) + 0.5;
      [linesPath moveToPoint: NSMakePoint(offsetX, NSMinY(frame) + 3)];
      [linesPath lineToPoint: NSMakePoint(offsetX, NSMaxY(frame) - 3)];
    }
  [linesPath stroke];
}
// - (void) drawWithFrame: (NSRect)cellFrame inView: (NSView*)controlView
- (void) _overrideNSSegmentedCellMethod_drawWithFrame: (NSRect)cellFrame inView: (NSView*)controlView
{
  RIKLOG(@"_overrideNSSegmentedCellMethod_drawWithFrame");
  NSCell *xself = (NSCell*) self;
  if (NSIsEmptyRect(cellFrame))
    return;
// i want to draw the border for last
  [xself drawInteriorWithFrame: cellFrame inView: controlView];
  [xself _drawBorderAndBackgroundWithFrame: cellFrame inView: controlView];
  [xself _drawFocusRingWithFrame: cellFrame inView: controlView];
}
@end
