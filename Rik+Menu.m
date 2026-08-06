#import "Rik.h"
#include <AppKit/AppKit.h>
#import <Foundation/NSUserDefaults.h>
@interface Rik(RikMenu)

@end

@implementation Rik(RikMenu)

- (NSColor *) menuBorderColor
{ 
  NSColor *color = [NSColor colorWithCalibratedRed: 0.212 green: 0.184 blue: 0.176 alpha: 1.0];
  return color;
}
- (NSColor *) menuBackgroundColor
{
  NSUserDefaults *theme_defaults = [NSUserDefaults standardUserDefaults];
  float transparency = [theme_defaults floatForKey:@"RikMenuBarTransparency"];    
  NSColor *color = [NSColor colorWithCalibratedRed: 0.992 green: 0.992 blue: 0.992 alpha: transparency];
  return color;
}
- (NSColor *) menuItemBackgroundColor
{
  NSColor *color = [NSColor colorWithCalibratedRed: 0.992 green: 0.992 blue: 0.992 alpha: 0.95];
  return color;
}
- (CGFloat) menuSubmenuHorizontalOverlap
{
  return 3;
}
-(CGFloat) menuSubmenuVerticalOverlap
{
  return 0;
}
- (CGFloat) menuBarHeight
{
  return 24;
}

- (CGFloat) menuItemHeight
{
  return 26;
}
- (CGFloat) menuSeparatorHeight
{
  return 1;
}

- (BOOL) menuShouldShowIcon
{
  NSUserDefaults *theme_defaults = [NSUserDefaults standardUserDefaults];
  BOOL MenuShouldShowIcon =   [theme_defaults boolForKey:@"MenuShouldShowIcon"]; 
  return MenuShouldShowIcon;
}

- (void) drawMenuRect: (NSRect)rect
         inView: (NSView *)view
   isHorizontal: (BOOL)horizontal
      itemCells: (NSArray *)itemCells
{
  int         i = 0;
  int         howMany = [itemCells count];
  NSMenuView *menuView = (NSMenuView *)view;
  NSRect      bounds = [view bounds];

  // TS: unused
  // NSRect r = NSIntersectionRect(bounds, rect);
  NSRectFillUsingOperation(bounds, NSCompositeClear);
  NSBezierPath * menuPath;
  NSColor *borderColor = [self menuBorderColor];
  [borderColor setStroke];
  if(horizontal == YES)
    {
      // here the semitrasparent status bar...
      menuPath = [NSBezierPath bezierPathWithRect:bounds];
      NSColor* fillColor = [self menuBackgroundColor];
      [fillColor setFill];
      NSRectFill(bounds);
      NSBezierPath* linePath = [NSBezierPath bezierPath];
      [linePath moveToPoint: NSMakePoint(bounds.origin.x, bounds.origin.y)];
      [linePath lineToPoint: NSMakePoint(bounds.origin.x+ bounds.size.width, bounds.origin.y)];
      [linePath setLineWidth: 1];
      [linePath stroke];
    }
  else
    {
      // here the vertical menus
      CGFloat radius = 6;
      menuPath = [NSBezierPath bezierPathWithRoundedRect: bounds
                                                 xRadius: radius
                                                 yRadius: radius];

      [[self menuBackgroundColor] setFill];
      [menuPath fill];

      NSBezierPath * strokemenuPath = [NSBezierPath bezierPathWithRoundedRect: bounds
                                                 xRadius: radius
                                                 yRadius: radius];
      [strokemenuPath stroke];
    }
  // Draw the menu cells.
  for (i = 0; i < howMany; i++)
    {
      NSRect aRect;
      NSMenuItemCell *aCell;
      aRect = [menuView rectOfItemAtIndex: i];
      if (NSIntersectsRect(rect, aRect) == YES)
        {
          aCell = [menuView menuItemCellForItemAtIndex: i];
          [aCell drawWithFrame: aRect inView: menuView];
        }
    }
}

- (void) drawBackgroundForMenuView: (NSMenuView*)menuView
                         withFrame: (NSRect)bounds
                         dirtyRect: (NSRect)dirtyRect
                        horizontal: (BOOL)horizontal
{
  // TS: unused
  // NSString  *name = horizontal ? GSMenuHorizontalBackground :
  //   GSMenuVerticalBackground;

  // TS: unused
  // NSRectEdge sides[4] = { NSMinXEdge, NSMaxYEdge, NSMaxXEdge, NSMinYEdge };


  [[self menuBackgroundColor] setFill];

  NSRect r = NSIntersectionRect(bounds, dirtyRect);
  NSRectFillUsingOperation(r, NSCompositeClear);
  NSBezierPath * roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect:r  xRadius: 4 yRadius: 4];
  //NSColor *borderColor = [self menuBorderColor];
  //[borderColor setStroke];
  [roundedRectanglePath fill];
  [roundedRectanglePath stroke];
}

- (void) drawBorderAndBackgroundForMenuItemCell: (NSMenuItemCell *)cell
                                      withFrame: (NSRect)cellFrame
                                         inView: (NSView *)controlView
                                          state: (GSThemeControlState)state
                                   isHorizontal: (BOOL)isHorizontal
{


  // TS: unused
  // NSColor * backgroundColor = [self menuItemBackgroundColor];
  NSColor* selectedBackgroundColor1 = [NSColor colorWithCalibratedRed: 0.392 green: 0.533 blue: 0.953 alpha: 1];
  NSColor* selectedBackgroundColor2 = [NSColor colorWithCalibratedRed: 0.165 green: 0.373 blue: 0.929 alpha: 1];

  NSColor* menuItemBackground = [self menuItemBackgroundColor];
  NSGradient* menuitemgradient = [[NSGradient alloc] initWithStartingColor: selectedBackgroundColor1
                                                               endingColor: selectedBackgroundColor2];
  NSColor * c;
  [cell setBordered:NO];
  cellFrame = [cell drawingRectForBounds: cellFrame];

  if(isHorizontal)
  {
    cellFrame.origin.y = 1;
  }
  if (state == GSThemeSelectedState || state == GSThemeHighlightedState)
    {

      NSRectFillUsingOperation(cellFrame, NSCompositeClear);
      [menuitemgradient drawInRect:cellFrame angle: -90];
      return;
    }
  else
    {
      if(isHorizontal)
        {
          return;
        }
      else
        {
          c = menuItemBackground;
        }
    }

  // Set cell's background color
  [c setFill];
  NSRectFillUsingOperation(cellFrame, NSCompositeClear);
  NSRectFill(cellFrame);

}


@end
