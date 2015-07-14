//
//  Event.m
//  贱贱日历
//
//  Created by Bin on 14-10-2.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "Event.h"

@implementation Event

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeInt:_type forKey:@"type"];
    [aCoder encodeObject:_startTime forKey:@"startTime"];
    [aCoder encodeObject:_endTime forKey:@"endTime"];
    [aCoder encodeInt:_order forKey:@"order"];
    [aCoder encodeObject:_date forKey:@"date"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:@"title"];
        _type = [aDecoder decodeIntForKey:@"type"];
        _startTime = [aDecoder decodeObjectForKey:@"startTime"];
        _endTime = [aDecoder decodeObjectForKey:@"endTime"];
        _order = [aDecoder decodeIntForKey:@"order"];
        _date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

-(id)copyWithZone:(NSZone *)zone{
    Event *copy = [[[self class] allocWithZone:zone] init];
    copy.title = [self.title copyWithZone:zone];
    copy.type = self.type;
    copy.startTime = [self.startTime copyWithZone:zone];
    copy.endTime = [self.endTime copyWithZone:zone];
    copy.order = self.order;
    copy.date = [self.date copyWithZone:zone];
    return copy;
}

- (NSComparisonResult)compare:(Event *)otherEvent {
    return [self.startTime compare:otherEvent.startTime];
}

@end
