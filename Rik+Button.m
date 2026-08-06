#import "Rik.h"
#import "Rik+Button.h"


NSString * const kRikIsDefaultButton = @"kRikIsDefaultButton";
NSString * const kRikPulseProgressKey = @"kRikPulseProgressKey";

@implementation NSButtonCell(RikDefaultButtonAnimation)
- (void)setIsDefaultButton:(NSNumber*) val
{
  objc_setAssociatedObject(self, kRikIsDefaultButton, val, OBJC_ASSOCIATION_COPY);
}

- (NSNumber *) isDefaultButton
{
	return objc_getAssociatedObject(self, kRikIsDefaultButton);
}
- (BOOL)defaultButton
{
	return [[self isDefaultButton] boolValue];
}
- (void)setPulseProgress:(NSNumber *)pulseProgress
{
	objc_setAssociatedObject(self, kRikPulseProgressKey, pulseProgress, OBJC_ASSOCIATION_COPY);
}

- (NSNumber*)pulseProgress
{
	return objc_getAssociatedObject(self, kRikPulseProgressKey);
}
@end

@implementation Rik(RikButton)
- (NSColor*) pulseColorInCell:(NSButtonCell*) bc
{
  NSColor * color;
  CGFloat pulse = [[bc pulseProgress] floatValue];
  color = [NSColor colorWithCalibratedRed: 0.62 green: 0.82 blue: 0.965 alpha: 1];
  color = [NSColor colorWithCalibratedHue: [color hueComponent] saturation: 1.0 - pulse*0.6 brightness: 0.9 + pulse*0.1 alpha: [color alphaComponent]];
  return color;
}
- (NSColor*) buttonColorInCell:(NSCell*) cell forState: (GSThemeControlState) state
{

  NSColor	*color = nil;
  NSString	*name = [super nameForElement: cell];
  color = [self colorNamed: name state: state];
  if (color == nil)
    {
      if (state == GSThemeNormalState)
        {
          color = [[NSColor controlBackgroundColor] shadowWithLevel: 0.1];
        }
      else if (state == GSThemeHighlightedState
	       || state == GSThemeHighlightedFirstResponderState)
        {
          color = [NSColor selectedControlColor];
        }
      else if (state == GSThemeSelectedState
	       || state == GSThemeSelectedFirstResponderState)
        {
          color = [NSColor selectedControlColor];
        }
      else
        {
          color = [[NSColor controlBackgroundColor] shadowWithLevel: 0.1];
        }
    }
    //PULSE ANIMATION COLOR IF IS PRESSED DONT ANIMATE..
    if([cell class] == [NSButtonCell class] && state != GSThemeSelectedState)
    {
      NSButtonCell * bc = (NSButtonCell *)cell;
      if(bc.isDefaultButton)
        {
          color = [self pulseColorInCell: bc];
        }
    }
  return color;
}
- (NSBezierPath *) _roundBezierPath: (NSRect) frame
                withRadius:(CGFloat) radius
{
  frame = NSInsetRect(frame, 0.5, 0.5);
  NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: frame
                                                                       xRadius: radius
                                                                       yRadius: radius];
  return roundedRectanglePath;
}
- (void) _drawRoundBezel: (NSRect)cellFrame
               withColor: (NSColor*)backgroundColor
               andRadius: (CGFloat) radius
{

  NSColor* strokeColorButton = [Rik controlStrokeColor];

  NSGradient* buttonBackgroundGradient = [self _bezelGradientWithColor: backgroundColor];

  NSBezierPath* roundedRectanglePath = [self _roundBezierPath: cellFrame withRadius: radius];
  [buttonBackgroundGradient drawInBezierPath: roundedRectanglePath angle: -90];
  [strokeColorButton setStroke];
  [roundedRectanglePath setLineWidth: 1];
  [roundedRectanglePath stroke];
}

- (void) _drawRoundBezel: (NSRect)cellFrame withColor: (NSColor*)backgroundColor
{
  [self _drawRoundBezel: cellFrame withColor: backgroundColor andRadius: 4];
}
- (void) _drawRoundedBezel: (NSRect)cellFrame withColor: (NSColor*)backgroundColor
{
  float r = MIN(cellFrame.size.width, cellFrame.size.height) / 2.0;
  [self _drawRoundBezel: cellFrame withColor: backgroundColor andRadius: r];
}
- (void) drawCircularBezel: (NSRect)cellFrame withColor: (NSColor*)backgroundColor
{
  CGFloat circle_radius = MIN(NSWidth(cellFrame), NSHeight(cellFrame)) / 2;
  CGFloat x = cellFrame.origin.x + cellFrame.size.width/2.0 - circle_radius;
  cellFrame = NSMakeRect( x,
                          cellFrame.origin.y,
                          circle_radius*2,
                          circle_radius*2);

  [self _drawRoundBezel: cellFrame withColor: backgroundColor
              andRadius: circle_radius];
}


- (NSRect) drawButton: (NSRect)border withClip: (NSRect)clip
{
  NSColor * c = [NSColor controlBackgroundColor];
  [self _drawRoundBezel: border withColor: c];
  return border;
}

