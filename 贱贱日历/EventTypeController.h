//
//  EventTypeController.h
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//
//
//   事件类型
//

#import "BaseViewController.h"
#import "DefinitionClass.h"


@interface EventTypeController : UITableViewController

@property(nonatomic, assign) int order;
@property(nonatomic, weak)id<PassTypeValueDelegate> passValueDelegate;
@property(nonatomic, assign) BOOL isNewType;

@end
