//
//  SYCalendarDayView.h
//  Seeyou
//
//  Created by upin on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LKCalendarDayView;
@protocol LKCalendarDayViewDelegate <NSObject>
@optional
-(void)calendarDayViewWillSelected:(LKCalendarDayView*)dayView;
@end

@interface LKCalendarDayView : UIView

@property(weak,nonatomic)id<LKCalendarDayViewDelegate>delegate;

@property(nonatomic,getter = isSelected) BOOL selected;
@property(strong,nonatomic)NSDate* date;

@property(strong,nonatomic)UILabel* lb_date;
@property(strong, nonatomic)UILabel* chi_date;
@property(assign, nonatomic)BOOL *isShow;//是否展示当日圆圈
@property(strong, nonatomic)UIImageView *circleImageView;
@property(assign, nonatomic)BOOL *isShowHoliday;//是否展示假期
@property(strong, nonatomic)UIImageView *holidayImageView;
@property(strong,nonatomic)UIImageView* backgroupView;
@end