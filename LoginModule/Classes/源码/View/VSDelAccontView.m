//
//  VSDelAccontView.m
//  VVSDK
//
//  Created by admin on 12/28/21.
//

#import "VSDelAccontView.h"
#import "VSSDKDefine.h"
#import "WriteeVC.h"
#import "SDKENTRANCE.h"
#import "EditerStr.h"
@implementation VSDelAccontView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
        [self lauOutDelAccountView];
    }
    
    
    return  self;
}


-(void)lauOutDelAccountView{

    self.backgroundColor = [UIColor whiteColor];
    UILabel * titleLabel = [[UILabel alloc]init];
    
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.equalTo(self);
        make.height.equalTo(@40);
        
    }];
    
    titleLabel.text = VSLocalString(@"Notice");
    titleLabel.backgroundColor = VSDK_HEADVIEW_COLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
//    titleLabel.textColor = VSDK_ORANGE_COLOR;
    titleLabel.textColor = [UIColor redColor];
    
    UILabel * desLabel = [[UILabel alloc]init];
    [self addSubview:desLabel];
    [desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
    }];
    desLabel.font = [UIFont systemFontOfSize:14];
      
    NSString * btnTitle;
    NSString * str;
    NSNumber * accountState = VS_USERDEFAULTS_GETVALUE(@"vsdk_account_state");

    NSRange range;
    NSRange range2 = NSMakeRange(0, 0);
    //1 账号状态正常   2 申请删除处理中  3 账号已删除
    if ([accountState isEqualToNumber:@1]) {
      
        btnTitle = VSLocalString(@"Delete Account");
        if ([[EditerStr alloc] isKorean]) {
            btnTitle = @"계정 삭제";
        }
//        str = VSLocalString(@"Your account status is Normal. If you want to delete your account, please click the \"Delete Account\" button. We will handle your account deletion request within 7 days. Please note that the account can no longer be used after it is deleted.");
        str = VSLocalString(@"Your account status is normal. If you want to apply for account deletion, please click the Apply for Account \"Delete Account\". We will process your account deletion request based on your choice. After the account is deleted, it will no longer be able to be used!");
        
        range = [str rangeOfString:VSLocalString(@"Normal")];
        range2 = [str rangeOfString:VSLocalString(@"Please note that the account can no longer be used after it is deleted.")];
        
        if ([[EditerStr alloc] isKorean]) {
            str = @"해당 계정은 정상입니다. 계정삭제 신청을 원하시면 계정삭제 신청 버튼을 누르세요. 귀하의 선택에 따라 계정 삭제 요청을 처리해 드리겠습니다. 계정 삭제 후 다시 사용할 수 없습니다.";
            range = [str rangeOfString:VSLocalString(@"정상입니다")];
            range2 = [str rangeOfString:VSLocalString(@"계정 삭제 후 다시 사용할 수 없습니다.")];
        }
        
    }else {
        
        btnTitle = NSLocalizedString(@"Cancel Deletion", @"");
        if ([[EditerStr alloc] isKorean]) {
            btnTitle = @"삭제 취소";
        }
        
        str = NSLocalizedString(@"Your account status is Processing Deletion Request. If you want to cancel the account deletion request, please click the \"Cancel Deletion\" button below to cancel the request.", @"");
        
        range = [str rangeOfString:NSLocalizedString(@"Processing Deletion Request", @"")];
        
        if ([[EditerStr alloc] isKorean]){
            str = @"당신의 계정 상태는 삭제 요청 처리 중입니다. 계정 삭제 요청을 취소하려면 [삭제 취소] 버튼을 선택하여 요청을 취소하십시오.";
            range = [str rangeOfString:NSLocalizedString(@"상태는 삭제 요청 처리 중입니다", @"")];
        }
        
    }

    NSMutableAttributedString * colorStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    if ([accountState isEqualToNumber:@1]) {
        
        [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
    }
    
    [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    desLabel.textColor = [UIColor grayColor];
    desLabel.attributedText = colorStr;
    desLabel.numberOfLines = 0;
    desLabel.font = [UIFont systemFontOfSize:15];
    desLabel.textAlignment = NSTextAlignmentLeft;
    [desLabel sizeToFit];
    [desLabel layoutIfNeeded];
  
    
    CGFloat labelH = CGRectGetHeight(desLabel.frame);
    UIButton * delButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:delButton];
    
    [delButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width / 2, 35 ));
    }];
    
