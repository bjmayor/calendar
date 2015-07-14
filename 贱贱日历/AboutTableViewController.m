//
//  AboutTableViewController.m
//  贱贱日历
//
//  Created by Bin on 14-10-1.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "AboutTableViewController.h"
#import "DefinitionClass.h"
#import "SuggestController.h"

@interface AboutTableViewController ()
{
    NSString *_currentVersion;
    NSString *_trackViewUrl;
}
@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.title = @"关于";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row ==1) {
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        _currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
        cell.detailTextLabel.text = [@"Ver" stringByAppendingString:_currentVersion];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    int section =  (int)indexPath.section;
    int row = (int)indexPath.row;
    if( section== 2&&row ==0){
        SuggestController *controller = [[SuggestController alloc] init];
        //意见反馈
        [self.navigationController pushViewController:controller animated:YES];
    }else if( section== 2&&row ==1){
        //更新检查网络请求的提示框
        CGSize size= self.view.bounds.size;
        UIView *view = [[UIView alloc] init];
        view.bounds = CGRectMake(0, 0, 80, 80);
        view.center = CGPointMake(size.width/2, size.height/2);
        view.layer.cornerRadius = 10;//设置那个圆角的有多圆
        view.layer.masksToBounds = NO;//设为NO去试试
        view.backgroundColor = [UIColor colorWithRed:50/250.0 green:50/250.0 blue:50/250.0 alpha:1.0];
        view.alpha = 0.8;
        [self.view addSubview:view];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.color = [UIColor whiteColor];
        activityView.center = CGPointMake(40, 40);
        [activityView startAnimating];
        [view addSubview:activityView];
        
        NSURL *url = [NSURL URLWithString:APP_ID_URL];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSThread sleepForTimeInterval:0];
            NSString *resultData = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [view removeFromSuperview];
                if(resultData != nil){
                    NSData *data= [resultData dataUsingEncoding:NSUTF8StringEncoding];
                    NSError *error = nil;
                    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    if (jsonObject != nil && error == nil){
                        if ([jsonObject isKindOfClass:[NSDictionary class]]){
                            NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                            long value = [[deserializedDictionary objectForKey:@"resultCount"] longValue];
                            if (value != 0) {
                                NSDictionary * dictionary = (NSDictionary *)[(NSArray *)[deserializedDictionary objectForKey:@"results"] objectAtIndex:0];
                                NSString *lastVersion = [dictionary objectForKey:@"version"];
                                if(![lastVersion isEqualToString:_currentVersion]) {
                                    _trackViewUrl = [dictionary objectForKey:@"trackViewUrl"];
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本检查" message:@"有新的版本，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
                                    alert.tag = 10000;
                                    [alert show];
                                }
                                else
                                {
                                     [self showAllert];
                                }
                            }
                            else
                            {
                                [self showAllert];
                            }
                        }
                    }
                }
            });
        });
    }else if(section== 2&&row ==2){
           //去评分
        NSString *evaluateString = [NSString stringWithFormat:APP_GRADE_URL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:evaluateString]];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:_trackViewUrl];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 24;
}

-(void)showAllert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本检查" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alert.tag = 10001;
    [alert show];
}

@end
