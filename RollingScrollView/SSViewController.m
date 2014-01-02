//
//  SSViewController.m
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//

#import "SSViewController.h"
#import "SSRollingButtonScrollView.h"

@interface SSViewController ()
{
    NSArray *_bottomButtonTitles;
}

@end

@implementation SSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //_bottomButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten", @"Eleven", @"Twelve", @"Thirteen", @"Fourteen", nil];
    _bottomButtonTitles = [NSArray arrayWithObjects:@"*0*", @"*1*", @"*2*", @"*3*", @"*4*", @"*5*", @"*7*", @"*8*", @"*9*", nil];
    //_bottomButtonTitles = [NSArray arrayWithObjects:@"X", @"X", @"X", @"X", @"X", @"X", @"X", @"X", @"X", nil];
    //_bottomButtonTitles = [NSArray arrayWithObjects:@"One", @"Two", nil];
    
    self.bottomRollingButtonScrollView.layoutStyle = SShorizontalLayout;
    //self.bottomRollingButtonScrollView.fixedButtonSpacing = 50.0f;
    [self.bottomRollingButtonScrollView setButtonTitles:_bottomButtonTitles];
    self.bottomRollingButtonScrollView.buttonCenterFont = [UIFont boldSystemFontOfSize:24];
    [self.bottomRollingButtonScrollView createButtonArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
