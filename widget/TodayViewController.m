//
//  TodayViewController.m
//  widget
//
//  Created by Bin on 14-9-24.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "LKCalendarDefine.h"
#import "BHUtils.h"

@interface TodayViewController () <NCWidgetProviding,LKCalendarMonthDelegate,LKCalendarDayViewDelegate,LKCalendarViewDelegate>
{
    CGSize _size;
    float _width;
    LKCalendarView* _calendarView;
    LKCalendarDayView* _lastSelectedDayView;
    UILabel* _lb_show;
    UIView* _weekNameView;
    UIImageView *line;
    CGPoint _leftCenter;
    CGPoint _rightCenter;
    BOOL isScrooling;
    NSUserDefaults *defaults;
    int begin;
    int position;
    int positionXOff;
    bool showLegal;
}
@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [BHUtils initSetting];
    defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    _size=self.view.bounds.size;
    if (ipad) {
        _width = _size.width-168;
    } else {
        _width = _size.width - 48;
    }
    //显示周几
    _weekNameView = [[UIView alloc]initWithFrame:CGRectMake(positionXOff, 40, _width, 30)];
    [self.view addSubview:_weekNameView];
    line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, _size.width, 0.5f)];
    line.backgroundColor = [UIColor whiteColor];
    line.alpha = 0.8f;
    [self.view addSubview:line];
    
    //显示当前日期
    _lb_show = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    _lb_show.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_lb_show];
    [self creatCalendarView];
}

- (UIButton*) createButtonWithFrame:(CGRect) frame Center:(CGPoint)point Target:(id)target Selector:(SEL)selector Image:(NSString *)image ImagePressed:(NSString *)imagePressed
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button setCenter:point];
    UIImage *newImage = [UIImage imageNamed:image];
    [button setImage:newImage forState:UIControlStateNormal];
    UIImage *newPressedImage = [UIImage imageNamed: imagePressed];
    [button setImage:newPressedImage forState:UIControlStateHighlighted];
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    return button;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self widgetPerformUpdateWithCompletionHandler:^(NCUpdateResult result) {
        if(begin!=(int)[defaults integerForKey:@"begin"]||position!=(int)[defaults integerForKey:@"position"]||showLegal!= [defaults boolForKey:@"showLegal"]){
            [self creatCalendarView];
        }
    }];
}

-(void)creatCalendarView{
    begin = (int)[defaults integerForKey:@"begin"];
    position = (int)[defaults integerForKey:@"position"];
    showLegal = [defaults boolForKey:@"showLegal"];
    if (ipad) {
        //self.preferredContentSize = CGSizeMake(0, 326);
        positionXOff = 30;
    } else if(iphone6Plus) {
        //self.preferredContentSize = CGSizeMake(0, 326);
        positionXOff = 25;
    }else if(iphone6){
        //self.preferredContentSize = CGSizeMake(0, 327);
        positionXOff = 34;
    }else {
       // self.preferredContentSize = CGSizeMake(0, 305);
        positionXOff = 30;
    }

    
    [self createWeekName:begin];
    if(_calendarView!=NULL){
        [_calendarView removeFromSuperview];
        _calendarView = nil;
    }
    _weekNameView.frame = CGRectMake(positionXOff, 40, _width, 30);
    _calendarView = [[LKCalendarView alloc]initWithFrame:CGRectMake(0, 70, _size.width, SYCC_MonthHeight)];
    if (1==(int)[defaults integerForKey:@"position"]) {
        if (ipad) {
        } else if(iphone6Plus) {
            positionXOff += 20;
            _weekNameView.frame = CGRectMake(positionXOff, 30, _width, 30);
            line.frame = CGRectMake(52, 55, _size.width, 0.5f);
            _calendarView.frame = CGRectMake(15, 55, _size.width, SYCC_MonthHeight);
        }else if(iphone6){
            positionXOff += 14;
            _weekNameView.frame = CGRectMake(positionXOff, 30, _width, 30);
            line.frame = CGRectMake(48, 55, _size.width, 0.5f);
            _calendarView.frame = CGRectMake(13, 55, _size.width, SYCC_MonthHeight);
        }else {
             positionXOff += 12;
             _weekNameView.frame = CGRectMake(positionXOff, 30, _width, 30);
            line.frame = CGRectMake(48, 55, _size.width, 0.5f);
            _calendarView.frame = CGRectMake(12, 55, _size.width, SYCC_MonthHeight);
        }
    }

    _calendarView.currentDateComponents = getYearMonthDateComponents([NSDate date]);
    [self.view addSubview:_calendarView];
    _calendarView.delegate  = self;
    
    _calendarView.leftMonth.firstDayWeek = begin;
    _calendarView.centerMonth.firstDayWeek = begin;
    _calendarView.rightMonth.firstDayWeek = begin;
       [_calendarView startLoadingView];
    [self calendarViewDidChangedMonth:_calendarView];
    
    if(iphone6Plus) {
        _lb_show.center = CGPointMake((_rightCenter.x - _leftCenter.x)/2 + _leftCenter.x+positionXOff, _leftCenter.y+5);
    }else if(iphone6){
        _lb_show.center = CGPointMake((_rightCenter.x - _leftCenter.x)/2 + _leftCenter.x+positionXOff, _leftCenter.y+5);
    }else {
        _lb_show.center = CGPointMake((_rightCenter.x - _leftCenter.x)/2 + _leftCenter.x+positionXOff, _leftCenter.y+6);
    }
    //上一月
    [self createButtonWithFrame:CGRectMake(0, 0, 44, 44) Center:CGPointMake(_leftCenter.x+positionXOff, _leftCenter.y + 6) Target:self Selector:@selector(lastMonth:) Image:@"lastmon" ImagePressed:nil];
    //下一月
    [self createButtonWithFrame:CGRectMake(0, 0, 44, 44) Center:CGPointMake(_rightCenter.x+positionXOff, _rightCenter.y +6) Target:self Selector:@selector(nextMonth:) Image:@"nextmon" ImagePressed:nil];
    
    int row = _calendarView.centerMonth.getValidRow;
 //   int row = 5;
    self.preferredContentSize = CGSizeMake(0, SYCC_DayHeight*(row+2) + SYCC_DayOffsetHeight*(row+3)-25);
}

