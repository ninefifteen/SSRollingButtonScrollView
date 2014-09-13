//
//  SSRollingButtonScrollView.m
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//

#import "SSRollingButtonScrollView.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation SSRollingButtonScrollView
{
    BOOL _viewsInitialLoad;
    BOOL _lockCenterButton;
    
    NSMutableArray *_rollingScrollViewButtonTitles;
    SScontentLayoutStyle _layoutStyle;
    
    NSMutableArray *_rollingScrollViewButtons;
    NSMutableArray *_visibleButtons;
    UIView *_buttonContainerView;
    
    NSInteger _rightMostVisibleButtonIndex;
    NSInteger _leftMostVisibleButtonIndex;
    
    NSInteger _topMostVisibleButtonIndex;
    NSInteger _bottomMostVisibleButtonIndex;
    
    NSInteger _scrollViewSelectedIndex;
    CGPoint _lastOffset;
    NSTimeInterval _lastTimeCapture;
    CGFloat _scrollVelocity;
    UIButton *_currentCenterButton;
    
    CGFloat _width;
    CGFloat _height;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        _viewsInitialLoad = YES;
        _lockCenterButton = NO;
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
        _rollingScrollViewButtonTitles = [NSMutableArray array];
        _rollingScrollViewButtons = [NSMutableArray array];
        _visibleButtons = [NSMutableArray array];
        _buttonContainerView = [[UIView alloc] init];
        _currentCenterButton = [[UIButton alloc] init];
        
        self.fixedButtonWidth = -1.0f;
        self.fixedButtonHeight = -1.0f;
        self.spacingBetweenButtons = 0.0f;
        self.notCenterButtonBackgroundColor = [UIColor clearColor];
        self.centerButtonBackgroundColor = [UIColor clearColor];
        self.notCenterButtonBackgroundImage = nil;
        self.centerButtonBackgroundImage = nil;
        self.buttonNotCenterFont = [UIFont systemFontOfSize:16];
        self.buttonCenterFont = [UIFont boldSystemFontOfSize:20];
        self.notCenterButtonTextColor = [UIColor grayColor];
        self.centerButtonTextColor = [UIColor orangeColor];
        self.stopOnCenter = YES;
        self.centerPushedButtons = YES;
        self.playSound = YES;
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
        
        //
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        
        self.delegate = self;
    }
    return self;
}

- (void)setContentSizeAndButtonContainerViewFrame
{
    if (_layoutStyle == SShorizontalLayout) {
        self.contentSize = CGSizeMake(5000, self.frame.size.height);
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width, 5000);
    }
    
    _buttonContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self addSubview:_buttonContainerView];
}

- (UIButton *)createAndConfigureNewButton:(NSString *)buttonTitle
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    button.titleLabel.font = self.buttonNotCenterFont;
    [button setTitleColor:self.notCenterButtonTextColor forState:UIControlStateNormal];
    [button setTitleColor:self.centerButtonTextColor forState:UIControlStateHighlighted];
    [button setBackgroundColor:self.notCenterButtonBackgroundColor];
    
    if (self.notCenterButtonBackgroundImage != nil) {
        [button setBackgroundImage:self.notCenterButtonBackgroundImage forState:UIControlStateNormal];
    }
    
    return button;
}

