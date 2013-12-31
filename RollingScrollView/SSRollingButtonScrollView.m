//
//  SSRollingButtonScrollView.m
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//

#import "SSRollingButtonScrollView.h"

@implementation SSRollingButtonScrollView
{
    NSMutableArray *_rollingScrollViewButtonTitles;
    NSMutableArray *_rollingScrollViewButtons;
    NSMutableArray *_visibleButtons;
    UIView *_buttonContainerView;
    
    NSInteger _rightMostVisibleButtonIndex;
    NSInteger _leftMostVisibleButtonIndex;
    
    NSInteger _topMostVisibleButtonIndex;
    NSInteger _bottomMostVisibleButtonIndex;
    
    SScontentLayoutStyle _layoutStyle;
    CGFloat _fixedButtonSpacing;
    CGFloat _buttonPadding;
    UIColor *_notSelectedButtonTitleColor;
    UIColor *_selectedButtonTitleColor;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        
        self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
        _rollingScrollViewButtonTitles = [NSMutableArray array];
        _rollingScrollViewButtons = [NSMutableArray array];
        _visibleButtons = [NSMutableArray array];
        _buttonContainerView = [[UIView alloc] init];
        
        _fixedButtonSpacing = -1.0f;
        _buttonPadding = 0.0f;
        self.buttonNotSelectedFont = [UIFont systemFontOfSize:15];
        self.buttonSelectedFont = [UIFont boldSystemFontOfSize:17];
        _notSelectedButtonTitleColor = [UIColor grayColor];
        _selectedButtonTitleColor = [UIColor blueColor];
        
        [self setShowsHorizontalScrollIndicator:NO];
        [self setShowsVerticalScrollIndicator:NO];
    }
    return self;
}

- (void)setButtonTitles:(NSArray *)titles
{
    _rollingScrollViewButtonTitles = [NSMutableArray arrayWithArray:titles];
}

- (void)setFixedButtonSpacing:(CGFloat)spacing
{
    _fixedButtonSpacing = spacing;
}

- (void)setLayoutStyle:(SScontentLayoutStyle)style
{
    _layoutStyle = style;
    
    if (_layoutStyle == SShorizontalLayout) {
        self.contentSize = CGSizeMake(5000, self.frame.size.height);
    } else {
        self.contentSize = CGSizeMake(self.frame.size.width, 5000);
    }
    
    _buttonContainerView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    [self addSubview:_buttonContainerView];
}

- (void)createButtonArray
{
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    _rollingScrollViewButtons = [NSMutableArray array];
    
    if (_layoutStyle == SShorizontalLayout) {
        
        for (NSString *buttonTitle in _rollingScrollViewButtonTitles) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            button.titleLabel.font = self.buttonNotSelectedFont;
            [button setTitleColor:_notSelectedButtonTitleColor forState:UIControlStateNormal];
            
            if (_fixedButtonSpacing < 0) {
                CGSize fittedButtonSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.buttonSelectedFont}];
                button.frame = CGRectMake(x, y, fittedButtonSize.width + (_buttonPadding * 2), self.bounds.size.height);
                x += (fittedButtonSize.width + (_buttonPadding * 2));
            } else {
                button.frame = CGRectMake(x, y, _fixedButtonSpacing + (_buttonPadding * 2), self.bounds.size.height);
                x += (_fixedButtonSpacing + (_buttonPadding * 2));
            }
            
            [button addTarget:self action:@selector(scrollViewButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            [_rollingScrollViewButtons addObject:button];
        }
        
    } else {
        
        for (NSString *buttonTitle in _rollingScrollViewButtonTitles) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            
            [button setTitle:buttonTitle forState:UIControlStateNormal];
            button.titleLabel.font = self.buttonNotSelectedFont;
            [button setTitleColor:_notSelectedButtonTitleColor forState:UIControlStateNormal];
            
            if (_fixedButtonSpacing < 0) {
                CGSize fittedButtonSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.buttonSelectedFont}];
                button.frame = CGRectMake(x, y, self.bounds.size.width, fittedButtonSize.height + (_buttonPadding * 2));
                y += (fittedButtonSize.height + (_buttonPadding * 2));
            } else {
                button.frame = CGRectMake(x, y, self.bounds.size.width, _fixedButtonSpacing + (_buttonPadding * 2));
                y += (_fixedButtonSpacing + (_buttonPadding *2));
            }
            
            [button addTarget:self action:@selector(scrollViewButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
            
            [_rollingScrollViewButtons addObject:button];
        }
    }
    
    [self addSubview:_buttonContainerView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self recenterIfNecessary];

    // tile content in visible bounds
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

- (void)scrollViewButtonPushed:(UIButton *)sender
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

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
    frame.origin.y = [_buttonContainerView bounds].size.height - frame.size.height;
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
    frame.origin.y = [_buttonContainerView bounds].size.height - frame.size.height;
    [button setFrame:frame];
    
    return CGRectGetMinX(frame);
}

- (void)tileButtonsFromMinX:(CGFloat)minimumVisibleX toMaxX:(CGFloat)maximumVisibleX
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleButtons count] == 0)
    {
        _rightMostVisibleButtonIndex = 0;
        _leftMostVisibleButtonIndex = 0;
        [self placeNewButtonOnRight:minimumVisibleX];
    }
    
    // add labels that are missing on right side
    UIButton *lastButton = [_visibleButtons lastObject];
    CGFloat rightEdge = CGRectGetMaxX([lastButton frame]);
    
    while (rightEdge < maximumVisibleX)
    {
        rightEdge = [self placeNewButtonOnRight:rightEdge];
    }
    
    // add labels that are missing on left side
    UIButton *firstButton = _visibleButtons[0];
    CGFloat leftEdge = CGRectGetMinX([firstButton frame]);
    while (leftEdge > minimumVisibleX)
    {
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
    frame.origin.x = [_buttonContainerView bounds].size.width - frame.size.width;
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
    frame.origin.x = [_buttonContainerView bounds].size.width - frame.size.width;
    [button setFrame:frame];
    
    return CGRectGetMinY(frame);
}

- (void)tileButtonsFromMinY:(CGFloat)minimumVisibleY toMaxY:(CGFloat)maximumVisibleY
{
    // the upcoming tiling logic depends on there already being at least one label in the visibleLabels array, so
    // to kick off the tiling we need to make sure there's at least one label
    if ([_visibleButtons count] == 0)
    {
        _bottomMostVisibleButtonIndex = 0;
        _topMostVisibleButtonIndex = 0;
        [self placeNewButtonOnBottom:minimumVisibleY];
    }
    
    // add labels that are missing on right side
    UIButton *lastButton = [_visibleButtons lastObject];
    CGFloat bottomEdge = CGRectGetMaxY([lastButton frame]);
    
    while (bottomEdge < maximumVisibleY)
    {
        bottomEdge = [self placeNewButtonOnBottom:bottomEdge];
    }
    
    // add labels that are missing on left side
    UIButton *firstButton = _visibleButtons[0];
    CGFloat topEdge = CGRectGetMinY([firstButton frame]);
    while (topEdge > minimumVisibleY)
    {
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

@end
