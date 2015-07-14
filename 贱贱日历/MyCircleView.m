//
//  MyCircleView.m
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "MyCircleView.h"

@implementation MyCircleView {
    UIColor *_fillColor;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.layer.masksToBounds = YES;
    _fillColor = self.backgroundColor;
}

- (void)drawRect:(CGRect)rect {
    [_fillColor set];
    UIRectFill(rect);
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    if (backgroundColor && backgroundColor != [UIColor clearColor]) {
         _fillColor = self.backgroundColor;
        [self setNeedsDisplay];
    }
}

@end
