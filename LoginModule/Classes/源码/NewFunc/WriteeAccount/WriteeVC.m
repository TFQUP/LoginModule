//
//  WriteeVC.m
//  VVSDK
//
//  Created by admin on 7/18/22.
//

#import "WriteeVC.h"
#import "ConsumeView.h"
#import "VerifyView.h"
#import "SDKENTRANCE.h"
#import "VSSDKDefine.h"

@interface WriteeVC ()
@property(nonatomic,strong)UIViewController *MainVC;

//@property(nonatomic,strong)ConsumeView *consumV;
//@property(nonatomic,strong)VerifyView *verifyV;
@end

@implementation WriteeVC

- (ConsumeView *)consumV{
    if (_consumV == nil) {
        _consumV = [[ConsumeView alloc] init];
    }
    return _consumV;
}

-(VerifyView *)verifyV{
    if (_verifyV == nil) {
        _verifyV = [[VerifyView alloc] init];
    }
    return _verifyV;
}

-(AgreementV *)agrV{
    if (_agrV == nil) {
        _agrV = [[AgreementV alloc] init];
    }
    return _agrV;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self changeWithView:self.verifyV];
//    [self.view addSubview:self.agrV];
    __weak typeof(self) ws = self;
    self.verifyV.clickBlock = ^(BOOL isAgree) {
    
            ws.consumV.type = isAgree;
            ws.view = ws.consumV;
            [ws.consumV setUI];
   
    };
//    self.verifyV.vcloseBlock = ^{
//        if (ws.closeBlock) {
//            ws.closeBlock();
//        }
//    };
    self.verifyV.labelClickBlock = ^{
        [ws.view addSubview:ws.agrV];
    };
    
    self.consumV.sureBlock = ^(int type) {
        //不需要犹豫期
        if (type == 0) {
                VS_SHOW_TIPS_MSG(@"Requesting for account deletion");
        
                [[VSDKAPI shareAPI]vsdk_delOrRecoverUserAccountWithType:@3 Success :^(id responseObject) {
        
                if (REQUESTSUCCESS) {
                    [SDKENTRANCE resignWindow];
                  //账号删除成功
                    VS_HUD_HIDE;VS_SHOW_SUCCESS_STATUS(@"Account deletion request approved!")
                    VS_USERDEFAULTS_SETVALUE(@3, @"vsdk_account_state");
        
                }else{
                    [SDKENTRANCE resignWindow];
                    VS_HUD_HIDE;VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
                }
                
            } Failure:^(NSString *errorMsg) {
                [SDKENTRANCE resignWindow];
                VS_HUD_HIDE;
                VS_SHOW_INFO_MSG(@"Account deletion request denied");
        
            }];
        }else{
            
            VS_SHOW_TIPS_MSG(@"Requesting for account deletion");
    
            [[VSDKAPI shareAPI]vsdk_delOrRecoverUserAccountWithType:@1 Success :^(id responseObject) {
    
            if (REQUESTSUCCESS) {
                [SDKENTRANCE resignWindow];
              //账号删除成功
                VS_HUD_HIDE;VS_SHOW_SUCCESS_STATUS(@"Account deletion request approved!")
                VS_USERDEFAULTS_SETVALUE(@2, @"vsdk_account_state");
    
            }else{
                [SDKENTRANCE resignWindow];
                VS_HUD_HIDE;VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
            }
            
        } Failure:^(NSString *errorMsg) {
            [SDKENTRANCE resignWindow];
            VS_HUD_HIDE;
            VS_SHOW_INFO_MSG(@"Account deletion request denied");
    
        }];
            
        }
    };
}

-(void)changeWithView:(UIView *)v{
//    [self.MainVC.view removeFromSuperview];
//    [self.MainVC removeFromParentViewController];
    self.view = v;
//    [self addChildViewController:self.MainVC];
//    self.view.frame = self.view.bounds;
//    [self.view addSubview:v];
    
    
}

@end
