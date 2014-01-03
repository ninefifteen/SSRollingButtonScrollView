//
//  SSRollingButtonScrollView.h
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SShorizontalLayout,
    SSverticalLayout
} SScontentLayoutStyle;

@class SSRollingButtonScrollView;

@protocol SSRollingButtonScrollViewDelegate <NSObject>

@optional
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
@property (nonatomic) CGFloat fixedButtonSpacing; // Sets button origin points a fixed distance apart.
@property (nonatomic) CGFloat buttonPadding; // Pads button dimensions if fixedButtonSpacing is not used.
@property (nonatomic, strong) UIColor *notCenterButtonTextColor;
@property (nonatomic, strong) UIColor *centerButtonTextColor;
@property (nonatomic) BOOL stopOnCenter;
@property (nonatomic) BOOL centerPushedButtons;

// The following method must be called before calling "createButtonArray".
- (void)setButtonTitles:(NSArray *)titles;

// Must be called last.
- (void)createButtonArray;



@end
