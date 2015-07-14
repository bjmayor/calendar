//
//  AllEventTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-12.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "AllEventTableViewController.h"
#import "DefinitionClass.h"
#import "Event.h"
#import "BHUtils.h"
#import "NewEventController.h"

@interface AllEventTableViewController ()<RefreshDataDelegate>
{
    NSArray *_colorArr;
    NSUserDefaults *defaults;
    NSDateFormatter *dateFormatter;
    NSMutableArray *_array;
    NSMutableDictionary *_dictionary;
}
@end

@implementation AllEventTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所有事件";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    _colorArr = ALL_COLOR;
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    NSData *data  = [defaults objectForKey:@"events"];
    NSMutableArray *arr;
    if (data != nil) {
        arr = (NSMutableArray *) [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    if(arr == nil){
        arr = [NSMutableArray array];
    }
    NSArray *sortedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(Event *p1, Event *p2){
        return [p1.startTime compare:p2.startTime];
    }];
    _array = [NSMutableArray array];
    //实例化一个NSDateFormatter对象
    dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    _dictionary = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < sortedArray.count; i++) {
        Event *event = (Event *)[sortedArray objectAtIndex:i];
        NSString *date = [dateFormatter stringFromDate:event.startTime];
        NSMutableArray *arr = [_dictionary objectForKey:date];
        if (arr == nil) {
            arr = [NSMutableArray array];
            [_array addObject:date];
            [_dictionary setObject:arr forKey:date];
        }
        [arr addObject:event];
    }
    if (_array.count == 0) {
        UILabel *label = [[UILabel alloc] init];
        CGSize size = self.view.bounds.size;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无事件";
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = [BHUtils hexStringToColor:C808080];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        label.center = CGPointMake(size.width/2, size.height/2);
        label.tag = 10001;
       [self.view addSubview:label];
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    
    self.tableView contentInset
}

-(void)viewAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(BOOL)isSameDay:(NSDate*)date1 date2:(NSDate*)date2{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}


//一多少组
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _array.count;
}

//每一组的数据
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [(NSArray *)[_dictionary objectForKey:[_array objectAtIndex:section]] count];
}

//每一条的数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Event *event = (Event *)[(NSArray *)[_dictionary objectForKey:[_array objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    cell.textLabel.text = event.title;
    cell.textLabel.textColor = [BHUtils hexStringToColor:C808080];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *startTimeStr =[dateFormatter stringFromDate:event.startTime];
    NSDate *endTime = event.endTime;
    NSString *endTimeStr = @"";
    if (endTime !=nil) {
        endTimeStr = [endTimeStr stringByAppendingString:@"-"];
        endTimeStr = [endTimeStr stringByAppendingString:[dateFormatter stringFromDate:endTime]];
    }
    cell.detailTextLabel.text = [startTimeStr stringByAppendingString:endTimeStr];
    cell.detailTextLabel.textColor = [BHUtils hexStringToColor:CC0C0C0];
    cell.imageView.backgroundColor = [BHUtils hexStringToColor:_colorArr[event.type]];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0f];
    
    
    UIImage *icon = [UIImage imageNamed:@""];
    CGSize itemSize = CGSizeMake(2, 33);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [icon drawInRect:imageRect];
    
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGSize size = self.view.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, 50)];
    label.textAlignment = NSTextAlignmentLeft;
    label.adjustsFontSizeToFitWidth = YES;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [BHUtils hexStringToColor:C7F7F7F];
    label.backgroundColor = [BHUtils hexStringToColor:CF7F7F7];
    label.text = [@"    " stringByAppendingString:[_array objectAtIndex:section]];
    return label;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *arr =(NSMutableArray *)[_dictionary objectForKey:[_array objectAtIndex:indexPath.section]];
        Event *event = [arr objectAtIndex:indexPath.row];
        [arr removeObjectAtIndex:indexPath.row];
        // 取消某个特定的本地通知
        UIApplication *app = [UIApplication sharedApplication];
        //获取本地推送数组
        NSArray *localArr = [app scheduledLocalNotifications];
        //声明本地通知对象
        if (localArr) {
            for (UILocalNotification *noti in localArr) {
                NSDictionary *dict = noti.userInfo;
                if (dict) {
                    NSString *inKey = [dict objectForKey:@"key"];
                    if ([inKey isEqualToString:event.date]) {
                        if (noti){
                            [app cancelLocalNotification:noti];
                        }
                    }
                }
            }
        }
        // Delete the row from the data source.
        if (arr.count == 0) {
            [_array removeObjectAtIndex:indexPath.section];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableArray *allEvent = [NSMutableArray array];
    for (NSString *date in _array) {
        NSArray *arr = (NSArray *)[_dictionary objectForKey:date];
        for (Event *event in arr) {
            [allEvent addObject:event];
        }
    }
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:allEvent] forKey:@"events"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_array objectAtIndex:section];
}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    return @"";
//}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSString *identifer = segue.identifier;
    if ([identifer isEqualToString:@"newevent"]) {
        ((NewEventController *)[segue.destinationViewController viewControllers][0]).deleget = self;
    }
}

- (void)refreshData:(Event *)event{
    UILabel *label = (UILabel *)[self.view viewWithTag:10001];
    [label removeFromSuperview];
    NSString *date = [dateFormatter stringFromDate:event.startTime];
    NSMutableArray *arr = [_dictionary objectForKey:date];
    if (arr == nil) {
        arr = [NSMutableArray array];
        [_array addObject:date];
        [_dictionary setObject:arr forKey:date];
    }
    [arr addObject:event];
    [self.tableView reloadData];
}

@end
