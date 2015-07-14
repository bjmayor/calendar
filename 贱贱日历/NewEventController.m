//
//  NewEventController.m
//  贱贱日历
//
//  Created by Bin on 14-9-28.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "NewEventController.h"
#import "EventTypeController.h"
#import "RepeatTableViewController.h"
#import "DefinitionClass.h"
#import "MyCircleView.h"
#import "Event.h"

@interface NewEventController ()<PassTypeValueDelegate, PassRepeatValueDelegate>
{
    NSUserDefaults *defaults;
    int _typeOrder;
    int _repeatOrder;
    NSArray *_colorArr;
    NSArray *_eventNameArr;
    NSArray *_repeatArr;
    BOOL isShowStart;
    BOOL isShowEnd;
    NSDateFormatter *_dateFormatter;
    NSDate *_startTime;
    NSDate *_endTime;
}
@end

@implementation NewEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建事件";
    defaults       = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    _typeOrder     = (int)[defaults integerForKey:@"eventType"];
    _repeatOrder   = 0;
    _eventNameArr  = ALL_TYPE;
    _colorArr      = ALL_COLOR;
    _repeatArr     = @[@"永不", @"每天", @"每周", @"每月", @"每年"];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //超出范围的视图进行剪裁
    cell.contentView.clipsToBounds = YES;
    UILabel *label = cell.detailTextLabel;
    if(0 == indexPath.section && 1 == indexPath.row) {
        MyCircleView * circleView  = (MyCircleView *)[cell.contentView viewWithTag:100];
        circleView.backgroundColor = [BHUtils hexStringToColor:_colorArr[_typeOrder]];
        label                      = (UILabel *)[cell viewWithTag:101];
        label.text                 = _eventNameArr[_typeOrder];
    }
    if(1 == indexPath.section && 4 == indexPath.row) {
        label.text                 = _repeatArr[_repeatOrder];
    }
    if(1 == indexPath.section && 0 == indexPath.row) {
        _startTime                 = [_startPicker date];
        NSString *destDateString   = [_dateFormatter stringFromDate:_startTime];
        label.text                 = destDateString;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
    UILabel *label = cell.detailTextLabel;
    if (indexPath.section==1&&indexPath.row==0) {
        if(!isShowStart){
            isShowStart = YES;
            isShowEnd   = NO;
        }else {
            isShowStart = NO;
            _startTime  = [_startPicker date];
            label.text  = [_dateFormatter stringFromDate:_startTime];
        }
        [self.tableView reloadData];
    }else if(indexPath.section==1&&indexPath.row==2){
        if(!isShowEnd){
            isShowStart = NO;
            isShowEnd   = YES;
        }else {
            isShowEnd  = NO;
            _endTime   = [_endPicker date];
            label.text = [_dateFormatter stringFromDate:_endTime];
        }
        [self.tableView reloadData];
    } else if(indexPath.section==2&&indexPath.row==0){
        [self creatEvent];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section==1&&indexPath.row==1)) {
        if (!isShowStart) {
            return 0;
        }else {
            return 162;
        }
    }
    if(indexPath.section==1&&indexPath.row==3){
        if (!isShowEnd) {
            return 0;
        }else {
            return 162;
        }
    }
    return 44;
}

////section顶部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 0;
//}
//
////section底部间距

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 24;
}

-(void) setTypeValue:(NSInteger)param{
    _typeOrder = (int)param;
    [self.tableView reloadData];
}

-(void) setRepeatValue:(NSInteger)param{
    _repeatOrder = (int)param;
    [self.tableView reloadData];
}

//

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *identifer = segue.identifier;
    if ([identifer isEqualToString:@"itemtype"]) {
        ((EventTypeController *)segue.destinationViewController).order = _typeOrder;
        ((EventTypeController *)segue.destinationViewController).isNewType = YES;
        ((EventTypeController *)segue.destinationViewController).passValueDelegate = self;
    } else if( [identifer isEqualToString:@"repeat"]){
        ((RepeatTableViewController *)segue.destinationViewController).order = _repeatOrder;
        ((RepeatTableViewController *)segue.destinationViewController).passValueDelegate = self;
    }
    NSString *str = @"dasdas";
//    str boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(NSDictionary *)#> context:<#(NSStringDrawingContext *)#>
}

/***
 ***    创建新事件
 ***/
-(void)creatEvent{
    NSString *eventTitle = _eventTitle.text;
    if ([BHUtils isBlankString:eventTitle]) {
        [self showAlert:@"标题不能为空"];
        return;
    }
    if (nil != _endTime && [_endTime timeIntervalSinceDate:_startTime]<=0.0) {
        [self showAlert:@"结束时间不能早于开始时间"];
        return;
    }
    //保存
    Event *event               = [[Event alloc] init];
    event.title                = eventTitle;
    event.type                 = _typeOrder;
    event.startTime            = _startTime;
    event.endTime              = _endTime;
    event.order                = _repeatOrder;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd%20hh:mm:ss"];
    event.date                 = [formatter stringFromDate:[NSDate date]];
    NSData * data              = [defaults objectForKey:@"events"];
    NSMutableArray *arr;
    if (data != nil) {
        arr = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if(arr == nil){
        arr = [NSMutableArray array];
    }
    [arr addObject:event];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:arr] forKey:@"events"];
    
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = _startTime;
        // 设置重复间隔
        switch (_repeatOrder) {
            case 0:
                notification.repeatInterval = kCFCalendarUnitEra;
                break;
            case 1:
                notification.repeatInterval = kCFCalendarUnitDay;
                break;
            case 2:
                notification.repeatInterval = kCFCalendarUnitWeek;
                break;
            case 3:
                notification.repeatInterval = kCFCalendarUnitMonth;
                break;
            case 4:
                notification.repeatInterval = kCFCalendarUnitYear;
                break;
            default:
                break;
        }
        // 设置提醒的文字内容
        notification.alertBody = eventTitle;
        notification.alertAction = NSLocalizedString(_eventNameArr[_typeOrder], nil);
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        // 设置应用程序右上角的提醒个数
        //[UIApplication sharedApplication].applicationIconBadgeNumber +=1;
        notification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber +1;
        // 设定通知的userInfo，用来标识该通知
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:event.date forKey:@"key"];
        notification.userInfo = infoDic;
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.deleget refreshData:event];
        }];
    }
}

/***
 ***    提示框
 ***/
-(void)showAlert:(NSString *)message{
    UIAlertView *view  = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [view show];
}

@end
