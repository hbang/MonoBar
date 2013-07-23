/**
 * MonoBar - disable double height status bars
 *
 * By Ad@m <http://adam.hbang.ws>
 * Licensed under the MIT License <http://adam.mit-license.org>
 */

#import <UIKit/UIStatusBar.h>

%hook UIStatusBar
+ (CGRect)frameForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
	return %orig([self defaultStatusBarStyle], orientation);
}

+ (float)heightForStyle:(UIStatusBarStyle)style orientation:(UIInterfaceOrientation)orientation {
	return %orig([self defaultStatusBarStyle], orientation);
}
%end //yes, it's that simple.
