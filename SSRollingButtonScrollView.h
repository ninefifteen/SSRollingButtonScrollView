//
//  SSRollingButtonScrollView.h
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//
//  SSRollingButtonScrollView is a custom UIScrollView subclass that features an
//  infinite looping scroll of UIButtons.  Users of SSRollingButtonScrollView
//  must, at minimum, provide an array of button titles and specify a layout style.
//  Through the implementation of the optional delegate methods, the user is informed
//  of any button being pushed (touchUpInside), any button being scrolled to thegit 
//  center of the view, and most of the UIScrollViewDelegate methods (some are not
//  available as they interfere with the working of the SSRollingButtonScrollView).
//  The inifinite scrolling code is based on Apple's InfiniteScrollView class found
//  in the StreetScroller sample project.

#import <UIKit/UIKit.h>

typedef enum {
    SShorizontalLayout,
    SSverticalLayout
} SScontentLayoutStyle;

@class SSRollingButtonScrollView;

@protocol SSRollingButtonScrollViewDelegate <NSObject>

// SSRollingButtonScrollViewDelegate specific methods.
@optional
- (void)rollingScrollViewButtonPushed:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView;
- (void)rollingScrollViewButtonIsInCenter:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView;

// Useable UIScrollViewDelegate methods.
// Do NOT set a UIScrollViewDelegate! Use SSRollingButtonScrollViewDelegate!
@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end

@interface SSRollingButtonScrollView : UIScrollView <UIScrollViewDelegate>

// USE THIS DELEGATE ONLY!!! Do NOT set a UIScrollView delegate!!! The SSRollingButtonScrollViewDelegate
// will pass on the useable UIScrollViewDelegate methods.
@property (nonatomic, weak) id <SSRollingButtonScrollViewDelegate> ssRollingButtonScrollViewDelegate;

// Optional. All the properties below have default settings and only need
// to be set if the user desires to change the the default appearance and/or
// functionality.  If set by user, must be set before calling "createButtonArrayWithTitles:".
@property (strong, nonatomic) UIFont *buttonNotCenterFont;
@property (strong, nonatomic) UIFont *buttonCenterFont;
@property (nonatomic) CGFloat fixedButtonWidth;
@property (nonatomic) CGFloat fixedButtonHeight;
@property (nonatomic) CGFloat spacingBetweenButtons;
@property (strong, nonatomic) UIColor *notCenterButtonTextColor;
@property (strong, nonatomic) UIColor *centerButtonTextColor;
@property (strong, nonatomic) UIColor *notCenterButtonBackgroundColor;
@property (strong, nonatomic) UIColor *centerButtonBackgroundColor;
@property (strong, nonatomic) UIImage *notCenterButtonBackgroundImage;
@property (strong, nonatomic) UIImage *centerButtonBackgroundImage;
@property (nonatomic) BOOL stopOnCenter;
@property (nonatomic) BOOL centerPushedButtons;
@property (nonatomic) BOOL playSound;

// Must be called.  If optional properties are to be changed from their default settings, they must
// be set prior to calling "createButtonArrayWithTitles:".
- (void)createButtonArrayWithButtonTitles:(NSArray *)titles andLayoutStyle:(SScontentLayoutStyle)layoutStyle;



@end
