//
//  RestTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-2.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "RestTableViewController.h"

@interface RestTableViewController ()
{
    NSMutableArray *cells;
    NSUserDefaults *defaults;
    NSMutableArray *rest;
}
@end

@implementation RestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"休息日";
    cells = [NSMutableArray array];
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.tintColor = [UIColor blueColor];
    rest = [[defaults arrayForKey:@"rest"] mutableCopy];
    int isAccessoryType = [[rest objectAtIndex:indexPath.row] intValue];
    if(isAccessoryType != 0){
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
    int tag = (int)cell.tag;
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [rest replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:tag+1]];
    }else {
        [rest replaceObjectAtIndex:tag withObject:[NSNumber numberWithInt:0]];
    }
    [defaults setObject:rest forKey:@"rest"];
    [defaults synchronize];
}

@end
