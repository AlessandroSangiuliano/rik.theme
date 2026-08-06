#import "Rik.h"
#import "Rik+Drawings.h"

@interface Rik(RikBrowser)

@end

@implementation Rik(RikBrowser)
- (NSColor *) browserHeaderTextColor
{
  return [NSColor blackColor];
}

- (void) drawBrowserHeaderCell: (NSTableHeaderCell*)cell
	 	     withFrame: (NSRect)rect
			inView: (NSView*)view;
{
}
- (NSRect) browserHeaderDrawingRectForCell: (NSTableHeaderCell*)cell
				 withFrame: (NSRect)rect
{
  return NSInsetRect(rect, 4, 4);
}
- (void) drawBrowserRect: (NSRect)rect
		  inView: (NSView *)view
	withScrollerRect: (NSRect)scrollerRect
	      columnSize: (NSSize)columnSize
{
  NSBrowser *browser = (NSBrowser *)view;
  // TS: unused
  // NSRect bounds = [view bounds];

  // Load the first column if not already done
  if (![browser isLoaded])
    {
      [browser loadColumnZero];
    }
}

- (CGFloat) browserColumnSeparation
{
  return 1;
}

- (CGFloat) browserVerticalPadding
{
  return 0;
}

- (BOOL) browserUseBezels
{
  return NO;
}
@end