- (void)createButtonArrayWithButtonTitles:(NSArray *)titles andLayoutStyle:(SScontentLayoutStyle)layoutStyle
{
    _rollingScrollViewButtonTitles = [NSMutableArray arrayWithArray:titles];
    _layoutStyle = layoutStyle;
    
    [self setContentSizeAndButtonContainerViewFrame];
    
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    CGFloat buttonWidth;
    CGFloat buttonHeight;
    _rollingScrollViewButtons = [NSMutableArray array];
    
    if (_layoutStyle == SShorizontalLayout) {
        
        while (x <= self.frame.size.width * 2) {
            
            for (NSString *buttonTitle in _rollingScrollViewButtonTitles) {
                
                UIButton *button = [self createAndConfigureNewButton:buttonTitle];
                
                CGSize fittedButtonSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.buttonCenterFont}];
                
                if (self.fixedButtonWidth < 0) {
                    buttonWidth = ceilf(fittedButtonSize.width / 2) * 2;
                } else {
                    buttonWidth = self.fixedButtonWidth;
                }
                
                if (self.fixedButtonHeight < 0) {
                    buttonHeight = ceilf(fittedButtonSize.height / 2) * 2;
                } else {
                    buttonHeight = self.fixedButtonHeight;
                }
                
                button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
                
                x += buttonWidth + self.spacingBetweenButtons;
                
                [button addTarget:self action:@selector(scrollViewButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
                
                [_rollingScrollViewButtons addObject:button];
            }
        }
        
    } else {
        
        while (y <= self.frame.size.height * 2) {
            
            for (NSString *buttonTitle in _rollingScrollViewButtonTitles) {
                
                UIButton *button = [self createAndConfigureNewButton:buttonTitle];
                
                CGSize fittedButtonSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.buttonCenterFont}];
                
                if (self.fixedButtonWidth < 0) {
                    buttonWidth = ceilf(fittedButtonSize.width / 2) * 2;
                } else {
                    buttonWidth = self.fixedButtonWidth;
                }
                
                if (self.fixedButtonHeight < 0) {
                    buttonHeight = ceilf(fittedButtonSize.height / 2) * 2;
                } else {
                    buttonHeight = self.fixedButtonHeight;
                }
                
                button.frame = CGRectMake(x, y, buttonWidth, buttonHeight);
                
                y += buttonHeight + self.spacingBetweenButtons;
                
                [button addTarget:self action:@selector(scrollViewButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
                
                [_rollingScrollViewButtons addObject:button];
            }
        }
    }
    
    [self addSubview:_buttonContainerView];
    [self moveButtonToViewCenter:_currentCenterButton animated:YES];
}

- (void)layoutSubviews
{
    // If change in view size (typically due to device rotation), prevent center button from changing.
    if (_width != self.bounds.size.width || _height != self.bounds.size.height) {
        _width = self.bounds.size.width;
        _height = self.bounds.size.height;
        _lockCenterButton = YES;
    }
    
    [super layoutSubviews];
    
    if ([_rollingScrollViewButtonTitles count] > 0) {
        
        if (_lockCenterButton) {
            [self moveButtonToViewCenter:_currentCenterButton animated:NO];
            _lockCenterButton = NO;
        }
        
        [self recenterIfNecessary];
        [self tileContentInVisibleBounds];
        [self configureCenterButton:[self getCenterButton]];
        
        if (_viewsInitialLoad) {
            [self moveButtonToViewCenter:_currentCenterButton animated:NO];
            [self tileContentInVisibleBounds];
            _viewsInitialLoad = NO;
        }
    }
}

- (void)tileContentInVisibleBounds
{
    CGRect visibleBounds = [self convertRect:[self bounds] toView:_buttonContainerView];
    
    if (_layoutStyle == SShorizontalLayout) {
        
        CGFloat minimumVisibleX = CGRectGetMinX(visibleBounds);
        CGFloat maximumVisibleX = CGRectGetMaxX(visibleBounds);
        [self tileButtonsFromMinX:minimumVisibleX toMaxX:maximumVisibleX];
        
    } else {
        
        CGFloat minimumVisibleY = CGRectGetMinY(visibleBounds);
        CGFloat maximumVisibleY = CGRectGetMaxY(visibleBounds);
        [self tileButtonsFromMinY:minimumVisibleY toMaxY:maximumVisibleY];
    }
}

- (void)configureCenterButton:(UIButton *)centerButton
{
    if (centerButton != _currentCenterButton) {
        
        _currentCenterButton = centerButton;
        
        for (UIButton *button in _visibleButtons) {
            [button setBackgroundColor:self.notCenterButtonBackgroundColor];
            [button setBackgroundImage:self.notCenterButtonBackgroundImage forState:UIControlStateNormal];
            button.titleLabel.font = self.buttonNotCenterFont;
            [button setTitleColor:self.notCenterButtonTextColor forState:UIControlStateNormal];
        }
        [centerButton setBackgroundColor:self.centerButtonBackgroundColor];
        [centerButton setBackgroundImage:self.centerButtonBackgroundImage forState:UIControlStateNormal];
        centerButton.titleLabel.font = self.buttonCenterFont;
        centerButton.titleLabel.textColor = self.centerButtonTextColor;
        [centerButton setTitleColor:self.centerButtonTextColor forState:UIControlStateNormal];
        
        if (self.playSound) {
            AudioServicesPlaySystemSound(1105);
        }
    }
}