/*
 ***设置星期几开头 [self createWeekName:(arc4random()%7)];
 */
-(void)createWeekName:(int)tag
{
    for(UIView *view in [_weekNameView subviews])
    {
        [view removeFromSuperview];
    }
    NSMutableArray* array = [NSMutableArray arrayWithArray:@[@"日",@"一",@"二",@"三",@"四",@"五",@"六"]];
    NSMutableArray* showArray = [NSMutableArray array];
    int begin= tag;
    while (showArray.count<7) {
        [showArray addObject:[array objectAtIndex:begin%7]];
        begin ++;
    }
    while (_weekNameView.subviews.count) {
        [[_weekNameView.subviews objectAtIndex:0] removeFromSuperview];
    }
    int size =  _width/7;
    int i =0;
    for (NSString* title in showArray) {
        UILabel* lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size,25)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.center = CGPointMake(16 + size*i, 30/2);
        lb.backgroundColor = [UIColor clearColor];
        
        if(iphone6Plus) {
            lb.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        } else if(iphone6){
            lb.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        } else {
            lb.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:10];
        }
        lb.textColor = [UIColor whiteColor];
        NSMutableArray *rest = [[defaults arrayForKey:@"rest"] mutableCopy];
        for (int i = 0; i<rest.count; i++) {
            int value = (int)[[rest objectAtIndex:i] integerValue];
            NSString *str = [BHUtils getMonthString:value];
            [rest replaceObjectAtIndex:i withObject:str];
        }
        
        for (NSString *str in rest) {
            NSString *flag =str;
            if ([flag isEqualToString:@"七"]) {
                flag = @"日";
            }
            if ([title isEqualToString:flag]) {
                lb.alpha = 0.5f;
                break;
            }
        }
        lb.text = title;
        [_weekNameView addSubview:lb];
        if(i == 3){
            _leftCenter = lb.center;
        }
        if (i == 6) {
            _rightCenter = lb.center;
        }
        i++;
    }
}

-(void)calendarViewDidChangedMonth:(LKCalendarView *)sender
{
    int year = (int)sender.currentDateComponents.year;
    int month = (int)sender.currentDateComponents.month;
    NSString *monthStr = [BHUtils getMonthString:month];
    NSMutableAttributedString *str = nil;
    switch (month) {
        case 1:
        case 2:
        case 3:
            str = [self setMonthYear:year AndroidColor:@"#ff7c7c" AndMonth:monthStr];
            break;
        case 4:
        case 5:
        case 6:
            str =  [self setMonthYear:year AndroidColor:@"#b4e123" AndMonth:monthStr];
            break;
        case 7:
        case 8:
        case 9:
            str = [self setMonthYear:year AndroidColor:@"#ffbe32" AndMonth:monthStr];
            break;
        case 10:
        case 11:
        case 12:
            str = [self setMonthYear:year AndroidColor:@"#7dc3f9" AndMonth:monthStr];
            break;
        default:
            break;
    }
    _lb_show.attributedText = str;
    isScrooling = NO;
}

