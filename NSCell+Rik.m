/**
* Copyright (C) 2014 Alessandro Sangiuliano
* Author: Alessandro Sangiuliano <alex22_7@hotmail.com>
* Date: 29 September 2014
*/

#import "Rik.h"

@interface NSCell(RikTheme)
- (void) RIKdrawInteriorWithFrame: (NSRect)cellFrame inView: (NSView*)controlView;
@end

@implementation Rik(NSCell)
- (void) _overrideNSCellMethod_drawInteriorWithFrame: (NSRect)cellFrame inView: (NSView*)controlView {
  RIKLOG(@"_overrideNSCellMethod_drawInteriorWithFrame:inView");
  NSCell *xself = (NSCell*) self;
  [xself RIKdrawInteriorWithFrame:cellFrame inView:controlView];
}
@end

@implementation NSCell(RikTheme)

- (void) RIKdrawInteriorWithFrame: (NSRect)cellFrame inView: (NSView*)controlView
{
  NSRect drawingRect = [self drawingRectForBounds: cellFrame];

  //FIXME: Check if this is also neccessary for images,
  // Add spacing between border and inside 
  if (_cell.is_bordered || _cell.is_bezeled)
    {
      drawingRect.origin.x += 3;
      drawingRect.size.width -= 6;
      drawingRect.origin.y -= 2;
      drawingRect.size.height += 3;
    }

  switch (_cell.type)
    {
      case NSTextCellType:
	if (_cell.in_editing)
	{
	  cellFrame.origin.y -= 2;
	  cellFrame.size.height += 4; //it works well, but not perfect
	  [self _drawEditorWithFrame: cellFrame inView: controlView];
	}
	else
	  [self _drawAttributedText: [self _drawAttributedString]
			    inFrame: drawingRect];
        break;

      case NSImageCellType:
        if (_cell_image)
          {
            NSSize size;
            NSPoint position;
            
            size = [_cell_image size];
            position.x = MAX(NSMidX(drawingRect) - (size.width/2.),0.);
            position.y = MAX(NSMidY(drawingRect) - (size.height/2.),0.);

            [_cell_image drawInRect: NSMakeRect(position.x, position.y, size.width, size.height)
			   fromRect: NSZeroRect
			  operation: NSCompositeSourceOver
			   fraction: 1.0
		     respectFlipped: YES
			      hints: nil];
          }
        break;

      case NSNullCellType:
        break;
    }

  // NB: We don't do any highlighting to make it easier for subclasses
  // to reuse this code while doing their own custom highlighting and
  // prettyfying
}

@end
