//
//  SSViewController.h
//  RollingScrollView
//
//  Created by Shawn Seals on 12/27/13.
//  Copyright (c) 2013 Shawn Seals. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSRollingButtonScrollView;

@interface SSViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *scrollViewContainer;
@property (weak, nonatomic) IBOutlet SSRollingButtonScrollView *rollinButtonScrollView;

@end
