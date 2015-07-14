//
//  BaseViewController.m
//  贱贱日历
//
//  Created by Bin on 14-9-26.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _size = self.view.bounds.size;
    _ratio = self.view.bounds.size.width/320.0f;
    _marge = MARGE*_ratio;
    if(ipad){
        _ratio = 1.2f;
    }
}

/***
 ***    添加背景的颜色方块
 ***/
//-(void)addColorLump {
//    CGFloat width =  _size.width/8;
//    CGFloat line =  _size.height/width;
//    int order = 0;
//    for(int j = 0; j<line; j++){
//        for(int i = 0; i<8; i++){
//            UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(width*i, width*j, width, width)];
//            view.backgroundColor = [BHUtils hexStringToColor:_colorArr[order%8]];
//            order++;
//            [self.view addSubview:view];
//        }
//        order+=7;
//    }
//}

@end
