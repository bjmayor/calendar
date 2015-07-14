//
//  ShowTypeTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-2.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "ShowTypeTableViewController.h"

@interface ShowTypeTableViewController ()
{
    NSMutableArray *cells;
    NSUserDefaults *defaults;
    NSMutableArray *showType;
}
@end

@implementation ShowTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"农历显示";
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    cells = [NSMutableArray array];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.tintColor = [UIColor blueColor];
    showType = [[defaults arrayForKey:@"showType"] mutableCopy];
    int isAccessoryType = [[showType objectAtIndex:indexPath.row] intValue];
    if(isAccessoryType == 1){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.tag = indexPath.row;
    [cells addObject:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(UITableViewCellAccessoryNone == cell.accessoryType){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [showType replaceObjectAtIndex:cell.tag withObject:[NSNumber numberWithInt:1]];
    }else {
        [showType replaceObjectAtIndex:cell.tag withObject:[NSNumber numberWithInt:0]];
    }
    [defaults setObject:showType forKey:@"showType"];
    [defaults synchronize];
}

@end
