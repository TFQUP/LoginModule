//
//  VSWebView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSWebView.h"

@interface VSWebView() <WKUIDelegate,WKNavigationDelegate>{
    WKBackForwardList * backForwardList;
}

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic,assign) BOOL isAllow;
@end

@implementation VSWebView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
   
    }
    return self;
}

-(void)showWebView{
    
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    self.progressView.backgroundColor = [UIColor orangeColor];
    [self.progressView setProgressTintColor:[UIColor orangeColor]];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self addSubview:self.progressView];
       
    self.webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.webView.UIDelegate = self;
    self.webView.navigationDelegate = self;
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    if (self.url) {

        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        
    }else{
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    }

    [self addSubview:self.webView];
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{

    /*
     if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
         [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:@{} completionHandler:nil];
         // 不允许web内跳转
         decisionHandler(WKNavigationActionPolicyCancel);
     } else {//应用的web内跳转
         decisionHandler (WKNavigationActionPolicyAllow);
     }
     */

    decisionHandler (WKNavigationActionPolicyAllow);
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {

            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;

            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self bringSubviewToFront:self.progressView];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
 
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {

}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}


@end
