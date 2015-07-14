//
//  SuggestController.m
//  贱贱日历
//
//  Created by BinHan on 14/11/15.
//  Copyright (c) 2014年 Bin. All rights reserved.
//

#import "SuggestController.h"
#import "SKPSMTPMessage.h"
#import "NSData+Base64Additions.h"

@interface SuggestController ()<SKPSMTPMessageDelegate, UITextViewDelegate>
{
    UIScrollView *scrollView;
    UITextView *view;
    NSString *_contentStr;
    SKPSMTPMessage *_mm;
    NSString *_suggestStr;
    UIBarButtonItem *submit;
}
@end


@implementation SuggestController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    submit = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(submit:)];
    submit.tintColor = [UIColor greenColor];
    self.navigationItem.rightBarButtonItem = submit;
    submit.enabled = false;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, super.size.width, super.size.height)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(super.size.width, super.size.height);
    [self.view addSubview:scrollView];
    view= [[UITextView alloc] initWithFrame:CGRectMake(0, 10, super.size.width-10, 200)];
    view.center = CGPointMake(super.size.width/2, 100);
    view.layer.borderColor = [[UIColor whiteColor] CGColor];
    view.font = [UIFont systemFontOfSize: 16.0];
    view.delegate =self;
    [scrollView addSubview:view];
    [view becomeFirstResponder];
    [view becomeFirstResponder];
    _mm=[[SKPSMTPMessage alloc] init];
    [_mm setSubject:@"意见反馈"];
    [_mm setToEmail:@"han5yi2xuan1@163.com"];
    [_mm setFromEmail:@"1817965358@qq.com"];
    [_mm setRelayHost:@"smtp.qq.com"];
    [_mm setRequiresAuth:YES];
    [_mm setLogin:@"1817965358@qq.com"];
    [_mm setPass:@"yuiyui789"];
    [_mm setWantsSecure:YES];
    _mm.delegate=self;
}

- (void)dealloc
{
    _mm.delegate=nil;
}

- (void)textViewDidChange:(UITextView *)textView {
    if([BHUtils isBlankString:textView.text]){
        submit.enabled = false;
    }else {
        submit.enabled = true;
    };
}

-(void)submit:(UIButton *)sender{
    _contentStr = view.text;
    if ([BHUtils isBlankString:_contentStr]) {
        [self showAllertTile:@"提示" message:@"反馈内容不能为空！"];
        return;
    }
    NSDictionary * plainPart=[NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,[NSString stringWithCString:[_contentStr UTF8String] encoding:NSUTF8StringEncoding],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey, nil];
    [_mm setParts:[NSArray arrayWithObjects:plainPart,nil, nil]];
    [_mm send];
    submit.enabled = false;
}


//添加分割线属性
-(void)addLine:(CGRect) rect{
    UIImageView *line = [[UIImageView alloc] initWithFrame:rect];
    line.backgroundColor = [BHUtils hexStringToColor:Ce5e5e5];
    [scrollView addSubview:line];
}

-(void)messageSent:(SKPSMTPMessage *)message{
    UIAlertView *alert = [self showAllertTile:@"提示" message:@"发送成功，谢谢您的参与！"];
    alert.tag = 1000;
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{
    UIAlertView *alert = [self showAllertTile:@"提示" message:@"网络异常，发送失败！"];
    alert.tag = 1001;
}

-(UIAlertView *)showAllertTile:(NSString*)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    return alert;
}

//根据被点击按钮的索引处理点击事件
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000&&buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if(alertView.tag == 1001&&buttonIndex==0){
        submit.enabled = true;
    }
}

@end
