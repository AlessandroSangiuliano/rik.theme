#import "Rik.h"
#import "Rik+Stepper.h"

@implementation Rik(RikFocusFrame)

- (void) drawFocusFrame: (NSRect) frame view: (NSView*) view
{
  //NSLog(@"%@", [view className]);
  NSBezierPath * path;
  if([view class] == [NSButton class])
    {
        NSRect r = [view bounds];
        NSImage * img = [(NSButton*) view image];
        if(img != nil && ![(NSButton*)view isBordered])
          {
            NSSize s = [img size];
            NSCellImagePosition cip = [(NSButton*) view imagePosition];
            NSRect imageRect;
            switch(cip)
            {
              case NSImageOnly:
                imageRect = r;
                break;

              case NSImageLeft:
                imageRect.origin = r.origin;
                imageRect.size.width = s.width;
                imageRect.size.height = r.size.height;
                break;

              case NSImageRight:
                imageRect.origin.x = NSMaxX(r) - s.width;
                imageRect.origin.y = r.origin.y;
                imageRect.size.width = s.width;
                imageRect.size.height = r.size.height;
                break;
            }
            path = [NSBezierPath bezierPathWithRoundedRect: NSInsetRect(imageRect,2,1)
                                                  xRadius: 3
                                                  yRadius: 3];
          }
        else
          {

        int bezel_style = [(NSButton*)view bezelStyle];
        path = [self buttonBezierPathWithRect: NSInsetRect([view bounds], 1, 1)
                                     andStyle: bezel_style];
          }
    }
  else if([view class] == [NSStepper class])
    {
      path = [self stepperBezierPathWithFrame: frame];
    }
  else if([view class] == [NSPopUpButton class])
    {
      frame.size.height += 1;
      frame.size.width += 1;
      path = [NSBezierPath bezierPathWithRoundedRect: frame
                                                  xRadius: 3
                                                  yRadius: 3];
    }
  else if([view class] == [NSMatrix class])
    {
      // TS: unused
      // NSSize size = [(NSMatrix*) view cellSize];
      NSCell* selectedCell = [(NSMatrix*) view selectedCell];
      NSUInteger row = [(NSMatrix*)view selectedRow];
      NSUInteger col = [(NSMatrix*)view selectedColumn];

      NSRect r = [(NSMatrix*) view cellFrameAtRow:row column: col];

      if([selectedCell class] == [NSButtonCell class])
      {
        NSImage * img = [selectedCell image];
        if(img != nil && ![selectedCell isBordered])
        {
          NSSize s = [img size];
          s.width -= 2;
          s.height -= 2;
          path = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(r.origin.x+1, r.origin.y+2, s.width, s.height)
                                                 xRadius: s.width/2.0
                                                 yRadius: s.height/2.0];
        }else{
          path = [NSBezierPath bezierPathWithRoundedRect: NSInsetRect(r, 1, 1)
                                                 xRadius: 3
                                                 yRadius: 3];
        }
      }else{
        return;
      }
    }
  else
    {
      path = [NSBezierPath bezierPathWithRect: frame];
    }
  NSColor * c = [NSColor selectedControlColor];
  [c setStroke];
  [path setLineWidth: 2];
  [path stroke];
}

- (NSSize) sizeForBorderType: (NSBorderType)aType
{
      switch (aType)
        {
          case NSLineBorder:
            return NSMakeSize(4, 4);
          case NSGrooveBorder:
          case NSBezelBorder:
            return NSMakeSize(1, 1);
          case NSNoBorder:
          default:
            return NSZeroSize;
        }
}

@end
