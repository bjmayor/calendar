//
//  BHColor.h
//  武的荣耀
//
//  Created by Bin on 14-6-11.
//  Copyright (c) 2014年 Bin. All rights reserved.
//
//  整理的项目中需要的工具类
//
#import <UIKit/UIKit.h>

#define Ce5e5e5 @"e5e5e5"
#define C808080 @"808080"
#define CC0C0C0 @"C0C0C0"
#define CFF4444 @"ff4444"
#define CF7F7F7 @"f7f7f7"
#define C7F7F7F @"7F7F7F"
#define CFFBE32 @"#ffbe32"
#define CB4E123 @"#b4e123"

#define  BHCOLOR(a) hexStringToColor(a)

@interface BHUtils : NSObject

//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
//判断字符串是否为空  建议使用此方法 否则会出现莫名其妙的Bug
+ (BOOL) isBlankString:(NSString *)string;
/**
 *  计算一个view相对于屏幕(去除顶部statusbar的20像素)的坐标
 *  iOS7下UIViewController.view是默认全屏的，要把这20像素考虑进去
 */
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v;
//获取阳历节日的算法
+(NSString *)getSolarHoliDayDate:(NSDate *)date;
//获取法定节假日
+(int)getLegalHoliDayDate:(NSDate *)date;

//获取农历节日的算法：
+(NSString *)getLunarHoliDayDate:(NSDate *)date;
//以下是根据公里年月日来获取农历节气的方法
+(NSString *)getLunarSpecialDate:(int)iYear Month:(int)iMonth Day:(int)iDay;

//获取农历方法2
+ (NSString *)lunarForSolar:(NSDate *)solarDate;
//计算星期几
+ (int)getWeekDayByDate:(NSDate *)date;

+(void)initSetting;

+(NSString *)getMonthString:(int) month;

+ (UIImage*) createImageWithColor: (UIColor*) color;
@end
