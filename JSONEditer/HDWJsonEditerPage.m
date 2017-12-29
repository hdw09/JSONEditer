//
//  HDWJsonEditerPage.m
//  JSONEditer
//
//  Created by David on 2017/12/29.
//  Copyright © 2017年 David. All rights reserved.
//

#import "HDWJsonEditerPage.h"

@interface HDWJsonEditerPage () <UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) id<UIScrollViewDelegate> oldScrollDelegate;
@property (nonatomic, assign) CGPoint oldOffset;

@end

@implementation HDWJsonEditerPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.jsonString.length == 0) {
        self.jsonString = @"{}";
    }
}

- (void)keyboardWillShow
{
    self.oldScrollDelegate = self.webView.scrollView.delegate;
    self.oldOffset = self.webView.scrollView.contentOffset;
    self.webView.scrollView.delegate = self;
    [self.webView stringByEvaluatingJavaScriptFromString:@"jsonediter_keyboard_show();"];
}

- (void)keyboardWillHide
{
    self.webView.scrollView.delegate = self.oldScrollDelegate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.contentOffset = self.oldOffset;
}

- (void)setJsonString:(NSString *)jsonString
{
    _jsonString = [jsonString copy];
    [self loadWebWithLocalHtml];
}

-(void)loadWebWithLocalHtml
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"jsonediter" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL scheme] isEqualToString:@"jsonediter"]) {
        [self handleWebViewCall:request.URL];
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (![webView.request.URL.scheme isEqualToString:@"jsonediter"]) {
        NSString * tempStr = [self.jsonString stringByReplacingOccurrencesOfString:@"'" withString:@"\\'"];
        tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"set_json_editor('%@')", tempStr]];
    }
}

- (void)handleWebViewCall:(NSURL *)url
{
    if ([url.host isEqualToString:@"back"]) {
        NSString *backString = [self.webView stringByEvaluatingJavaScriptFromString:@"get_json_editor()"];
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.backJsonStringBlock) {
                self.backJsonStringBlock(backString);
            }
        }];
    } else if ([url.host isEqualToString:@"paste"]) {
        NSString *jsCall = [NSString stringWithFormat:@"jsonediter_paste('%@');", [UIPasteboard generalPasteboard].string];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCall];
    }
}

- (void)closeButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.bounces = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

@end

