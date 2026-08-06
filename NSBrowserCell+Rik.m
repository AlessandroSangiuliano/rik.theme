#include "Rik.h"

@interface NSBrowserCell(RikTheme)
- (void) RIKdrawInteriorWithFrame: (NSRect)cellFrame inView: (NSView *)controlView;
@end

@implementation Rik(NSBrowserCell)
- (void) _overrideNSBrowserCellMethod_drawInteriorWithFrame: (NSRect)cellFrame inView: (NSView *)controlView {
  RIKLOG(@"_overrideNSBrowserCellMethod_drawInteriorWithFrame:inView:");
  NSBrowserCell *xself = (NSBrowserCell*)self;
  [xself RIKdrawInteriorWithFrame:cellFrame inView:controlView];
}
@end

@implementation NSBrowserCell(RikTheme)

/*
 * Displaying
 */
- (void) RIKdrawInteriorWithFrame: (NSRect)cellFrame inView: (NSView *)controlView
{
  NSRect	title_rect = cellFrame;
  NSImage	*branch_image = nil;
  NSImage	*cell_image = [self image];

  if (_cell.is_highlighted || _cell.state)
    {
      if (!_browsercell_is_leaf)
	branch_image = [object_getClass(self) highlightedBranchImage];
      if (nil != [self alternateImage])
	  cell_image = [self alternateImage];

      // If we are highlighted, fill the background
      [[self highlightColorInView: controlView] setFill];
      NSRectFill(cellFrame);
    }
  else
    {
      if (!_browsercell_is_leaf)
	branch_image = [object_getClass(self) branchImage];

      // (Don't fill the background)
    }

  // Draw the branch image if there is one
  if (branch_image)
    {
      NSRect imgRect;

      imgRect.size = [branch_image size];
      imgRect.origin.x = MAX(NSMaxX(title_rect) - imgRect.size.width - 4.0, 0.);
      imgRect.origin.y = MAX(NSMidY(title_rect) - (imgRect.size.height/2.), 0.);

      if (controlView != nil)
	{
	  imgRect = [controlView centerScanRect: imgRect];
	}

      [branch_image drawInRect: imgRect
		      fromRect: NSZeroRect
		     operation: NSCompositeSourceOver
		      fraction: 1.0
		respectFlipped: YES
			 hints: nil];

      title_rect.size.width -= imgRect.size.width + 8;
    }

  // Skip 2 points from the left border
  title_rect.origin.x += 2;
  title_rect.size.width -= 2;

  // Draw the cell image if there is one
  if (cell_image)
    {
      NSRect imgRect;

      imgRect.size = [cell_image size];
      imgRect.origin.x = NSMinX(title_rect);
      imgRect.origin.y = MAX(NSMidY(title_rect) - (imgRect.size.height/2.),0.);

      if (controlView != nil)
	{
	  imgRect = [controlView centerScanRect: imgRect];
	}

      [cell_image drawInRect: imgRect
		    fromRect: NSZeroRect
		   operation: NSCompositeSourceOver
		    fraction: 1.0
	      respectFlipped: YES
		       hints: nil];

      title_rect.origin.x += imgRect.size.width + 4;
      title_rect.size.width -= imgRect.size.width + 4;
   }

  // Draw the body of the cell
  if (_cell.in_editing)
    {
      [self _drawEditorWithFrame: cellFrame inView: controlView];
    }
  else
    {
      [self _drawAttributedText: [self attributedStringValue]
                        inFrame: title_rect];
    }
}
@end
