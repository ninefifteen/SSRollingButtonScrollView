//
//  SecondViewController.h
//  SampleProject
//
//  Created by Shawn Seals on 9/6/14.
//  Copyright (c) 2014 Shawn Seals. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSRollingButtonScrollView;

@interface SecondViewController : UIViewController

@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector01;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *digitSelector02;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *letterSelector01;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *phoneticSelector01;

@end
