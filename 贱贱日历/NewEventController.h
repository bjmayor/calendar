//
//  NewEventController.h
//  贱贱日历
//
//  Created by Bin on 14-9-28.
//  Copyright (c) 2014年 Bin. All rights reserved.
//
//
//   新建事件
//

#import "BaseViewController.h"

@protocol RefreshDataDelegate <NSObject>

@required

- (void)refreshData:(Event*)event;

@end

@interface NewEventController : UITableViewController

@property (weak, nonatomic) id <RefreshDataDelegate> deleget;

@property (weak, nonatomic) IBOutlet UITextField *eventTitle;

@property (weak, nonatomic) IBOutlet UIDatePicker *startPicker;

@property (weak, nonatomic) IBOutlet UIDatePicker *endPicker;
@end
