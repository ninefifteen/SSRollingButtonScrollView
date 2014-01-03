//
//  SSViewController.m
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//

#import "SSViewController.h"
#import "SSRollingButtonScrollView.h"

@interface SSViewController () <SSRollingButtonScrollViewDelegate, UIScrollViewDelegate>
{
    NSArray *_bottomButtonTitles;
    NSArray *_leftButtonTitles;
}

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //_bottomButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"Eleven", @"Twelve", @"Thirteen", @"Fourteen", nil];
    _bottomButtonTitles = [NSArray arrayWithObjects:@"*0*", @"*1*", @"*2*", @"*3*", @"*4*", @"*5*", @"*7*", @"*8*", @"*9*", nil];
    //_bottomButtonTitles = [NSArray arrayWithObjects:@"X", @"X", @"X", @"X", @"X", @"X", @"X", @"X", @"X", nil];
    //_bottomButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", nil];
    
    self.bottomRollingButtonScrollView.layoutStyle = SShorizontalLayout;
    //self.bottomRollingButtonScrollView.fixedButtonSpacing = 50.0f;
    [self.bottomRollingButtonScrollView setButtonTitles:_bottomButtonTitles];
    self.bottomRollingButtonScrollView.buttonCenterFont = [UIFont boldSystemFontOfSize:24];
    [self.bottomRollingButtonScrollView createButtonArray];
    self.bottomRollingButtonScrollView.ssRollingButtonScrollViewDelegate = self;

    
    _leftButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"Eleven", @"Twelve", @"Thirteen", @"Fourteen", nil];
    
    self.leftRollingButtonScrollView.layoutStyle = SSverticalLayout;
    [self.leftRollingButtonScrollView setButtonTitles:_leftButtonTitles];
    self.leftRollingButtonScrollView.fixedButtonSpacing = 30.0f;
    self.leftRollingButtonScrollView.buttonCenterFont = [UIFont boldSystemFontOfSize:20];
    [self.leftRollingButtonScrollView createButtonArray];
    self.leftRollingButtonScrollView.ssRollingButtonScrollViewDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSRollingButtonScrollViewDelegate

- (void)rollingScrollViewButtonPushed:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView
{
    NSString *rollingButtonScrollViewName = [[NSString alloc] init];
    if (rollingButtonScrollView == self.bottomRollingButtonScrollView) {
        rollingButtonScrollViewName = @"bottomRollingButtonScrollView";
    } else if (rollingButtonScrollView == self.leftRollingButtonScrollView) {
        rollingButtonScrollViewName = @"leftRollingButtonScrollView";
    } else {
        rollingButtonScrollViewName = @"Oops!";
    }
    
    NSLog(@"%@, %@", rollingButtonScrollViewName, button.titleLabel.text);
}

- (void)rollingScrollViewButtonIsInCenter:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView
{
    NSString *rollingButtonScrollViewName = [[NSString alloc] init];
    if (rollingButtonScrollView == self.bottomRollingButtonScrollView) {
        rollingButtonScrollViewName = @"bottomRollingButtonScrollView";
    } else if (rollingButtonScrollView == self.leftRollingButtonScrollView) {
        rollingButtonScrollViewName = @"leftRollingButtonScrollView";
    } else {
        rollingButtonScrollViewName = @"Oops!";
    }
    
    NSLog(@"%@, %@", rollingButtonScrollViewName, button.titleLabel.text);
}

#pragma mark - UIScrollViewDelegate

@end
