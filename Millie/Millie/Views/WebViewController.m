//
//  WebViewController.m
//  Millie
//
//  Created by JG on 2024/05/24.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSTimer *timedActivityTimer; // 타임아웃 타이머

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // WKWebView 생성 및 뷰에 추가
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.webView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.webView];
    
    // webView의 Auto Layout 설정
    [NSLayoutConstraint activateConstraints:@[
        [self.webView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.webView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.webView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [self.webView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    // 네비게이션 델리게이트 설정
    self.webView.navigationDelegate = self;
    
    // 로딩바 생성
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.activityIndicator];

    // 로딩바 Auto Layout 설정
    [NSLayoutConstraint activateConstraints:@[
        [self.activityIndicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [self.activityIndicator.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    // URL이 nil이 아닌 경우 로드
    if (self.urlString != nil) {
        NSURL *url = [NSURL URLWithString:self.urlString];
        if (url) {
            // 웹 뷰 로드 요청에 대한 타임아웃 설정
            NSTimeInterval timeoutInterval = 30.0; // 30초
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
            [self.webView loadRequest:request];
        } else {
            NSLog(@"Invalid URL string: %@", self.urlString);
        }
    } else {
        [self showAlert];
    }
    
    // 네비게이션 title 설정 및 뒤로 가기 버튼 설정
    self.navigationItem.title = @"WebView";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
}

// 웹뷰 알럿 표시
- (void)showAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"잠시 뒤에 다시 시도해주세요." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self backButtonPressed];
    }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 뒤로 가기
- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    // 웹 뷰가 로딩 시작할 때 로딩바 표시
    [self.activityIndicator startAnimating];
    [self startTimedActivityTimer]; // 타이머 시작
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // 웹 뷰 로딩 완료 시 로딩바 숨기기
    [self.activityIndicator stopAnimating];
    [self stopTimedActivityTimer]; // 타이머 중지
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 네비게이션 실패 시 로딩바 숨기기
    [self.activityIndicator stopAnimating];
    [self stopTimedActivityTimer]; // 타이머 중지
    [self showAlert];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    // 네비게이션 실패 시 로딩바 숨기기
    [self.activityIndicator stopAnimating];
    [self stopTimedActivityTimer]; // 타이머 중지
    [self showAlert]; // 오류 알림 표시
}

#pragma mark - Timed Activity

- (void)startTimedActivityTimer {
    // 타임아웃 타이머 시작
    self.timedActivityTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(activityTimedOut) userInfo:nil repeats:NO];
}

- (void)stopTimedActivityTimer {
    // 타임아웃 타이머가 실행 중인 경우 중지
    if (self.timedActivityTimer && [self.timedActivityTimer isValid]) {
        [self.timedActivityTimer invalidate];
        self.timedActivityTimer = nil;
    }
}

- (void)activityTimedOut {
    // 타임아웃 처리
    NSLog(@"Timed activity timed out.");
    [self showAlert];
}

@end
