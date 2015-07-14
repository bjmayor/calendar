//
//  BaseViewController.h
//  贱贱日历
//
//  Created by Bin on 14-9-26.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BHUtils.h"
#import "LKCalendarDefine.h"
#import "Event.h"

#define MARGE 2

@interface BaseViewController : UIViewController

@property (nonatomic, assign)CGSize size;
@property (nonatomic, assign)float marge;
@property (nonatomic, assign)float ratio;


@end
