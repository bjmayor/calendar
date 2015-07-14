//
//  HolidayShowTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-17.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "HolidayShowTableViewController.h"
#import "BHUtils.h"

@interface HolidayShowTableViewController ()
{
    NSMutableArray *showHoliday;
    NSMutableArray *hiddenHoliday;
    NSMutableArray *array;
    NSUserDefaults *defaults;
    NSArray * titleName;
}
@end

@implementation HolidayShowTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"节日显示";
    self.editing = YES;
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    showHoliday = [[defaults arrayForKey:@"showHoliday"] mutableCopy];
    hiddenHoliday = [[defaults arrayForKey:@"hiddenHoliday"] mutableCopy];
    array  = [@[showHoliday, hiddenHoliday] mutableCopy];
    titleName = @[@"阴历节日",@"阳历节日",@"节气"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *arr = [array objectAtIndex:section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UILabel *label = cell.textLabel;
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [BHUtils hexStringToColor:C808080];
    int row = (int)indexPath.row;
    int tag = 1;
    if (indexPath.section == 0) {
        tag = [[showHoliday objectAtIndex:row] intValue];
    } else if(indexPath.section == 1) {
        tag = [[hiddenHoliday objectAtIndex:row] intValue];
    }
    label.text =titleName[tag-1];
    cell.tag = tag;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *string;
    switch (section) {
        case 0:
        string = @"显示";
        break;
        case 1:
        string = @"隐藏";
        break;
    }
    return string;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    NSString *string;
    switch (section) {
        case 0:
        string = @"如当天出现多个节日（节气）的情况，则会按照顺序优先显示最上层的节日（节气）。";
        break;
        case 1:
        string = @"";
        break;
    }
    return string;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  UITableViewCellEditingStyleDelete;
    } else {
        return  UITableViewCellEditingStyleInsert;
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return  YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    int row = (int)indexPath.row;
    NSObject *value;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        value =  [showHoliday objectAtIndex:row];
        [showHoliday removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [hiddenHoliday insertObject:value atIndex:0];
        [self.tableView reloadInputViews];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        value =  [hiddenHoliday objectAtIndex:row];
        [hiddenHoliday removeObjectAtIndex:row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [showHoliday insertObject:value atIndex:0];
        [self.tableView reloadInputViews];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [defaults setObject:showHoliday forKey:@"showHoliday"];
    [defaults setObject:hiddenHoliday forKey:@"hiddenHoliday"];
    [defaults synchronize];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath{
    int fromSection = (int)fromIndexPath.section;
    int fromRow = (int)fromIndexPath.row;
    int toSection =(int)toIndexPath.section;
    int toRow = (int)toIndexPath.row;
    if (fromSection == toSection &&toSection==0) {
        //第一组 显示
        [showHoliday exchangeObjectAtIndex:fromRow withObjectAtIndex:toRow];
    }else if (fromSection == toSection &&toSection==1) {
        //第二组 隐藏
        [hiddenHoliday exchangeObjectAtIndex:fromRow withObjectAtIndex:toRow];
    }else if (fromSection != toSection) {
        NSObject *value;
        if (fromSection==0) {
            value =  [showHoliday objectAtIndex:fromRow];
            [showHoliday removeObjectAtIndex:fromRow];
            [hiddenHoliday insertObject:value atIndex:toRow];
        } else {
            value =  [hiddenHoliday objectAtIndex:fromRow];
            [hiddenHoliday removeObjectAtIndex:fromRow];
            [showHoliday insertObject:value atIndex:toRow];
        }
    }
    [defaults setObject:showHoliday forKey:@"showHoliday"];
    [defaults setObject:hiddenHoliday forKey:@"hiddenHoliday"];
    [defaults synchronize];
    
    [self.tableView reloadData];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"隐藏";
}

//section顶部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0.0;
    switch (section) {
        case 0:
        height = 35.0f;
        break;
        case 1:
        height = 40.0f;
        break;
    }
    return height;
}

////section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 48.0f;
}

@end
