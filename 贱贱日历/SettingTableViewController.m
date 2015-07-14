//
//  SettingTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "SettingTableViewController.h"
#import "MyCircleView.h"
#import "DefinitionClass.h"
#import "EventTypeController.h"

@interface SettingTableViewController ()
{
    NSUserDefaults *defaults;
    NSArray *_holidayName;
    NSArray *_rest;
    NSArray *_colorArr;
    NSArray *_eventNameArr;
}
@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    self.title = @"设置";
    _holidayName = @[@"阴历节日",@"阳历节日",@"节气"];
    _rest = @[@"周一", @"周二" ,@"周三", @"周四", @"周五", @"周六", @"周日"];
    _colorArr = ALL_COLOR;
    _eventNameArr = ALL_TYPE;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    UILabel *label = cell.detailTextLabel;
    //显示位置
    if(0 == indexPath.section && 0 == indexPath.row) {
        int position = (int)[defaults integerForKey:@"position"] ;
        if (position == 0) {
            label.text =@"居中";
        }else{
             label.text =@"居右";
        };
    }
    
    //节日优先级别
    if(0 == indexPath.section && 1 == indexPath.row) {
        NSString *showStr= @"";
        NSArray *showHoliday = [defaults arrayForKey:@"showHoliday"];
        for (NSNumber *obj in showHoliday) {
            int index = [obj intValue]-1;
            if (index>=0) {
                showStr = [showStr stringByAppendingString:[_holidayName objectAtIndex:index]];
                showStr = [showStr stringByAppendingString:@" "];
            }
        }
        if ([BHUtils isBlankString:showStr]) {
            showStr = @"全部隐藏";
        }
        label.text = showStr;
    }
    //星期开始于
    if(0 == indexPath.section && 2 == indexPath.row) {
        int begin = (int)[defaults integerForKey:@"begin"] ;
        if (begin == 0) {
            label.text =@"周日";
        }else{
            label.text = @"周一";
        };
    }
    //休息日
    if(0 == indexPath.section && 3 == indexPath.row) {
        NSArray *rest = [defaults arrayForKey:@"rest"];
        BOOL isAll = YES;
        NSString *restStr= @"";
        int count = (int)rest.count;
        for (int i = 0; i< count; i++) {
            int value = [[rest objectAtIndex:i] intValue];
            if(value !=0) {
                restStr = [restStr stringByAppendingString:[_rest objectAtIndex:value-1]];
                restStr = [restStr stringByAppendingString:@" "];
            } else
                isAll = NO;
        }
        if (isAll)
            label.text = @"每天";
        else
            label.text = restStr;
    }
    
    //是否显示法定节假日
    if(0 == indexPath.section && 4 == indexPath.row) {
        UISwitch *switchButton = (UISwitch *)[cell.contentView viewWithTag:101];
         [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        bool showLegal = [defaults boolForKey:@"showLegal"] ;
        if (showLegal) {
            switchButton.on = true;
        }else{
            switchButton.on = false;
        };
    }
    //事件类型
    if(1 == indexPath.section && 0 == indexPath.row) {
        int eventType =  (int)[defaults integerForKey:@"eventType"];
        MyCircleView * circleView = (MyCircleView *)[cell.contentView viewWithTag:100];
        circleView.backgroundColor = [BHUtils hexStringToColor:_colorArr[eventType]];
        label = (UILabel *)[cell viewWithTag:101];
        label.text = _eventNameArr[eventType];
    }
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    NSLog(@"isButtonOn = %d",isButtonOn);
    [defaults setBool:isButtonOn forKey:@"showLegal"];
    [defaults synchronize];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//section顶部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0f;
}

////section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}


@end