/***
 ***    设置日历中所显示的年月的颜色以及大小
 ***/
-(NSMutableAttributedString *)setMonthYear:(int)year AndroidColor:(NSString*)color AndMonth:(NSString *)Month{
    int size = 18;
    if(iphone6Plus){
        size = 18;
    } else if(iphone6){
        size = 18;
    } else {
        size = 15;
    }
    NSString *str1 = [NSString stringWithFormat:@"%d %@月",year,Month];
    NSMutableAttributedString *attributedStr01 = [[NSMutableAttributedString alloc] initWithString: str1];
    [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-light" size: size] range: NSMakeRange(0, 4)];
    [attributedStr01 addAttribute: NSFontAttributeName value: [UIFont fontWithName: @"HelveticaNeue-Thin" size: size] range: NSMakeRange(4, str1.length-4)];
    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [BHUtils hexStringToColor:@"ffffff"] range: NSMakeRange(0, 4)];
    [attributedStr01 addAttribute: NSForegroundColorAttributeName value: [BHUtils hexStringToColor:color] range: NSMakeRange(4, str1.length-4)];
    return attributedStr01;
}

-(void)calendarMonth:(LKCalendarMonth *)month dayView:(LKCalendarDayView *)dayView date:(NSDate *)date
{
    int monthdiff = monthDiffWithDateComponents(month.currentMonth,getYearMonthDateComponents(date));
    dayView.backgroundColor = [UIColor clearColor];
    dayView.date = date;
    dayView.lb_date.hidden = (monthdiff != 0);
    dayView.chi_date.hidden =  (monthdiff != 0);
    
    if (dayView.isShow&&monthdiff==0) {
        dayView.circleImageView.hidden = NO;
    } else {
        dayView.circleImageView.hidden = YES;
    }
    if (showLegal&&dayView.isShowHoliday&&monthdiff==0) {
        dayView.holidayImageView.hidden = NO;
        int legalHoliDayDate = (int)[BHUtils getLegalHoliDayDate:date];
        if (legalHoliDayDate==2) {
            //加班
            [dayView.holidayImageView setImage:[UIImage imageNamed:@"workday.png"]];
        } else if(legalHoliDayDate ==1){
            //休息
            [dayView.holidayImageView setImage:[UIImage imageNamed:@"holiday.png"]];
        }
    } else {
        dayView.holidayImageView.hidden = YES;
    }
}

-(void)calendarDayViewWillSelected:(LKCalendarDayView *)dayView
{
    if([_lastSelectedDayView isEqual:dayView])
        return;
    if(_lastSelectedDayView)
        _lastSelectedDayView.selected = NO;
    _lastSelectedDayView = dayView;
    int monthdiff = monthDiffWithDateComponents(_calendarView.currentDateComponents,getYearMonthDateComponents(dayView.date));
    if(monthdiff != 0)
    {
        dayView.selected = NO;
        LKCalendarDayView* selectedView = [_calendarView moveToDate:dayView.date];
        selectedView.selected = YES;
        _lastSelectedDayView = selectedView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    // If an error is encoutered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    completionHandler(NCUpdateResultNewData);
}

- (IBAction)lastMonth:(UIButton *)sender {
    if (isScrooling) return;
    isScrooling = YES;
    int row = _calendarView.leftMonth.getValidRow;
     self.preferredContentSize = CGSizeMake(0, SYCC_DayHeight*(row+2) + SYCC_DayOffsetHeight*(row+3)-25);
    CGPoint offset = _calendarView.scrollView.contentOffset;
    offset.x -= _calendarView.scrollView.bounds.size.width;
    [_calendarView.scrollView setContentOffset:offset animated:YES];
}

- (IBAction)nextMonth:(UIButton *)sender {
    if (isScrooling) return;
    isScrooling = YES;
    int row = _calendarView.rightMonth.getValidRow;
    self.preferredContentSize = CGSizeMake(0, SYCC_DayHeight*(row+2) + SYCC_DayOffsetHeight*(row+3)-25);
    CGPoint offset = _calendarView.scrollView.contentOffset;
    offset.x += _calendarView.scrollView.bounds.size.width;
    [_calendarView.scrollView setContentOffset:offset animated:YES];
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets
{
    return UIEdgeInsetsZero;
}
@end