//    [delButton setBackgroundColor:VSDK_ORANGE_COLOR];
    [delButton setBackgroundColor:[UIColor redColor]];
    [delButton setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    [delButton setTitle:btnTitle forState:UIControlStateNormal];
    delButton.layer.cornerRadius = 5;
    [delButton addTarget:self action:@selector(delUserAccount:) forControlEvents:UIControlEventTouchUpInside];

    UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).with.offset(7.5);
        make.right.equalTo(self).with.offset(-7.5);
        make.size.mas_equalTo(CGSizeMake(25,25));
        
    }];
    
    [closeBtn setImage:[UIImage imageNamed:kSrcName(@"guanbi")] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeDelView) forControlEvents:UIControlEventTouchUpInside];

    self.frame = CGRectMake(0, 0, self.frame.size.width, 45 + 15 + labelH + 35 + 15 + 15);
    
    [VSDeviceHelper addAnimationInView:self Duration:0.35];
    
}

//删除
-(void)delUserAccount:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:VSLocalString(@"Delete Account")] || [sender.titleLabel.text isEqualToString:@"계정 삭제"]) {
        [self closeDelView];
        //走账号删除逻辑
        WriteeVC *writevc = [[WriteeVC alloc] init];
        [SDKENTRANCE showViewController:writevc];
        __weak typeof(self) ws = self;
        writevc.consumV.cancelBlock = ^{
            [SDKENTRANCE resignWindow];
//            if (ws.Ablock) {
//                ws.Ablock();
//            }
            if ([VSDKHelper sharedHelper].Ablock) {
                [VSDKHelper sharedHelper].Ablock();
            }
            
            
        };
        writevc.verifyV.vcloseBlock = ^{
            [SDKENTRANCE resignWindow];
//            if (ws.Bblock) {
//                ws.Bblock();
//            }
            if ([VSDKHelper sharedHelper].Bblock) {
                [VSDKHelper sharedHelper].Bblock();
            }
        };
        
//        VS_SHOW_TIPS_MSG(@"Requesting for account deletion");
//
//        [[VSDKAPI shareAPI]vsdk_delOrRecoverUserAccountWithType:@1 Success :^(id responseObject) {
//
//        if (REQUESTSUCCESS) {
//          //账号删除成功
//            VS_HUD_HIDE;VS_SHOW_SUCCESS_STATUS(@"Account deletion request approved!");
//            [self closeDelView];
//            VS_USERDEFAULTS_SETVALUE(@2, @"vsdk_account_state");
//
//        }else{
//
//            VS_HUD_HIDE;VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG);
//        }
        
//    } Failure:^(NSString *errorMsg) {
//
//        VS_HUD_HIDE; VS_SHOW_INFO_MSG(@"Account deletion request denied");
//
//    }];
        
    }else{
        
        VS_SHOW_TIPS_MSG(@"Canceling deletion request");

        [[VSDKAPI shareAPI]vsdk_delOrRecoverUserAccountWithType:@2 Success :^(id responseObject) {
        
        if (REQUESTSUCCESS) {
          
            VS_HUD_HIDE;VS_SHOW_SUCCESS_STATUS(@"Deletion request canceled");
            [self closeDelView];
            VS_USERDEFAULTS_SETVALUE(@1, @"vsdk_account_state");
    
        }else{
            
            VS_HUD_HIDE;VS_SHOW_ERROR_STATUS(VSDK_MISTAKE_MSG)
        }
        
    } Failure:^(NSString *errorMsg) {
        
        VS_HUD_HIDE; VS_SHOW_INFO_MSG(@"Failed to cancel the deletion request");
    }];

    }
 
}

-(void)closeDelView{
    
    if (self.closeBlock) {
        self.closeBlock();
    }
    
    [self removeFromSuperview];
//    [VSDKHelper sharedHelper]
}





@end
