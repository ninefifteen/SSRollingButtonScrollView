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
	// Do any additional setup after loading the view, typically from a nib.
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
