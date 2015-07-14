//
//  Event.h
//  贱贱日历
//
//  Created by Bin on 14-10-2.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject<NSCoding,NSCopying>

@property(nonatomic, copy)NSString *title;//事件名称

@property(nonatomic, assign)int type;

@property(nonatomic, strong)NSDate *startTime;//开始时间

@property(nonatomic, strong) NSDate *endTime;//结束时间

@property(nonatomic, assign) int order;//重复

@property(nonatomic,copy)NSString *date;

@end
