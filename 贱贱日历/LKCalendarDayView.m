//
//  SYCalendarDayView.m
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import "LKCalendarDayView.h"
#import "LKCalendarDefine.h"
#import "BHUtils.h"

@interface LKCalendarDayView()
{
    int lbFontSize;
    int chiFontSize;
}
@property(weak,nonatomic)UIImageView* selectedView;
@end

@implementation LKCalendarDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (iphone6Plus){
        lbFontSize = 26;
        chiFontSize = 12;
    }else if(iphone6){
        lbFontSize = 22;
        chiFontSize = 11;
    } else {
        lbFontSize = 19;
        chiFontSize = 10;
    }
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.circleImageView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 42, 42)];
        self.circleImageView.layer.masksToBounds = YES; //没这句话它圆不起来
        self.circleImageView.layer.cornerRadius = 21.0;
        self.circleImageView.backgroundColor = [BHUtils hexStringToColor:CFF4444];
        self.holidayImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"workday.png"]];
        if(ipad){
            self.circleImageView.center = CGPointMake(frame.size.width/2-37, frame.size.height/2+2);
            self.holidayImageView.center = CGPointMake(self.frame.size.width/2-24, self.frame.size.height/2-10);
            self.lb_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.0f,0, 32, 20)];
            _chi_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.5f,16, 32, 20)];
        } else if(iphone6Plus){
            self.circleImageView.bounds = CGRectMake(0, 0, 48, 48);
            self.circleImageView.layer.cornerRadius = 24.0;
            self.circleImageView.center = CGPointMake(frame.size.width/2-12, frame.size.height/2+2);
            self.holidayImageView.center = CGPointMake(self.frame.size.width/2+2, self.frame.size.height/2-11);
            self.lb_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.0f,0, 32, 20)];
            _chi_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.5f,18, 32, 20)];
        } else if (iphone6){
            self.circleImageView.center = CGPointMake(frame.size.width/2-9, frame.size.height/2+2);
            self.holidayImageView.center = CGPointMake(self.frame.size.width/2+3, self.frame.size.height/2-10);
            self.lb_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.0f,0, 32, 20)];
            _chi_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.5f,16, 32, 20)];
        }else {
            self.circleImageView.center = CGPointMake(frame.size.width/2-5, frame.size.height/2+2);
            self.holidayImageView.center = CGPointMake(self.frame.size.width/2+5, self.frame.size.height/2-10);
            self.lb_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.0f,0, 32, 20)];
            _chi_date = [[UILabel alloc]initWithFrame:CGRectMake(-2.5f,16, 32, 20)];
        }
        _lb_date.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:lbFontSize];
        _lb_date.textAlignment = NSTextAlignmentCenter;
        _lb_date.textColor = [UIColor whiteColor];
        
        _chi_date.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:chiFontSize];
        _chi_date.textAlignment = NSTextAlignmentCenter;
        _chi_date.textColor = [UIColor whiteColor];
        _chi_date.text = @"";
    }
    _circleImageView.hidden = YES;
    _holidayImageView.hidden = YES;
    [self addSubview:_circleImageView];
    [self addSubview:_holidayImageView];
    [self addSubview:_lb_date];
    [self addSubview:_chi_date];
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.selected = YES;
    if([self.delegate respondsToSelector:@selector(calendarDayViewWillSelected:)])
    {
        [self.delegate calendarDayViewWillSelected:self];
    }
}

-(void)setDate:(NSDate *)date
{
    _date = [date copy];
    NSDateComponents* dateComponents = [currentLKCalendar components:NSDayCalendarUnit fromDate:_date];
    NSString * dateDay= [NSString stringWithFormat:@"%d",dateComponents.day];
    _lb_date.text = dateDay;
    int weekDays = [BHUtils getWeekDayByDate:date];
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    NSArray *rest = [defaults arrayForKey:@"rest"];
    
    BOOL isAlpha = false;
    for (NSNumber *intteger in rest) {
        if (weekDays == [intteger intValue]) {
            isAlpha = true;
        }
    }
    if (isAlpha) {
        _lb_date.alpha = 0.5f;
        _chi_date.alpha = 0.5f;
    } else {
        _lb_date.alpha = 1.0f;
        _chi_date.alpha = 1.0f;
    }
    static int wCurYear,wCurMonth,wCurDay;
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    wCurYear = (int)[components year];
    wCurMonth = (int)[components month];
    wCurDay = (int)[components day];
    _chi_date.text = [BHUtils lunarForSolar:date];
    
    NSDateComponents *tempcomponents = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    if(components.year!=tempcomponents.year||components.month!=tempcomponents.month||
       components.day!=tempcomponents.day)
    {
        _lb_date.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:lbFontSize];
        _chi_date.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:chiFontSize];
        _isShowHoliday = false;
        _isShow = false;
    }
    _lb_date.textColor = [UIColor whiteColor];
    _chi_date.textColor = [UIColor whiteColor];
    NSMutableArray *showHoliday = [[defaults arrayForKey:@"showHoliday"] mutableCopy];
    for (int i = 0; i<showHoliday.count; i++) {
        int order = [[showHoliday objectAtIndex:i] intValue];
        if(order == 1) {
            //农历节日
            NSString *lunarHoliDayDate = [BHUtils getLunarHoliDayDate:date];
            if (lunarHoliDayDate != nil){
                _chi_date.textColor = [BHUtils hexStringToColor:CFFBE32];
                _chi_date.text = lunarHoliDayDate;
                break;
            }
        } else if(order ==2){
            //阳历节日
            NSString *solarHoliDayDate = [BHUtils getSolarHoliDayDate:date];
            if (solarHoliDayDate != nil){
                _chi_date.textColor = [BHUtils hexStringToColor:CFFBE32];
                _chi_date.text = solarHoliDayDate;
                break;
            }
        } else if(order == 3) {
            //节气
            NSString * specialDate = [BHUtils getLunarSpecialDate:wCurYear Month:wCurMonth Day:wCurDay];
            if (specialDate != nil){
                _chi_date.textColor = [BHUtils hexStringToColor:CB4E123];
                _chi_date.text = specialDate;
                break;
            }
        }
    }
    int legalHoliDayDate = (int)[BHUtils getLegalHoliDayDate:date];
    if (legalHoliDayDate==2) {
        _isShowHoliday = true;
    } else if(legalHoliDayDate ==1){
        _isShowHoliday = true;
    } else {
        _isShowHoliday = false;
    }
    
    if(components.year==tempcomponents.year&&components.month==tempcomponents.month&&
       components.day==tempcomponents.day)
    {
        _lb_date.font = [UIFont fontWithName:@"HelveticaNeue-light" size:lbFontSize];
        _chi_date.font = [UIFont fontWithName:@"HelveticaNeue-light" size:chiFontSize];
        _lb_date.alpha = 1.0f;
        _chi_date.alpha = 1.0f;
        _isShow = true;
    }
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    if(_selected)
    {
        NSLog(@"选中");
    }
    else
    {
        [self.selectedView removeFromSuperview];
        self.selectedView = nil;
    }
}
@end