- (NSBezierPath*) buttonBezierPathWithRect: (NSRect)frame andStyle: (int) style
{
  NSBezierPath* bezierPath;
  CGFloat r;
  CGFloat x;
  switch (style)
    {
      case NSRoundRectBezelStyle:
        bezierPath = [self _roundBezierPath: frame
                                 withRadius: 4];
        break;
      case NSTexturedRoundedBezelStyle:
      case NSRoundedBezelStyle:
        r = MIN(frame.size.width, frame.size.height) / 2.0;
        bezierPath = [self _roundBezierPath: frame
                                 withRadius: r];
        break;
      case NSTexturedSquareBezelStyle:
        frame = NSInsetRect(frame, 0, 1);
      case NSSmallSquareBezelStyle:
      case NSRegularSquareBezelStyle:
      case NSShadowlessSquareBezelStyle:
      case NSThickSquareBezelStyle:
      case NSThickerSquareBezelStyle:
        bezierPath = [NSBezierPath bezierPathWithRect: frame];
        break;
      case NSCircularBezelStyle:
      case NSHelpButtonBezelStyle:
        r = MIN(NSWidth(frame), NSHeight(frame)) / 2;
        x = frame.origin.x + frame.size.width/2.0 - r;

        frame = NSMakeRect( x,
                            frame.origin.y,
                            r*2,
                            r*2);
        bezierPath = [self _roundBezierPath: frame
                                 withRadius: r];
        break;
      case NSDisclosureBezelStyle:
      case NSRoundedDisclosureBezelStyle:
      case NSRecessedBezelStyle:
        r = MIN(frame.size.width, frame.size.height) / 2.0;
        bezierPath = [self _roundBezierPath: frame
                                  withRadius: r];
        break;
      default:
        bezierPath = [self _roundBezierPath: frame
                                  withRadius: 4];
    }
  return RETAIN(bezierPath);
}
- (void) drawButton: (NSRect) frame
				 in: (NSCell*) cell
			   view: (NSView*) view
			  style: (int) style
			  state: (GSThemeControlState) state
{
  NSColor	*color = [self buttonColorInCell: cell forState: state];

  switch (style)
    {
      case NSRoundRectBezelStyle:
        [self _drawRoundBezel: frame withColor: color];
        break;
      case NSTexturedRoundedBezelStyle:
      case NSRoundedBezelStyle:
        [self _drawRoundedBezel: frame withColor: color];
        break;
      case NSTexturedSquareBezelStyle:
        frame = NSInsetRect(frame, 0, 1);
      case NSSmallSquareBezelStyle:
      case NSRegularSquareBezelStyle:
      case NSShadowlessSquareBezelStyle:
        [color set];
        NSRectFill(frame);
        [[Rik controlStrokeColor] set];
        NSFrameRectWithWidth(frame, 1);
        break;
      case NSThickSquareBezelStyle:
        [color set];
        NSRectFill(frame);
        [[Rik controlStrokeColor] set];
        NSFrameRectWithWidth(frame, 1.5);
        break;
      case NSThickerSquareBezelStyle:
        [color set];
        NSRectFill(frame);
        [[NSColor controlShadowColor] set];
        NSFrameRectWithWidth(frame, 2);
        break;
      case NSCircularBezelStyle:
        [self drawCircularBezel: frame withColor: color];
        break;
      case NSHelpButtonBezelStyle:
        [self drawCircularBezel: frame withColor: color];
        {
          NSDictionary *attributes = [NSDictionary dictionaryWithObject: [NSFont controlContentFontOfSize: 0]
                      forKey: NSFontAttributeName];
          NSAttributedString *questionMark = [[[NSAttributedString alloc]
                  initWithString: _(@"?")
                attributes: attributes] autorelease];

          NSRect textRect;
          textRect.size = [questionMark size];
          textRect.origin.x = NSMidX(frame) - (textRect.size.width / 2);
          textRect.origin.y = NSMidY(frame) - (textRect.size.height / 2);

          [questionMark drawInRect: textRect];
        }
        break;
      case NSDisclosureBezelStyle:
      case NSRoundedDisclosureBezelStyle:
      case NSRecessedBezelStyle:
        [self _drawRoundBezel: frame withColor: color];
        break;
      default:
        [self _drawRoundBezel: frame withColor: color];
    }
}

// currently not used
- (void) _drawButtonMetal:(NSRect) rect
{
  NSColor* strokeColorButton = [Rik controlStrokeColor];
  NSColor* baseColor = [NSColor colorWithCalibratedRed: 0.75
                                                 green: 0.75
                                                  blue: 0.75
                                                 alpha: 1];

  NSColor* baseColorLight = [baseColor highlightWithLevel: 0.6];

  NSGradient* buttonBackgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
      baseColorLight, 1.0,
      baseColor, 0.0, nil];
  CGFloat roundedRectangleStrokeWidth = 1;
  NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: rect xRadius: 3 yRadius: 3];
  [buttonBackgroundGradient drawInBezierPath: roundedRectanglePath angle: -90];
  [strokeColorButton setStroke];
  [roundedRectanglePath setLineWidth: roundedRectangleStrokeWidth];
  [roundedRectanglePath stroke];
}

- (NSRect) drawDarkButton: (NSRect)border withClip: (NSRect)clip
{
  NSColor* strokeColorButton = [Rik controlStrokeColor];
  NSColor* baseColor = [NSColor colorWithCalibratedRed: 0.75
                                                 green: 0.75
                                                  blue: 0.75
                                                 alpha: 1];

  NSColor* baseColorLight = [baseColor highlightWithLevel: 0.6];

  NSGradient* buttonBackgroundGradient = [[NSGradient alloc] initWithColorsAndLocations:
      baseColorLight, 1.0,
      baseColor, 0.0, nil];
  CGFloat roundedRectangleStrokeWidth = 1;
  NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRect: border];
  [buttonBackgroundGradient drawInBezierPath: roundedRectanglePath angle: -90];
  [strokeColorButton setStroke];
  [roundedRectanglePath setLineWidth: roundedRectangleStrokeWidth];
//  [roundedRectanglePath stroke];
  return border;

}
@end
