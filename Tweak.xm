/**
 * MonoBar - disable double height status bars
 *
 * By kirb <http://adam.hbang.ws> and insanj <http://insanj.com>
 * Licensed under the MIT License <http://adam.mit-license.org>
 */

#import <UIKit/UIKit.h>
#define IS_IOS_OR_NEWER(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version)

@interface UIStatusBar
+ (UIStatusBarStyle)defaultStatusBarStyle;
+ (UIStatusBarStyle)defaultStatusBarStyleWithTint:(BOOL)arg1;
+ (id)_styleAttributesForStatusBarStyle:(int)arg1 legacy:(BOOL)arg2;

+ (CGRect)frameForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation;
+ (float)heightForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation;

- (void)_setFrameForStyle:(int)arg1;
@end

%group Jobs

%hook UIStatusBar

+ (CGRect)frameForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
	return %orig([self defaultStatusBarStyle], orientation);
}

+ (float)heightForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
	return %orig([self defaultStatusBarStyle], orientation);
}

%end // yes, it's that simple.

%end // %group Jobs

%group Forstall

%hook UIStatusBar

+ (CGRect)frameForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
    return %orig([self defaultStatusBarStyleWithTint:NO], orientation);
}

+ (float)heightForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
    return %orig([self defaultStatusBarStyleWithTint:NO], orientation);
}

%end

%end // %group Forstall

%group Ive

%hook UIApplication

// Intended to prevent shifting when call begins, doesn't seem to
// have an effect
- (void)_notifyDidChangeStatusBarFrame:(CGRect)arg1 {
    return;
}

- (void)_notifyWillChangeStatusBarFrame:(CGRect)arg1 {
    return;
}

// Doesn't seem to have much of an effect
- (int)statusBarStyle {
    return [UIStatusBar defaultStatusBarStyleWithTint:NO];
}

%end

%group Federighi

// Intended to prevent shifting when call begins, doesn't seem to
// have an effect
- (void)_notifyDidChangeStatusBarFrame:(CGRect)arg1 {
    return;
}

- (void)_notifyWillChangeStatusBarFrame:(CGRect)arg1 {
    return;
}

// Doesn't seem to have much of an effect
- (long long)statusBarStyle {
    return [UIStatusBar defaultStatusBarStyleWithTint:NO];
}

%end

%hook UIStatusBar

// Useless methods:
// + (CGRect)_frameForStyle:(int)arg1 orientation:(int)arg2 inWindowOfSize:(CGSize)arg3
// + (CGRect)_frameForStyleAttributes:(id)arg1 orientation:(int)arg2 inWindowOfSize:(CGSize)arg3
// + (CGRect)_frameForStyleAttributes:(id)arg1 orientation:(int)arg2
// - (CGRect)_backgroundFrameForAttributes:(id)arg1
// - (void)_setOverrideHeight:(float)arg1
// - (id)initWithFrame:(CGRect)arg1

// Touching these messes with Phone app, and doesn't always shrink (just fools apps):
// - (float)heightForOrientation:(int)arg1
// - (float)currentHeight

// These may bring Safe Mode, or just do nothing valuable:
// - (CGRect)currentFrame

// The following methods shrink or fool apps, but prevent touching:
// - (id)_currentStyleAttributes
// - (int)currentStyle

+ (float)heightForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
    return %orig([self defaultStatusBarStyleWithTint:NO], orientation);
}

- (void)_setFrameForStyle:(id)arg1 {
    %orig([UIStatusBar _styleAttributesForStatusBarStyle:[UIStatusBar defaultStatusBarStyleWithTint:NO] legacy:NO]);
}

%end

%hook UIStatusBarBackgroundView

// Prevents frame setting while in app, but the label still shows,
// and everything still gets shifted down. Not really useful.
- (id)initWithFrame:(CGRect)arg1 style:(id)arg2 backgroundColor:(id)arg3 {
    return %orig(CGRectMake(arg1.origin.x, arg1.origin.y, arg1.size.width, 20.0), arg2, arg3);
}

- (void)setFrame:(CGRect)arg1 {
    %orig(CGRectMake(arg1.origin.x, arg1.origin.y, arg1.size.width, 20.0));
}

%end

%end // %group Ive

%ctor {
    if (IS_IOS_OR_NEWER(8.0)) {
        NSLog(@"[MonoBar] Injecting override code for iOS 8 devices...");
        %init(Federighi);
    }

    else if (IS_IOS_OR_NEWER(7.0)) {
        NSLog(@"[MonoBar] Injecting override code for iOS 7 devices...");
		%init(Ive);
    }

    else if(IS_IOS_OR_NEWER(6.0)) {
        NSLog(@"[MonoBar] Injecting override code for iOS 6 devices...");
		%init(Forstall);
    }

    else {
        NSLog(@"[MonoBar] Injecting override code for iOS 5 (and older) devices...");
        %init(Jobs);
    }
}
