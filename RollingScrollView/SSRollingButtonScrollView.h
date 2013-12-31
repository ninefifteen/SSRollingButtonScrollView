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

@interface SSRollingButtonScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIFont *buttonNotSelectedFont;
@property (nonatomic, strong) UIFont *buttonSelectedFont;

- (void)createButtonArray;
- (void)setButtonTitles:(NSArray *)titles;
- (void)setFixedButtonSpacing:(CGFloat)spacing;
- (void)setLayoutStyle:(SScontentLayoutStyle)style;

@end
