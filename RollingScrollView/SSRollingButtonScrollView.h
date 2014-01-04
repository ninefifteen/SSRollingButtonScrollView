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
//  of any button being pushed (touchUpInside), any button being scrolled to the
//  center of the view, and most of the UIScrollViewDelegate methods (some are not
//  available as they interfere with the working of the SSRollingButtonScrollView).

#import <UIKit/UIKit.h>

typedef enum {
    SShorizontalLayout,
    SSverticalLayout
} SScontentLayoutStyle;

@class SSRollingButtonScrollView;

@protocol SSRollingButtonScrollViewDelegate <NSObject>

@optional   // SSRollingButtonScrollViewDelegate specific methods.
- (void)rollingScrollViewButtonPushed:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView;
- (void)rollingScrollViewButtonIsInCenter:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView;

@optional   // Useable UIScrollViewDelegate methods.  Do NOT set a UIScrollViewDelegate.  Use SSRollingButtonScrollViewDelegate.
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end

@interface SSRollingButtonScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id <SSRollingButtonScrollViewDelegate> ssRollingButtonScrollViewDelegate;

// Mandatory. Must be set before calling "createButtonArray".
@property (nonatomic) SScontentLayoutStyle layoutStyle;

// Optional. If set by user, must be set before calling "createButtonArray".
@property (nonatomic, strong) UIFont *buttonNotCenterFont;
@property (nonatomic, strong) UIFont *buttonCenterFont;
@property (nonatomic) CGFloat fixedButtonWidth;
@property (nonatomic) CGFloat fixedButtonHeight;
@property (nonatomic) CGFloat spacingBetweenButtons;
@property (nonatomic, strong) UIColor *notCenterButtonTextColor;
@property (nonatomic, strong) UIColor *centerButtonTextColor;
@property (nonatomic, strong) UIColor *notCenterButtonBackgroundColor;
@property (nonatomic, strong) UIColor *centerButtonBackgroundColor;
@property (nonatomic, strong) UIImage *notCenterButtonBackgroundImage;
@property (nonatomic, strong) UIImage *centerButtonBackgroundImage;
@property (nonatomic) BOOL stopOnCenter;
@property (nonatomic) BOOL centerPushedButtons;

// The following method must be called before calling "createButtonArray".
- (void)setButtonTitles:(NSArray *)titles;

// Must be called last.
- (void)createButtonArray;



@end
