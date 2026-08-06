/**
* Copyright (C) 2014 Alessandro Sangiuliano
* Author: Alessandro Sangiuliano <alex22_7@hotmail.com>
* Date: 17 November 2014
*/

#import "Rik.h"

@interface NSBox (RikTheme)
- (void) RIKdrawRect: (NSRect)rect;
@end

@interface NSBox (Private)
- (NSRect) RIKcalcSizesAllowingNegative: (BOOL)aFlag;
@end

@implementation Rik(NSBox)
- (void) _overrideNSBoxMethod_drawRect: (NSRect)rect {
  RIKLOG(@"_overrideNSBoxMethod_drawRect:");
  NSBox* xself = (NSBox*)self;
  [xself RIKdrawRect:rect];
}

- (NSRect) _overrideNSBoxMethod_calcSizesAllowingNegative: (BOOL)aFlag {
  RIKLOG(@"_overrideNSBoxMethod_calcSizesAllowingNegative:");
  NSBox* xself = (NSBox*)self;
  return [xself RIKcalcSizesAllowingNegative:aFlag];
}
@end

@implementation NSBox (RikTheme)

- (void) RIKdrawRect: (NSRect)rect
{
	rect = NSIntersectionRect(_bounds, rect);
	[self setBorderWidth: 100.0];
	[[GSTheme theme] drawBoxInClipRect: rect
			           boxType: _box_type
			        borderType: _border_type
			            inView: self];
	

}

@end

@implementation NSBox (Private)

