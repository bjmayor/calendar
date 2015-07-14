//
//  RepeatTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "RepeatTableViewController.h"

@interface RepeatTableViewController ()

@end

@implementation RepeatTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重复";
}

//此方法willDisplay是调用
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.tintColor = [UIColor blueColor];
    if(_order == indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    [_passValueDelegate setRepeatValue:row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
