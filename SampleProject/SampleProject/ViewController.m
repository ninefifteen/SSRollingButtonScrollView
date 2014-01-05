//
//  ViewController.m
//  SampleProject
//
//  Created by Shawn Seals on 1/3/14.
//  Copyright (c) 2014 Shawn Seals. All rights reserved.
//

#import "ViewController.h"
#import "SSRollingButtonScrollView.h"

@interface ViewController () <SSRollingButtonScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    NSArray *phoneticAlphabet = [NSArray arrayWithObjects:@"Alpha", @"Bravo", @"Charlie", @"Delta", @"Echo", @"Foxtrot", @"Golf", @"Hotel", @"India", @"Juliet", @"Kilo", @"Lima", @"Mike", @"November", @"Oscar", @"Papa", @"Quebec", @"Romeo", @"Sierra", @"Tango", @"Uniform", @"Victor", @"Whiskey", @"Xray", @"Yankee", @"Zulu", nil];
    
    NSArray *alphabet = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    NSArray *digits = [NSArray arrayWithObjects:@"8", @"9", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", nil];
    
    NSArray *digitSmallSet = [NSArray arrayWithObjects:@"0", @"1", @"2", @"3", nil];
    
    NSArray *digitNames = [NSArray arrayWithObjects:@"Eight", @"Nine", @"Zero", @"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", nil];
    
    self.digitSelector01.fixedButtonWidth = 60.0f;
    self.digitSelector01.notCenterButtonTextColor = [UIColor lightGrayColor];
    self.digitSelector01.notCenterButtonBackgroundColor = [UIColor darkGrayColor];
    self.digitSelector01.centerButtonBackgroundColor = [UIColor darkGrayColor];
    [self.digitSelector01 createButtonArrayWithButtonTitles:digits andLayoutStyle:SShorizontalLayout];
    
    self.digitSelector02.fixedButtonWidth = 58.0f;
    self.digitSelector02.spacingBetweenButtons = 2.0f;
    self.digitSelector02.notCenterButtonTextColor = [UIColor lightGrayColor];
    self.digitSelector02.notCenterButtonBackgroundColor = [UIColor darkGrayColor];
    self.digitSelector02.centerButtonBackgroundColor = [UIColor darkGrayColor];
    [self.digitSelector02 createButtonArrayWithButtonTitles:digits andLayoutStyle:SShorizontalLayout];
    
    self.digitSelector03.fixedButtonWidth = 58.0f;
    self.digitSelector03.spacingBetweenButtons = 2.0f;
    self.digitSelector03.notCenterButtonTextColor = [UIColor lightGrayColor];
    self.digitSelector03.notCenterButtonBackgroundColor = [UIColor darkGrayColor];
    self.digitSelector03.centerButtonBackgroundColor = [UIColor blackColor];
    self.digitSelector03.stopOnCenter = NO;
    [self.digitSelector03 createButtonArrayWithButtonTitles:digits andLayoutStyle:SShorizontalLayout];
    
    self.digitSelector04.fixedButtonWidth = 60.0f;
    self.digitSelector04.notCenterButtonTextColor = [UIColor lightGrayColor];
    self.digitSelector04.playSound = NO;
    [self.digitSelector04 createButtonArrayWithButtonTitles:digits andLayoutStyle:SShorizontalLayout];
    
    self.letterSelector01.fixedButtonWidth = 60.0f;
    self.letterSelector01.buttonNotCenterFont = [UIFont systemFontOfSize:30];
    self.letterSelector01.buttonCenterFont = [UIFont boldSystemFontOfSize:50];
    self.letterSelector01.notCenterButtonTextColor = [UIColor grayColor];
    self.letterSelector01.centerButtonTextColor = [UIColor blackColor];
    [self.letterSelector01 createButtonArrayWithButtonTitles:alphabet andLayoutStyle:SShorizontalLayout];
    
    self.phoneticSelector01.spacingBetweenButtons = 10.0f;
    self.phoneticSelector01.notCenterButtonTextColor = [UIColor grayColor];
    self.phoneticSelector01.centerButtonTextColor = [UIColor blackColor];
    [self.phoneticSelector01 createButtonArrayWithButtonTitles:phoneticAlphabet andLayoutStyle:SShorizontalLayout];
    
    self.numberSelector01.fixedButtonWidth = 120.0f;
    self.numberSelector01.fixedButtonHeight = 50.0f;
    self.numberSelector01.notCenterButtonTextColor = [UIColor grayColor];
    self.numberSelector01.centerButtonTextColor = [UIColor blackColor];
    self.numberSelector01.centerButtonBackgroundImage = [UIImage imageNamed:@"Star"];
    [self.numberSelector01 createButtonArrayWithButtonTitles:digitNames andLayoutStyle:SSverticalLayout];
    
    self.repeatingDigitSet.centerButtonTextColor = [UIColor blackColor];
    [self.repeatingDigitSet createButtonArrayWithButtonTitles:digitSmallSet andLayoutStyle:SSverticalLayout];
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
