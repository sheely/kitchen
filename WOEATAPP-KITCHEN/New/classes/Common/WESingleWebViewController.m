//
//  WESingleWebViewController.m
//  woeat
//
//  Created by liubin on 17/1/10.
//  Copyright © 2017年 liubin. All rights reserved.
//

#import "WESingleWebViewController.h"

@interface WESingleWebViewController ()
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WESingleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _titleString;
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.scalesPageToFit = YES;
    _webView.dataDetectorTypes = UIDataDetectorTypeAll;
    [self.view addSubview:_webView];
    
    NSURL* url = [NSURL URLWithString:_urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    
    //    NSString *fileName = @"help_user_agreement";
    //    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    //
    //    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //    [self.webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
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
