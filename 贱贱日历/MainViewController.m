//
//  ViewController.m
//  贱贱日历
//
//  Created by Bin on 14-9-24.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "MainViewController.h"
#import "NewEventController.h"
#import "AllEventTableViewController.h"
#import "DefinitionClass.h"
#import "HowSHowViewController.h"
#import "BHNavigationController.h"

#define ITEM_HEIGHT 41.5


@interface MainViewController ()
{
    UIImage *_selectedBg;
    UIImage *_unselectedBg;
    UIDatePicker *_picker;
    NSUserDefaults * defaults;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedBg = [UIImage imageNamed:@"Selected.png"];
    _unselectedBg = [UIImage imageNamed:@"Unselected.png"];
    self.title = @"贱贱日历";
    defaults =  [[NSUserDefaults alloc] initWithSuiteName:@"group.com.bin.calendar"];
    [self addDetailsView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(!self.presentedViewController){
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(!self.presentedViewController){
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
}

-(void)addEvent{
    //所有事件
    [self addLine:CGRectMake(0, 300*super.ratio, super.size.width, 0.5*super.ratio)];
    UIButton * allEvents= [[UIButton alloc ]initWithFrame:CGRectMake(0, 300.5*super.ratio, super.size.width, ITEM_HEIGHT*super.ratio)];
    [self setBTAttr:allEvents :@"所有事件"];
    [allEvents addTarget:self action:@selector(allEvents:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:allEvents];
    //设置
    [self addLine:CGRectMake(0, 342*super.ratio, super.size.width, 0.5*super.ratio)];
    UIButton * setting= [[UIButton alloc ]initWithFrame:CGRectMake(0, 342.5*super.ratio, super.size.width, ITEM_HEIGHT*super.ratio)];
    [self setBTAttr:setting :@"设置"];
    [setting addTarget:self action:@selector(setting:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setting];
    //关于
    [self addLine:CGRectMake(0, 384*super.ratio, super.size.width, 0.5*super.ratio)];
    UIButton * about= [[UIButton alloc ]initWithFrame:CGRectMake(0, 384.5*super.ratio, super.size.width, ITEM_HEIGHT*super.ratio)];
    [self setBTAttr:about :@"关于"];
    [about addTarget:self action:@selector(about:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:about];
    //最后一条线
    [self addLine:CGRectMake(0, 426.1*super.ratio, super.size.width, 0.5*super.ratio)];
    //添加事件
    UIButton *addBT = [[UIButton alloc]initWithFrame:CGRectMake(0, super.size.height - ITEM_HEIGHT*super.ratio, super.size.width, ITEM_HEIGHT*super.ratio)];
    [self setBTAttr:addBT :@""];
    [addBT setImage:[UIImage imageNamed:@"MainAddEvent"] forState:UIControlStateNormal];
    [addBT addTarget:self action:@selector(addEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBT];
    [self addLine:CGRectMake(0, super.size.height - ITEM_HEIGHT*super.ratio, super.size.width, 0.5*super.ratio)];
    [self toGrade];
}

-(void)addDetailsView{
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailsIcon"]];
    icon.center = CGPointMake(super.size.width/2, super.size.height/2);
    icon.alpha = 1.0f;
    icon.transform = CGAffineTransformMakeScale(2.0, 2.0);
    [self.view addSubview:icon];
    [UIView animateWithDuration:1.5 animations:^{
        icon.alpha = 1.0f;
        icon.transform = CGAffineTransformMakeScale(1.0, 1.0);
        icon.center = CGPointMake(super.size.width/2, 127*super.ratio);
    } completion:^(BOOL finished) {
        UIImageView *appName = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainAppName"]];
        appName.center = CGPointMake(super.size.width/2, 191*super.ratio);
        appName.alpha = 0.0f;
        [self.view addSubview:appName];
        UIImageView *description = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainSlogan"]];
        description.alpha = 0.0f;
        description.center = CGPointMake(super.size.width/2, 213*super.ratio);
        [self.view addSubview:description];
        [UIView animateWithDuration:0.6f animations:^{
            appName.alpha = 1.0f;
            description.alpha = 1.0f;
            icon.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [self addEvent];
        }];
    }];
}

-(void)allEvents:(UIButton *)sender{
    [self performSegueWithIdentifier:@"allevent" sender:self];
}

-(void)setting:(UIButton *)sender{
    [self performSegueWithIdentifier:@"setting" sender:self];
}

-(void)about:(UIButton *)sender{
    [self performSegueWithIdentifier:@"about" sender:self];
}

-(void)addEvent:(UIButton *)sender{
    [self performSegueWithIdentifier:@"newevent" sender:self];
}

//设置Button的共有属性
-(void)setBTAttr:(UIButton *)sender :(NSString *)title{
    [sender setBackgroundImage:_selectedBg forState:UIControlStateNormal];
    [sender setBackgroundImage:_unselectedBg forState:UIControlStateHighlighted];
    [sender setTitle:title forState:UIControlStateNormal];
    sender.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    [sender setTitleColor:[BHUtils hexStringToColor:C808080]forState:UIControlStateNormal];
}

//添加分割线属性
-(void)addLine:(CGRect) rect{
    UIImageView *line = [[UIImageView alloc] initWithFrame:rect];
    line.backgroundColor = [BHUtils hexStringToColor:Ce5e5e5];
    [self.view addSubview:line];
}

-(void)toGrade{
    long launchNum = arc4random()%19891029;
    if (launchNum == 4999999){
    //if (true) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"亲，给我个五星好评吧" message:nil delegate:self cancelButtonTitle:@"别烦朕" otherButtonTitles:@"容朕想想", @"赐你好评", nil];
        [alertView show];
    }
    BOOL isGuide = [defaults boolForKey:@"guide"];
    if(isGuide) {
        HowSHowViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"howshow"];
        BHNavigationController *navcontroller = [[BHNavigationController alloc] initWithRootViewController:controller];
        navcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:navcontroller animated:YES
                         completion:^{
                             UIBarButtonItem *closeBI = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
                             controller.navigationItem.rightBarButtonItem = closeBI;
                         }];
        
    }
}

-(void)close:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [defaults setBool:false forKey:@"guide"];
    }];
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 2:{
            NSString *evaluateString = APP_GRADE_URL;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
        }
        case 0:
            [defaults setBool:NO forKey:@"grade"];
            break;
        default:
            break;
    }
}

@end
