//
//  FirstViewController.m
//  SampleProject
//
//  Created by Shawn Seals on 9/6/14.
//  Copyright (c) 2014 Shawn Seals. All rights reserved.
//

#import "FirstViewController.h"
#import "SSRollingButtonScrollView.h"

@interface FirstViewController () <SSRollingButtonScrollViewDelegate>

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *digits = [NSArray arrayWithObjects:@"8", @"9", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
    
    NSArray *digitSmallSet = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", nil];
    
    NSArray *digitNames = [NSArray arrayWithObjects:@"Eight", @"Nine", @"Zero", @"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", nil];
    
    self.digitSelector03.fixedButtonWidth = 58.0f;
    self.digitSelector03.spacingBetweenButtons = 2.0f;
    self.digitSelector03.notCenterButtonTextColor = [UIColor lightGrayColor];
    self.digitSelector03.notCenterButtonBackgroundColor = [UIColor darkGrayColor];
    self.digitSelector03.centerButtonBackgroundColor = [UIColor blackColor];
    self.digitSelector03.stopOnCenter = NO;
    [self.digitSelector03 createButtonArrayWithButtonTitles:digits andLayoutStyle:SShorizontalLayout];
    self.digitSelector03.ssRollingButtonScrollViewDelegate = self;
    
    self.digitSelector04.fixedButtonWidth = 60.0f;
    self.digitSelector04.notCenterButtonTextColor = [UIColor lightGrayColor];
    self.digitSelector04.playSound = NO;
    [self.digitSelector04 createButtonArrayWithButtonTitles:digits andLayoutStyle:SShorizontalLayout];
    self.digitSelector04.ssRollingButtonScrollViewDelegate = self;
    
    self.numberSelector01.fixedButtonWidth = 120.0f;
    self.numberSelector01.fixedButtonHeight = 50.0f;
    self.numberSelector01.notCenterButtonTextColor = [UIColor grayColor];
    self.numberSelector01.centerButtonTextColor = [UIColor blackColor];
    self.numberSelector01.centerButtonBackgroundImage = [UIImage imageNamed:@"Star"];
    [self.numberSelector01 createButtonArrayWithButtonTitles:digitNames andLayoutStyle:SSverticalLayout];
    self.numberSelector01.ssRollingButtonScrollViewDelegate = self;
    
    self.repeatingDigitSet.centerButtonTextColor = [UIColor blackColor];
    [self.repeatingDigitSet createButtonArrayWithButtonTitles:digitSmallSet andLayoutStyle:SSverticalLayout];
    self.repeatingDigitSet.ssRollingButtonScrollViewDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSRollingButtonScrollViewDelegate

- (void)rollingScrollViewButtonPushed:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView
{
    NSLog(@"%@", button.titleLabel.text);
}

- (void)rollingScrollViewButtonIsInCenter:(UIButton *)button ssRollingButtonScrollView:(SSRollingButtonScrollView *)rollingButtonScrollView
{
    NSLog(@"%@", button.titleLabel.text);
}

@end
