//
//  VSWebView.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VSWebView : UIView
- (void)showWebView;
@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,strong)NSString * url;
@property(nonatomic,strong)NSString * htmlStr;
@end

NS_ASSUME_NONNULL_END
