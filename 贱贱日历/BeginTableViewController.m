//
//  BeginTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-2.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "BeginTableViewController.h"

@interface BeginTableViewController ()
{
    NSUserDefaults *defaults;
    NSMutableArray *cells;
    int begin;
}
@end

@implementation BeginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"星期开始于";
    cells = [NSMutableArray array];
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    begin  = (int)[defaults integerForKey:@"begin"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.tintColor = [UIColor blueColor];
    int row = (int)indexPath.row;
    if(begin == row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.tag = indexPath.row;
    [cells addObject:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    begin = (int)indexPath.row;
    [self.tableView reloadData];
    [defaults setInteger:begin forKey:@"begin"];
    [defaults synchronize];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
