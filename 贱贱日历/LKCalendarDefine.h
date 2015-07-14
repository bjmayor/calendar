//
//  LKCalendarDefine
//  LJH
//
//  Created by LJH on 13-10-22.
//  Copyright (c) 2013年 linggan. All rights reserved.
//

#import "LKCalendarView.h"
#import "LKCalendarMonth.h"
#import "LKCalendarDayView.h"

#define ipad ((int)[[UIScreen mainScreen] bounds].size.width==768)

#define iphone6Plus ((int)[[UIScreen mainScreen] bounds].size.width==414)

#define iphone6 ((int)[[UIScreen mainScreen] bounds].size.width==375)

#define DEVIATION_RIGHT  (ipad?22.0f:(iphone6Plus?22.0f:(iphone6?16.0f:12.0f)))

#define SYCC_DayWidth 30.0f
#define SYCC_DayHeight 30.0f

#define SYCC_PositionOffset (ipad?22.0f:(iphone6Plus?22.0f:(iphone6?16.0f:8.0f)))

#define SYCC_DayOffsetWidth (ipad?55.0f:(iphone6Plus?22.0f:(iphone6?16.0f:8.0f)))

#define SYCC_DayOffsetHeight (ipad?12.0f:(iphone6Plus?12.0f:(iphone6?12.0f:8.0f)))

#define SYCC_MonthWidth   (SYCC_DayWidth*7 + SYCC_DayOffsetWidth*8)
#define SYCC_MonthHeight  (SYCC_DayHeight*6 + SYCC_DayOffsetHeight*7)

#define currentLKCalendar [NSCalendar autoupdatingCurrentCalendar]

#define monthDiffWithDateComponents(com1,com2) ((com2.year - com1.year)*12 + (com2.month - com1.month))

#define getYearMonthDateComponents(date) [currentLKCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit fromDate:date]
