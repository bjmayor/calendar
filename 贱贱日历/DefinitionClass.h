//
//  DefinitionClass.h
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_ID_URL  @"http://itunes.apple.com/lookup?id=941515328"//587767923
#define APP_GRADE_URL  @"itms-apps://itunes.apple.com/gb/app/yi-dong-cai-bian/id941515328?mt=8"

#define ALL_COLOR @[@"#ff7c7c",@"#f5e632",@"#7dc3f9",@"#6671ff",@"#e4a5ff",@"#ffa3c3"]
#define ALL_TYPE @[@"聚会", @"生日", @"面试", @"就医", @"约会", @"其他"]

@protocol PassTypeValueDelegate

-(void) setTypeValue:(NSInteger)param;

@end

@protocol PassRepeatValueDelegate

-(void) setRepeatValue:(NSInteger)param;

@end

@interface DefinitionClass : NSObject

@end
