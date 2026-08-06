rik.theme - December 2024 Update
================================

A winter project to update Rik.theme to work with modern ObjC and clang-18.

## Two Main Problems

1) Original code relied on categories to override base class method definitions.
2) GSTheme "override" mechanism had a bug.

## Category Use

Much of the code used a pattern that looked like the following to override a method in an `NSWidget`.

``` objc
@implementation NSWidget (RikTheme)
- (void) method:(type)foo { ... }
@end
```

If a base class of `NSWidget` implemented the method, this worked because the category essentially adds the method to the class.  If `NSWidget` implemented the method itself, there was a collision and the result is undefined.

The solution was to use the "override" facility of `GSTheme` to override the method in `NSWidget` and then to trampoline into the method in the category.  Also, by giving it a new name.

The above code then becomes this.

``` objc
// a forward declaration of the category, now with methods renamed
@interface NSWidget (RikTheme)
- (void) RIKmethod:(type)foo;
@end

// put an override in the Rik class so that GSTheme finds it
@implementation Rik(NSWidget)
- (void) _overrideNSWidgetMethod_method:(type)foo {
  (NSWidget*) xself = (NSWidget*)self; // cast self
  [xself RIKmethod:foo];
}
@end

@implementation NSWidget (RikTheme)
- (void) RIKmethod:(type)foo { ... }
@end
```

## GSTheme bug

(Note: This is now fixed in https://github.com/gnustep/libs-gui/pull/325 Jan 2, 2025.)

For the `_overrideXXXMethod_yyy` facility to work, `GSTheme.m` needs to be fixed.

The following two lines

``` objc
memcpy(buf, name + 9, (ptr - name) + 9);
buf[(ptr - name) + 9] = '\0';
```

should be

``` objc
memcpy(buf, name + 9, (ptr - name) - 9);
buf[(ptr - name) - 9] = '\0';
```

## Demonstration Test Program

![TestDrawing screenshot](./TestDrawing-screenshot.png)

rik.theme
=========

a gnustep theme based on osx maverick.

UNDER DEVELOPMENT!!

====================

The main theme purpose, is to demonstrate that:

1) GNUstep is themable.
2) GNUstep can looks modern
3) GNUstep is not OPENSTEP, it follows Cocoa, and it is a Cocoa free and open source reimplementation

Soon, more infos. Enjoy!

====================

A pre-release screenshot.


![screenshot](https://github.com/BertrandDekoninck/rik.theme/blob/master/newscreen.png)
