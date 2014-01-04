SSRollingButtonScrollView
=========================

SSRollingButtonScrollView is a custom UIScrollView subclass that features an infinite looping scroll of UIButtons. Users of SSRollingButtonScrollView must, at minimum, provide an array of button titles and specify a layout style (horizontal scrolling or vertical scrolling). Through the implementation of the optional delegate methods, the user is informed of any button being pushed (touchUpInside), any button being scrolled to the center of the view, and most of the UIScrollViewDelegate methods (some are not available as they interfere with the working of the SSRollingButtonScrollView). The inifinite scrolling code is based on Apple's InfiniteScrollView class found in the StreetScroller sample project.


How To Use
----------

1. Add the **SSRollingButtonScrollView.h** and **SSRollingButtonScrollView.m** files to your project.

2. Add the **AudioToolbox.framework** to your project.

3. Add the appropriate **#import** and **@class** statements to the view controller(s) that will be using an SSRollingButtonScrollView.

	```objectivec
	//
	// ViewController.h
	//
	
	#import <UIKit/UIKit.h>
	
	@class SSRollingButtonScrollView;
	
	@interface ViewController : UIViewController
	
	@end
	```
	
	```objectivec
	//
	//  ViewController.m
	//
	
	#import "ViewController.h"
	#import "SSRollingButtonScrollView.h"
	
	@interface ViewController ()
	
	@end
	```
      
4. Add `<SSRollingButtonScrollViewDelegate>` to your view controller's **.m** file to make it an **SSRollingButtonScrollView** delegate.

	```objectivec
	@interface ViewController () <SSRollingButtonScrollViewDelegate>
	```

5. You will probably want to add the following delegate methods to your **.m** file so that the SSRollingButtonScrollView can trigger actions within your view controller.

	```objectivec
	#pragma mark - SSRollingButtonScrollViewDelegate

	- (void)rollingScrollViewButtonPushed:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView
	{
    	// Insert your code for action to take in the event an SSRollingButtonScrollView UIButton is pushed.
	}

	- (void)rollingScrollViewButtonIsInCenter:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView
	{
    	// Insert your code for action to take in the event an SSRollingButtonScrollView UIButton is scrolled to the center of the visible view.
	}
	```

6. Do more.
