#include "Rik.h"
#include "RikScrollerKnobCell.h"
#include "RikScrollerKnobSlotCell.h"
#include "RikScrollerArrowCell.h"

@interface Rik(RikScroller)

@end

@implementation Rik(RikScroller)

/* NSScroller themeing. */

- (NSButtonCell*) cellForScrollerArrow: (NSScrollerArrow)arrow
			    horizontal: (BOOL)horizontal
{
  RikScrollerArrowCell	*cell;
  NSString	*name;

  cell = [RikScrollerArrowCell new];
  [cell setBezelStyle: NSRoundRectBezelStyle];
  if (horizontal)
    {
      if (arrow == NSScrollerDecrementArrow)
	{
	  [cell setHighlightsBy:
	    NSChangeBackgroundCellMask | NSContentsCellMask];
	  [cell setImage: [NSImage imageNamed: @"common_ArrowLeft"]];
	  [cell setImagePosition: NSImageOnly];
          name = GSScrollerLeftArrow;
    [cell setArrowType: RikScrollerArrowLeft];
	}
      else
	{
	  [cell setHighlightsBy:
	    NSChangeBackgroundCellMask | NSContentsCellMask];
      [cell setImage: [NSImage imageNamed: @"common_ArrowRight"]];
      [cell setImagePosition: NSImageOnly];
      name = GSScrollerRightArrow;
    [cell setArrowType: RikScrollerArrowRight];
	}
    }
  else
    {
      if (arrow == NSScrollerDecrementArrow)
	{
	  [cell setHighlightsBy:
	    NSChangeBackgroundCellMask | NSContentsCellMask];
      [cell setImage: [NSImage imageNamed: @"common_ArrowUp"]];
      [cell setImagePosition: NSImageOnly];
      name = GSScrollerUpArrow;
    [cell setArrowType: RikScrollerArrowUp];
	}
      else
	{
	  [cell setHighlightsBy:
	    NSChangeBackgroundCellMask | NSContentsCellMask];
	  [cell setImage: [NSImage imageNamed: @"common_ArrowDown"]];
	  [cell setImagePosition: NSImageOnly];
          name = GSScrollerDownArrow;
    [cell setArrowType: RikScrollerArrowDown];
	}
    }
  [self setName: name forElement: cell temporary: YES];
  RELEASE(cell);
  return cell;
}

- (NSCell*) cellForScrollerKnob: (BOOL)horizontal
{
  NSButtonCell	*cell;

  cell = [RikScrollerKnobCell new];
  [cell setButtonType: NSMomentaryChangeButton];
  [cell setBezelStyle: NSRoundedBezelStyle];
  [cell setImagePosition: NSImageOnly];

  [cell setTitle: @""];
  if (horizontal)
    {
      [self setName: GSScrollerHorizontalKnob forElement: cell temporary: YES];
    }
  else
    {
      [self setName: GSScrollerVerticalKnob forElement: cell temporary: YES];
    }
  RELEASE(cell);
  return cell;
}

- (NSCell*) cellForScrollerKnobSlot: (BOOL)horizontal
{
  // TS: unused
  // GSDrawTiles   		*tiles;
  RikScrollerKnobSlotCell	*cell;
  NSColor			*color;
  NSString      		*name;

  if (horizontal)
    {
      name = GSScrollerHorizontalSlot;
    }
  else
    {
      name = GSScrollerVerticalSlot;
    }

  // TS: unused
  // tiles = [self tilesNamed: name state: GSThemeNormalState];
  color = [self colorNamed: name state: GSThemeNormalState];

  cell = [RikScrollerKnobSlotCell new];
  [cell setBordered: false];
  [cell setTitle: nil];
  [cell setHorizontal: horizontal];
  [self setName: name forElement: cell temporary: YES];

  if (color == nil)
    {
      color = [NSColor scrollBarColor];
    }
  [cell setBackgroundColor: color];
  RELEASE(cell);
  return cell;
}
// REMEMBER THIS SETTING
- (float) defaultScrollerWidth
{
  return 16.0;
}

- (BOOL) scrollViewUseBottomCorner
{
  return YES;
}

- (BOOL) scrollViewScrollersOverlapBorders
{
  return NO;
}

@end
