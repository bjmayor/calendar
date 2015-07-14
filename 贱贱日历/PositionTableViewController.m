//
//  PositionTableViewController.m
//  贱贱日历
//
//  Created by BinHan on 14/12/15.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "PositionTableViewController.h"

@interface PositionTableViewController ()
{
    NSUserDefaults *defaults;
    NSMutableArray *cells;
    int position;
}
@end

@implementation PositionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"日历位置";
    cells = [NSMutableArray array];
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    position  = (int)[defaults integerForKey:@"position"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.tintColor = [UIColor blueColor];
    int row = (int)indexPath.row;
    if(position == row){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.tag = indexPath.row;
    [cells addObject:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    position = (int)indexPath.row;
    [self.tableView reloadData];
    [defaults setInteger:position forKey:@"position"];
    [defaults synchronize];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
