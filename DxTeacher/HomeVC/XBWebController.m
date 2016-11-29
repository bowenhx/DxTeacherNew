//
//  XBWebController.m
//  jiazhangduan
//
//  Created by 周旭斌 on 2016/11/19.
//  Copyright © 2016年 周旭斌. All rights reserved.
//

#import "XBWebController.h"

@interface XBWebController () <UIWebViewDelegate>

@property (nonatomic, weak) UIButton *backButton;

@end

@implementation XBWebController

#pragma mark - target事件
- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
    self.backButton.hidden = YES;
}

- (void)loadView {
    self.view = [[UIWebView alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNavItem];
    
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    NSURL *url = [NSURL URLWithString:_targetUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    XBLog(@"开始");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    XBLog(@"结束");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    XBLog(@"失败");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - 设置UI
- (void)setUpNavItem {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _navTitle;
    label.xb_width(100).xb_height(40);
    self.navigationItem.titleView = label;
    
//    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.bounds = CGRectMake(0, 0, 30, 30);
//    imageView.image = [UIImage imageNamed:@"icon_back"];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
//    
//    UIButton *backButton = [[UIButton alloc] init];
//    _backButton = backButton;
//    backButton.frame = CGRectMake(35, 0, 44, 44);
//    [backButton setTitle:@"返回" forState:UIControlStateNormal];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    backButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.navigationController.navigationBar addSubview:backButton];
//    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