- (UIButton *)getCenterButton
{
    UIButton *centerButton = [[UIButton alloc] init];
    
    CGFloat buttonMinimumDistanceFromCenter = 5000.0f;
    CGFloat currentButtonDistanceFromCenter = 5000.0f;
    
    for (UIButton *button in _visibleButtons) {
        
        currentButtonDistanceFromCenter = fabs([self buttonDistanceFromCenter:button]);
        
        if (currentButtonDistanceFromCenter < buttonMinimumDistanceFromCenter) {
            buttonMinimumDistanceFromCenter = currentButtonDistanceFromCenter;
            centerButton = button;
        }
    }
    
    return centerButton;
}

- (CGFloat)buttonDistanceFromCenter:(UIButton *)button
{
    CGFloat distanceFromCenter;
    
    if (_layoutStyle == SShorizontalLayout) {
        
        CGFloat visibleContentCenterX = self.contentOffset.x + [self bounds].size.width / 2.0f;
        distanceFromCenter = visibleContentCenterX - button.center.x;
        
    } else {
        
        CGFloat visibleContentCenterY = self.contentOffset.y + [self bounds].size.height / 2.0f;
        distanceFromCenter = visibleContentCenterY - button.center.y;
    }
    
    return distanceFromCenter;
}

- (void)moveButtonToViewCenter:(UIButton *)button animated:(BOOL)animated
{
    if (_layoutStyle == SShorizontalLayout) {
        
        CGPoint currentOffset = self.contentOffset;
        CGFloat distanceFromCenter = [self buttonDistanceFromCenter:button];
        
        CGPoint targetOffset = CGPointMake(currentOffset.x - distanceFromCenter, 0.0f);
        [self setContentOffset:targetOffset animated:animated];
        
    } else {
        
        CGPoint currentOffset = self.contentOffset;
        CGFloat distanceFromCenter = [self buttonDistanceFromCenter:button];
        
        CGPoint targetOffset = CGPointMake(0.0f, currentOffset.y - distanceFromCenter);
        [self setContentOffset:targetOffset animated:animated];
    }
}

- (void)recenterIfNecessary
{
    if (_layoutStyle == SShorizontalLayout) {
        
        CGPoint currentOffset = [self contentOffset];
        CGFloat contentWidth = [self contentSize].width;
        CGFloat centerOffsetX = (contentWidth - [self bounds].size.width) / 2.0;
        CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
        
        if (distanceFromCenter > (contentWidth / 4.0))
        {
            self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
            
            // move content by the same amount so it appears to stay still
            for (UIButton *button in _rollingScrollViewButtons) {
                CGPoint center = [_buttonContainerView convertPoint:button.center toView:self];
                center.x += (centerOffsetX - currentOffset.x);
                button.center = [self convertPoint:center toView:_buttonContainerView];
            }
        }
        
    } else {
        
        CGPoint currentOffset = [self contentOffset];
        CGFloat contentHeight = [self contentSize].height;
        CGFloat centerOffsetY = (contentHeight - [self bounds].size.height) / 2.0;
        CGFloat distanceFromCenter = fabs(currentOffset.y - centerOffsetY);
        
        if (distanceFromCenter > (contentHeight / 4.0))
        {
            self.contentOffset = CGPointMake(currentOffset.x, centerOffsetY);
            
            // move content by the same amount so it appears to stay still
            for (UIButton *button in _rollingScrollViewButtons) {
                CGPoint center = [_buttonContainerView convertPoint:button.center toView:self];
                center.y += (centerOffsetY - currentOffset.y);
                button.center = [self convertPoint:center toView:_buttonContainerView];
            }
        }
        
    }
}

