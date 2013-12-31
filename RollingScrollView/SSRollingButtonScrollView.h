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

// Mandatory. Must be set before calling "createButtonArray".
@property (nonatomic) SScontentLayoutStyle layoutStyle;

// Optional. If set by user, must be set before calling "createButtonArray".
@property (nonatomic, strong) UIFont *buttonNotSelectedFont;
@property (nonatomic, strong) UIFont *buttonSelectedFont;
@property (nonatomic) CGFloat fixedButtonSpacing; // Sets button origin points a fixed distance apart.
@property (nonatomic) CGFloat buttonPadding; // Pads button dimensions if fixedButtonSpacing is not used.
@property (nonatomic, strong) UIColor *notSelectedButtonTitleColor;
@property (nonatomic, strong) UIColor *selectedButtonTitleColor;

// The following method must be called before calling "createButtonArray".
- (void)setButtonTitles:(NSArray *)titles;

// Must be called last.
- (void)createButtonArray;



@end
