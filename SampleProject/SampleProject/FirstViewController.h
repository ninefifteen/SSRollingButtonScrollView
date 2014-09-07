//
//  FirstViewController.h
//  SampleProject
//
//  Created by Shawn Seals on 9/6/14.
//  Copyright (c) 2014 Shawn Seals. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSRollingButtonScrollView;

@interface FirstViewController : UIViewController

@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector03;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector04;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *numberSelector01;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *repeatingDigitSet;

@end