- (void)scrollViewButtonIsInCenter:(UIButton *)sender
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(rollingScrollViewButtonIsInCenter:ssRollingButtonScrollView:)]) {
        [self.ssRollingButtonScrollViewDelegate rollingScrollViewButtonIsInCenter:sender ssRollingButtonScrollView:self];
    }
}

- (void)scrollViewButtonPushed:(UIButton *)sender
{
    if (_centerPushedButtons) {
        [self moveButtonToViewCenter:sender animated:YES];
    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(rollingScrollViewButtonPushed:ssRollingButtonScrollView:)]) {
        [self.ssRollingButtonScrollViewDelegate rollingScrollViewButtonPushed:sender ssRollingButtonScrollView:self];
    }
}

#pragma mark - Label Tiling

- (CGFloat)placeNewButtonOnRight:(CGFloat)rightEdge
{
    _rightMostVisibleButtonIndex++;
    if (_rightMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
        _rightMostVisibleButtonIndex = 0;
    }
    
    UIButton *button = _rollingScrollViewButtons[_rightMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons addObject:button]; // add rightmost label at the end of the array
    
    CGRect frame = [button frame];
    frame.origin.x = rightEdge;
    frame.origin.y = ([_buttonContainerView bounds].size.height - frame.size.height) / 2.0f;
    [button setFrame:frame];
    return CGRectGetMaxX(frame);
}

