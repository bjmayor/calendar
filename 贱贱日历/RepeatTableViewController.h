//
//  RepeatTableViewController.h
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "BaseViewController.h"
#import "DefinitionClass.h"

@interface RepeatTableViewController : UITableViewController

@property(nonatomic, assign) int order;

@property(nonatomic, weak)id<PassRepeatValueDelegate> passValueDelegate;

@end
