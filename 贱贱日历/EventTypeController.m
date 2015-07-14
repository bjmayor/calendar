//
//  EventTypeController.m
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "EventTypeController.h"

@interface EventTypeController ()
{
    NSUserDefaults *defaults;
    NSMutableArray *cells;
    int eventType;
}
@end

@implementation EventTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"默认事件类型";
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    eventType  = (int)[defaults integerForKey:@"eventType"];
}

//此方法willDisplay是调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.tintColor = [UIColor blueColor];
    if (_isNewType) {
        if(_order == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else{
        if(eventType == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.tag = indexPath.row;
        [cells addObject:cell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (_isNewType) {
        [_passValueDelegate setTypeValue:row];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        int row = (int)indexPath.row;
        if(eventType != row){
            eventType = row;
        }
        [self.tableView reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [defaults setInteger:eventType forKey:@"eventType"];
}

@end
