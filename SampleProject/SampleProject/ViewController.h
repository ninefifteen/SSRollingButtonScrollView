//
//  ViewController.h
//  SampleProject
//
//  Created by Shawn Seals on 1/3/14.
//  Copyright (c) 2014 Shawn Seals. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSRollingButtonScrollView;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector01;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector02;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector03;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector04;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *letterSelector01;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *phoneticSelector01;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *numberSelector01;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *repeatingDigitSet;

@end