- (NSRect) RIKcalcSizesAllowingNegative: (BOOL)aFlag
{
  GSTheme	*theme = [GSTheme theme];
  NSRect r = NSZeroRect;

  if (_box_type == NSBoxSeparator)
    {
      _title_rect = NSZeroRect;
      _border_rect = _bounds;
      if (_bounds.size.width > _bounds.size.height)
	{
	  _border_rect.origin.y = (int)(_border_rect.size.height / 2);
	  _border_rect.size.height = 1;
	}
      else
	{
	  _border_rect.origin.x = (int)(_border_rect.size.width / 2);
	  _border_rect.size.width = 1;
	}
      return r;
    }				

  switch (_title_position)
    {
      case NSNoTitle: 
	{
	  NSSize borderSize = [theme sizeForBorderType: _border_type];
	  _border_rect = _bounds;
	  _title_rect = NSZeroRect;

	  // Add the offsets to the border rect
	  r.origin.x = _offsets.width + borderSize.width;
	  r.origin.y = _offsets.height + borderSize.height;
	  r.size.width = _border_rect.size.width - (2 * _offsets.width)
	    - (2 * borderSize.width);
	  r.size.height = _border_rect.size.height - (2 * _offsets.height)
	    - (2 * borderSize.height);

	  break;
	}
      case NSAboveTop: 
	{
	  NSSize titleSize = [_cell cellSize];
	  NSSize borderSize = [theme sizeForBorderType: _border_type];
	  float c;

	  // Add spacer around title
	  titleSize.width += 6;
	  titleSize.height += 2;

	  // Adjust border rect by title cell
	  _border_rect = _bounds;
	  _border_rect.size.height -= titleSize.height + borderSize.height;

	  // Add the offsets to the border rect
	  r.origin.x
	    = _border_rect.origin.x + _offsets.width + borderSize.width;
	  r.origin.y
	    = _border_rect.origin.y + _offsets.height + borderSize.height;
	  r.size.width = _border_rect.size.width - (2 * _offsets.width)
	    - (2 * borderSize.width);
	  r.size.height = _border_rect.size.height - (2 * _offsets.height)
	    - (2 * borderSize.height);

	  // center the title cell
	  c = (_bounds.size.width - titleSize.width) / 2;
	  if (c < 0) c = 0;
	  _title_rect.origin.x = _bounds.origin.x + c;
	  _title_rect.origin.y = _bounds.origin.y + _border_rect.size.height
	    + borderSize.height;
	  _title_rect.size = titleSize;

	  break;
	}
      case NSBelowTop: 
	{
	  NSSize titleSize = [_cell cellSize];
	  NSSize borderSize = [theme sizeForBorderType: _border_type];
	  float c;

	  // Add spacer around title
	  titleSize.width += 6;
	  titleSize.height += 2;

	  // Adjust border rect by title cell
	  _border_rect = _bounds;

	  // Add the offsets to the border rect
	  r.origin.x
	    = _border_rect.origin.x + _offsets.width + borderSize.width;
	  r.origin.y
	    = _border_rect.origin.y + _offsets.height + borderSize.height;
	  r.size.width = _border_rect.size.width - (2 * _offsets.width)
	    - (2 * borderSize.width);
	  r.size.height = _border_rect.size.height - (2 * _offsets.height)
	    - (2 * borderSize.height);

	  // Adjust by the title size
	  r.size.height -= titleSize.height + borderSize.height;

	  // center the title cell
	  c = (_border_rect.size.width - titleSize.width) / 2;
	  if (c < 0) c = 0;
	  _title_rect.origin.x = _border_rect.origin.x + c;
	  _title_rect.origin.y
	    = _border_rect.origin.y + _border_rect.size.height
	    - titleSize.height - borderSize.height;
	  _title_rect.size = titleSize;

	  break;
	}
      case NSAtTop: 
	{
	  NSSize titleSize = [_cell cellSize];
	  NSSize borderSize = [theme sizeForBorderType: _border_type];
	  float c;
	  float topMargin;
	  float topOffset;

	  // Add spacer around title
	  titleSize.width += 6;
	  titleSize.height += 2;

	  _border_rect = _bounds;
	
	  topMargin = ceil(titleSize.height / 2);
	//This -3 fix the border 
	  topOffset = titleSize.height - topMargin - 3;
	  
	  // Adjust by the title size
	  _border_rect.size.height -= topMargin;
	  // Add the offsets to the border rect
	  r.origin.x
	    = _border_rect.origin.x + _offsets.width + borderSize.width;
	  r.size.width = _border_rect.size.width - (2 * _offsets.width)
	    - (2 * borderSize.width) + 5;
	  
	  if (topOffset > _offsets.height)
	    {
	      r.origin.y
		= _border_rect.origin.y + _offsets.height + borderSize.height;
	      r.size.height = _border_rect.size.height - _offsets.height
		- (2 * borderSize.height) - topOffset;
	    }
	  else
	    {
	      r.origin.y
		= _border_rect.origin.y + _offsets.height + borderSize.height;
	      r.size.height = _border_rect.size.height - (2 * _offsets.height)
		- (2 * borderSize.height);
	    }

	  // Adjust by the title size
	  //	r.size.height -= titleSize.height + borderSize.height;

	  // center the title cell
	  c = (_border_rect.size.width - titleSize.width) / 2;
	  if (c < 0) c = 0;
	  _title_rect.origin.x = _border_rect.origin.x + c;
	  _title_rect.origin.y
	    = _border_rect.origin.y + _border_rect.size.height - topMargin;
	  _title_rect.size = titleSize;

	  break;
	}
      case NSAtBottom: 
	{
	  NSSize titleSize = [_cell cellSize];
	  NSSize borderSize = [theme sizeForBorderType: _border_type];
	  float c;
	  float bottomMargin;
	  float bottomOffset;

	  // Add spacer around title
	  titleSize.width += 6;
	  titleSize.height += 2;

	  _border_rect = _bounds;

	  bottomMargin = ceil(titleSize.height / 2);
	  bottomOffset = titleSize.height - bottomMargin;

	  // Adjust by the title size
	  _border_rect.origin.y += bottomMargin;
	  _border_rect.size.height -= bottomMargin;

	  // Add the offsets to the border rect
	  r.origin.x = _border_rect.origin.x + _offsets.width + borderSize.width;
	  r.size.width = _border_rect.size.width - (2 * _offsets.width)
	    - (2 * borderSize.width);

	  if (bottomOffset > _offsets.height)
	    {
	      r.origin.y
		= _border_rect.origin.y + bottomOffset + borderSize.height;
	      r.size.height = _border_rect.size.height - _offsets.height
		- bottomOffset
		- (2 * borderSize.height);
	    }
	  else
	    {
	      r.origin.y
		= _border_rect.origin.y + _offsets.height + borderSize.height;
	      r.size.height = _border_rect.size.height - (2 * _offsets.height)
		- (2 * borderSize.height);
	    }

	  // Adjust by the title size
	  /*
	  r.origin.y += (titleSize.height / 2) + borderSize.height;
	  r.size.height -= (titleSize.height / 2) + borderSize.height;
	  */
	  // center the title cell
	  c = (_border_rect.size.width - titleSize.width) / 2;
	  if (c < 0) c = 0;
	  _title_rect.origin.x = c;
	  _title_rect.origin.y = 0;
	  _title_rect.size = titleSize;

	  break;
	}
      case NSBelowBottom: 
	{
	  NSSize titleSize = [_cell cellSize];
	  NSSize borderSize = [theme sizeForBorderType: _border_type];
	  float c;

	  // Add spacer around title
	  titleSize.width += 6;
	  titleSize.height += 2;

	  // Adjust by the title
	  _border_rect = _bounds;
	  _border_rect.origin.y += titleSize.height + borderSize.height;
	  _border_rect.size.height -= titleSize.height + borderSize.height;

	  // Add the offsets to the border rect
	  r.origin.x
	    = _border_rect.origin.x + _offsets.width + borderSize.width;
	  r.origin.y
	    = _border_rect.origin.y + _offsets.height + borderSize.height;
	  r.size.width = _border_rect.size.width - (2 * _offsets.width)
	    - (2 * borderSize.width);
	  r.size.height = _border_rect.size.height - (2 * _offsets.height)
	    - (2 * borderSize.height);

	  // center the title cell
	  c = (_border_rect.size.width - titleSize.width) / 2;
	  if (c < 0) c = 0;
	  _title_rect.origin.x = c;
	  _title_rect.origin.y = 0;
	  _title_rect.size = titleSize;

	  break;
	}
      case NSAboveBottom: 
	{
	  NSSize titleSize = [_cell cellSize];
	  NSSize borderSize = [theme sizeForBorderType: _border_type];
	  float c;

	  // Add spacer around title
	  titleSize.width += 6;
	  titleSize.height += 2;

	  _border_rect = _bounds;

	  // Add the offsets to the border rect
	  r.origin.x
	    = _border_rect.origin.x + _offsets.width + borderSize.width;
	  r.origin.y
	    = _border_rect.origin.y + _offsets.height + borderSize.height;
	  r.size.width = _border_rect.size.width - (2 * _offsets.width)
	    - (2 * borderSize.width);
	  r.size.height = _border_rect.size.height - (2 * _offsets.height)
	    - (2 * borderSize.height);

	  // Adjust by the title size
	  r.origin.y += titleSize.height + borderSize.height;
	  r.size.height -= titleSize.height + borderSize.height;

	  // center the title cell
	  c = (_border_rect.size.width - titleSize.width) / 2;
	  if (c < 0) c = 0;
	  _title_rect.origin.x = _border_rect.origin.x + c;
	  _title_rect.origin.y = _border_rect.origin.y + borderSize.height;
	  _title_rect.size = titleSize;

	  break;
	}
    }

  if (!aFlag)
    {
      if (r.size.width < 0)
	{
	  r.size.width = 0;
	}
      if (r.size.height < 0)
	{
	  r.size.height = 0;
	}
    }
  
  return r;
}

@end