- (CGFloat)placeNewButtonOnLeft:(CGFloat)leftEdge
{
    _leftMostVisibleButtonIndex--;
    if (_leftMostVisibleButtonIndex < 0) {
        _leftMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
    }
    
    UIButton *button = _rollingScrollViewButtons[_leftMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons insertObject:button atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [button frame];
    frame.origin.x = leftEdge - frame.size.width;
    frame.origin.y = ([_buttonContainerView bounds].size.height - frame.size.height) / 2.0f;
    [button setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (void)tileButtonsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleButtons count] == 0)
    {
        _rightMostVisibleButtonIndex = -1;
        _leftMostVisibleButtonIndex = 0;
        [self placeNewButtonOnRight:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    UIButton *lastButton = [_visibleButtons lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastButton frame]);
    
    while (rightEdge < maximumVisibleX)
    {
        rightEdge += self.spacingBetweenButtons;
        rightEdge = [self placeNewButtonOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    UIButton *firstButton = _visibleButtons[0];
    CGFloat leftEdge = CGRectGetMinX([firstButton frame]);
    while (leftEdge > minimumVisibleX)
    {
        leftEdge -= self.spacingBetweenButtons;
        leftEdge = [self placeNewButtonOnLeft:leftEdge];
    }
    
    // remove labels that have fallen off right edge
    lastButton = [_visibleButtons lastObject];
    while ([lastButton frame].origin.x > maximumVisibleX)
    {
        [lastButton removeFromSuperview];
        [_visibleButtons removeLastObject];
        lastButton = [_visibleButtons lastObject];
        
        _rightMostVisibleButtonIndex--;
        if (_rightMostVisibleButtonIndex < 0) {
            _rightMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
        }
    }
    
    // remove labels that have fallen off left edge
    firstButton = _visibleButtons[0];
    while (CGRectGetMaxX([firstButton frame]) < minimumVisibleX)
    {
        [firstButton removeFromSuperview];
        [_visibleButtons removeObjectAtIndex:0];
        firstButton = _visibleButtons[0];
        
        _leftMostVisibleButtonIndex++;
        if (_leftMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
            _leftMostVisibleButtonIndex = 0;
        }
    }
}

- (CGFloat)placeNewButtonOnBottom:(CGFloat)bottomEdge
{
    _bottomMostVisibleButtonIndex++;
    if (_bottomMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
        _bottomMostVisibleButtonIndex = 0;
    }
    
    UIButton *button = _rollingScrollViewButtons[_bottomMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons addObject:button]; // add bottommost label at the end of the array
    
    CGRect frame = [button frame];
    frame.origin.y = bottomEdge;
    frame.origin.x = ([_buttonContainerView bounds].size.width - frame.size.width) / 2.0f;
    [button setFrame:frame];
    return CGRectGetMaxY(frame);
}

- (CGFloat)placeNewButtonOnTop:(CGFloat)topEdge
{
    _topMostVisibleButtonIndex--;
    if (_topMostVisibleButtonIndex < 0) {
        _topMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
    }
    
    UIButton *button = _rollingScrollViewButtons[_topMostVisibleButtonIndex];
    [_buttonContainerView addSubview:button];
    [_visibleButtons insertObject:button atIndex:0]; // add leftmost label at the beginning of the array
    
    CGRect frame = [button frame];
    frame.origin.y = topEdge - frame.size.height;
    frame.origin.x = ([_buttonContainerView bounds].size.width - frame.size.width) / 2.0f;
    [button setFrame:frame];
    
    return CGRectGetMinY(frame);
}

- (void)tileButtonsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleButtons count] == 0)
    {
        _bottomMostVisibleButtonIndex = -1;
        _topMostVisibleButtonIndex = 0;
        [self placeNewButtonOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    UIButton *lastButton = [_visibleButtons lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastButton frame]);
    
    while (bottomEdge < maximumVisibleY)
    {
        bottomEdge += self.spacingBetweenButtons;
        bottomEdge = [self placeNewButtonOnBottom:bottomEdge];
    }
    
    // add labels that are missing on left side
    UIButton *firstButton = _visibleButtons[0];
    CGFloat topEdge = CGRectGetMinY([firstButton frame]);
    while (topEdge > minimumVisibleY)
    {
        topEdge -= self.spacingBetweenButtons;
        topEdge = [self placeNewButtonOnTop:topEdge];
    }
    
    // remove labels that have fallen off right edge
    lastButton = [_visibleButtons lastObject];
    while ([lastButton frame].origin.y > maximumVisibleY)
    {
        [lastButton removeFromSuperview];
        [_visibleButtons removeLastObject];
        lastButton = [_visibleButtons lastObject];
        
        _bottomMostVisibleButtonIndex--;
        if (_bottomMostVisibleButtonIndex < 0) {
            _bottomMostVisibleButtonIndex = [_rollingScrollViewButtons count] - 1;
        }
    }
    
    // remove labels that have fallen off left edge
    firstButton = _visibleButtons[0];
    while (CGRectGetMaxY([firstButton frame]) < minimumVisibleY)
    {
        [firstButton removeFromSuperview];
        [_visibleButtons removeObjectAtIndex:0];
        firstButton = _visibleButtons[0];
        
        _topMostVisibleButtonIndex++;
        if (_topMostVisibleButtonIndex == [_rollingScrollViewButtons count]) {
            _topMostVisibleButtonIndex = 0;
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.stopOnCenter) {
        
        if (_layoutStyle == SShorizontalLayout) {
            
            CGPoint currentOffset = self.contentOffset;
            NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval timeChange = currentTime - _lastTimeCapture;
            CGFloat distanceChange = currentOffset.x - _lastOffset.x;
            _scrollVelocity = distanceChange / timeChange;
            
            if (scrollView.decelerating) {
                if (fabsf(_scrollVelocity) < 150) {
                    [self moveButtonToViewCenter:_currentCenterButton animated:YES];
                }
            }
            _lastOffset = currentOffset;
            _lastTimeCapture = currentTime;
            
        } else {
            
            CGPoint currentOffset = self.contentOffset;
            NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
            NSTimeInterval timeChange = currentTime - _lastTimeCapture;
            CGFloat distanceChange = currentOffset.y - _lastOffset.y;
            _scrollVelocity = distanceChange / timeChange;
            
            if (scrollView.decelerating) {
                if (fabsf(_scrollVelocity) < 75) {
                    [self moveButtonToViewCenter:_currentCenterButton animated:YES];
                }
            }
            _lastOffset = currentOffset;
            _lastTimeCapture = currentTime;
        }
    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.stopOnCenter) {
        if (!decelerate) {
            [self moveButtonToViewCenter:_currentCenterButton animated:YES];
            [self scrollViewButtonIsInCenter:[self getCenterButton]];
        }
    }
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewButtonIsInCenter:[self getCenterButton]];
    
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if ([self.ssRollingButtonScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.ssRollingButtonScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end