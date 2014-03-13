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

%hook UIStatusBar

// Useless methods:
// + (CGRect)_frameForStyle:(int)arg1 orientation:(int)arg2 inWindowOfSize:(CGSize)arg3
// + (CGRect)_frameForStyleAttributes:(id)arg1 orientation:(int)arg2 inWindowOfSize:(CGSize)arg3
// + (CGRect)_frameForStyleAttributes:(id)arg1 orientation:(int)arg2
// - (CGRect)_backgroundFrameForAttributes:(id)arg1

+ (float)heightForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
    return %orig([self defaultStatusBarStyleWithTint:NO], orientation);
}

%end

%end // %group Ive

%ctor {
    if (IS_IOS_OR_NEWER(7.0)) {
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
