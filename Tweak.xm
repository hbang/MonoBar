/**
 * MonoBar - disable double height status bars
 *
 * By Ad@m <http://adam.hbang.ws>
 * Licensed under the MIT License <http://adam.mit-license.org>
 */

#import <UIKit/UIStatusBar.h>

%hook UIStatusBar
+ (CGRect)frameForStyle:(int)style orientation:(int)orientation {
	return %orig([self defaultStatusBarStyle], orientation);
}
+ (float)heightForStyle:(int)style orientation:(int)orientation {
	return %orig([self defaultStatusBarStyle], orientation);
}
%end //yes, it's that simple.
