//
//  VSSelectLoginView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSelectLoginView.h"
#import "VSSDKDefine.h"
#import "UIButton+VSSignBtn.h"
#import "VSTermsView.h"
@interface VSSelectLoginView()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView * tableOption;
@property (nonatomic ,strong)UIScrollView * scrollView;
@property (nonatomic ,strong)NSMutableArray * aviPaltform;
@property (nonatomic ,assign)NSUInteger pCount;
@property (nonatomic ,strong)VSTermsView * viewTerm;
@end

@implementation VSSelectLoginView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self layOutLoginView];
    }
    
    return self;
}


-(void)layOutLoginView{

    CGFloat scaleH = 0;
    
    self.pCount = 0;
    
    //获取可用平台
    NSMutableDictionary * useDic = [VSDeviceHelper plarformAvailable];

    self.aviPaltform = [[NSMutableArray alloc]init];
     
     for (NSString * key in useDic) {
        
         if ([[useDic objectForKey:key]isEqualToNumber:[NSNumber numberWithInt:1]]) {
             
             if ([key isEqualToString:VSDK_FACEBOOK]) {
                 
                 [self.aviPaltform insertObject:key atIndex:0];
             }else{
             
                 [self.aviPaltform addObject:key];
                 
             }
         }
     }
    
    //看看是否iOS13系统以上
    if (@available(iOS 13.0, *)) {
        
        if ([self.aviPaltform containsObject:VSDK_APPLE]) {
            self.pCount = 3;
            scaleH = 1.0;
        }else{
            self.pCount = 2;
            scaleH = 0.68;
        }
       
    }else{
        
        if ([self.aviPaltform containsObject:VSDK_APPLE]) {
            [self.aviPaltform removeObject:VSDK_APPLE];
            self.pCount = 2;
            scaleH = 0.68;
        }
    }
    
    [self.aviPaltform addObject:VSDK_GUEST];
    
    self.frame = CGRectMake(0, 0, self.frame.size.width * 0.75, self.frame.size.height * 0.80 * scaleH);
    self.center = CGPointMake(VS_RootVC.view.center.x, VS_RootVC.view.center.y);
    self.backgroundColor  = [UIColor colorWithWhite:0 alpha:0];

    //iOS13以上系统
    if (@available(iOS 13.0, *)) {
        
        for (NSUInteger i = 0; i < self.pCount; i++) {
            
            //开启iOS登录
            if ([self.aviPaltform containsObject:VSDK_APPLE]) {
                if (i==1) {
                    ASAuthorizationAppleIDButton * appbutton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhite];
                    
                    appbutton.frame = CGRectMake(0, (i)*(self.frame.size.height -self.pCount*(self.frame.size.width /5))/4 + i * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
                        [appbutton addTarget:self action:@selector(appleSignin:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:appbutton];
                    
                }else if(i == 0){
                    
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(0, (i)*(self.frame.size.height - self.pCount*(self.frame.size.width/5))/4 + i * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
                    button.layer.cornerRadius = 5;
                    button.layer.masksToBounds = YES;
                    [button setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_account")] forState:UIControlStateNormal];
                    button.signInType = VSDK_PLATFORM_ACCOUNT;
                    [button addTarget:self action:@selector(loginWithType:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                    
                }else{
                    
                    //包含三方
                    if ([self.aviPaltform containsObject:VSDK_FACEBOOK]||[self.aviPaltform containsObject:VSDK_GOOGLE]||[self.aviPaltform containsObject:VSDK_TWITTER]) {
                        
                        [self.aviPaltform removeObject:VSDK_APPLE];
                        [self vsdk_thirdPUseableWithIndex:i];
                    //不包含三方
                    }else{
 
                        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(0, (i)*(self.frame.size.height -self.pCount*(self.frame.size.width/5))/4 + i * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
                        button.layer.cornerRadius = 5;
                        button.layer.masksToBounds = YES;
                        [button setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_palynow")] forState:UIControlStateNormal];
                        button.signInType = VSDK_GUEST;
                        [button addTarget:self action:@selector(loginWithType:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:button];
                        
                    }
                }
                
            //不开启iOS登录
            }else{
                
                
                if (i == 0) {
                   
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(0, (i)*(self.frame.size.height - self.pCount*(self.frame.size.width/5))/4 + i * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
                    button.layer.cornerRadius = 5;
                    button.layer.masksToBounds = YES;
                    [button setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_account")] forState:UIControlStateNormal];
                    button.signInType = VSDK_PLATFORM_ACCOUNT;
                    [button addTarget:self action:@selector(loginWithType:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                    
                }else{
                    
                    //包含三方
                    if ([self.aviPaltform containsObject:VSDK_FACEBOOK]||[self.aviPaltform containsObject:VSDK_GOOGLE]||[self.aviPaltform containsObject:VSDK_TWITTER]) {
                        
                        [self vsdk_thirdPUseableWithIndex:i];
                    // 不包含三方
                    }else{
                       
                        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                        button.frame = CGRectMake(0, (i)*(self.frame.size.height -self.pCount*(self.frame.size.width/5))/4 + i * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
                        button.layer.cornerRadius = 5;
                        button.layer.masksToBounds = YES;
                        [button setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_palynow")] forState:UIControlStateNormal];
                        button.signInType = VSDK_GUEST;
                        [button addTarget:self action:@selector(loginWithType:) forControlEvents:UIControlEventTouchUpInside];
                        [self addSubview:button];
                       
                    }
                }
            }
        }
        
    //iOS13以下系统
    }else{
                
        for (NSUInteger i = 0; i < self.pCount; i++) {
            
            if (i == 0) {
               
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(0, (i)*(self.frame.size.height -self.pCount*(self.frame.size.width/5))/4 + i * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
                button.layer.cornerRadius = 5;
                button.layer.masksToBounds = YES;
                [button setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_account")] forState:UIControlStateNormal];
                button.signInType = VSDK_PLATFORM_ACCOUNT;
                [button addTarget:self action:@selector(loginWithType:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:button];
                
            }else{
                
                //包含三方
                if ([self.aviPaltform containsObject:VSDK_FACEBOOK]||[self.aviPaltform containsObject:VSDK_GOOGLE]||[self.aviPaltform containsObject:VSDK_TWITTER]) {
                    
                    [self vsdk_thirdPUseableWithIndex:i];
                // 不包含三方
                }else{
                   
                    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.frame = CGRectMake(0, (i)*(self.frame.size.height -self.pCount*(self.frame.size.width/5))/4 + i * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
                    button.layer.cornerRadius = 5;
                    button.layer.masksToBounds = YES;
                    [button setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_palynow")] forState:UIControlStateNormal];
                    button.signInType = VSDK_GUEST;
                    [button addTarget:self action:@selector(loginWithType:) forControlEvents:UIControlEventTouchUpInside];
                    [self addSubview:button];
                   
                }
            }
        }
    }

    self.viewTerm = [[VSTermsView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, self.frame.size.width, ADJUSTPadAndPhonePortraitH(43,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGRectMake(0, 0, self.frame.size.width, ADJUSTPadAndPhoneH(55))];
    
    [self addSubview:self.viewTerm];
    [self.viewTerm mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.mas_bottom).with.offset(-8);
        make.left.equalTo(self);
        make.size.mas_equalTo(DEVICEPORTRAIT?CGSizeMake(self.frame.size.width, ADJUSTPadAndPhonePortraitH(43,[VSDeviceHelper getExpansionFactorWithphoneOrPad])):CGSizeMake(self.frame.size.width, ADJUSTPadAndPhoneH(55)));
        
    }];
    
    [self.viewTerm.agreeBtn addTarget:self action:@selector(comfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewTerm.agreeTermBtn addTarget:self action:@selector(showTermAction) forControlEvents:UIControlEventTouchUpInside];
    [VSDeviceHelper addAnimationInView:self Duration:0.4];

}


/// 支持三方
-(void)vsdk_thirdPUseableWithIndex:(NSUInteger)index{
    
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = VSDK_WHITE_COLOR;
    view.frame = CGRectMake(0, (index)*(self.frame.size.height -self.pCount*(self.frame.size.width/5))/4 + index * self.frame.size.width /5, self.frame.size.width, self.frame.size.width /5);
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    [self addSubview:view];
    
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
          
    [view addSubview:self.scrollView];

   [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {

      make.left.right.top.bottom.equalTo(view);

   }];
    
    [self.scrollView layoutIfNeeded];
    
    
    CGFloat kBtnHMargin = self.aviPaltform.count<4 ? 12 : 18;

    CGFloat kMargin =  (self.scrollView.frame.size.width -(self.scrollView.frame.size.height - kBtnHMargin)*self.aviPaltform.count)/(self.aviPaltform.count + 1);
    
    for (int i= 0;i<self.aviPaltform.count;i++) {

        NSString * imageName = [NSString stringWithFormat:@"vsdk_%@",self.aviPaltform[i]];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(kMargin + i*(kMargin + self.scrollView.frame.size.height - kBtnHMargin), kBtnHMargin/2, self.scrollView.frame.size.height - kBtnHMargin, self.scrollView.frame.size.height - kBtnHMargin);
        [button setImage:[UIImage imageNamed:kSrcName(imageName)] forState:UIControlStateNormal];
        button.signInType = self.aviPaltform[i];
        [button addTarget:self action:@selector(vsdk_thirdPLoginWithBtn:) forControlEvents:UIControlEventTouchUpInside];
     
        [self.scrollView addSubview:button];
        
    }
    
}


-(void)comfirmAction:(UIButton *)button{
    [self clicklogWithType:@"agree"];
    button.selected = !button.selected;
       
}



-(void)showTermAction{
    
//    [VSDeviceHelper showTermOrContactCustomerServiceWithUrl:[NSString stringWithFormat:@"%@&language=%@",VS_USERDEFAULTS_GETVALUE(@"vsdk_user_term_link")?VS_USERDEFAULTS_GETVALUE(@"vsdk_user_term_link"):VSDK_TERM_URL,[VSDeviceHelper vsdk_systemLanguage]]];
    
//    [VSDeviceHelper showTermOrContactCustomerServiceWithUrl:@""];
}


-(void)appleSignin:(ASAuthorizationAppleIDButton *)button API_AVAILABLE(ios(13.0)){
    [self clicklogWithType:@"apple"];
    if (self.viewTerm.agreeBtn.selected == YES) {

        if (self.selectBlock) {
            
            self.selectBlock(VSSelectLoginTypeApple);
        }
        
    }else{
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:VSLocalString(@"By logging in, you agree to the Terms of Service.") preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            self.viewTerm.agreeBtn.selected = YES;
            VS_USERDEFAULTS_SETVALUE(@YES, @"vsdk_comfirm_select");
            
                if (self.selectBlock) {
                    
                    self.selectBlock(VSSelectLoginTypeApple);
                }

        }]];
        
        [VS_RootVC presentViewController:alert animated:YES completion:nil];
        
    }
}


-(void)vsdk_thirdPLoginWithBtn:(UIButton *)button{

     if (self.viewTerm.agreeBtn.selected == YES) {
        
        if ([button.signInType isEqualToString:VSDK_FACEBOOK]) {
            
            if (self.selectBlock) {
                [self clicklogWithType:@"facebook"];
                self.selectBlock(VSSelectLoginTypeFacebook);
            }
            
        }else if ([button.signInType isEqualToString:VSDK_GOOGLE]) {
            
            if (self.selectBlock) {
                [self clicklogWithType:@"google"];
                self.selectBlock(VSSelectLoginTypeGoogle);
            }
            
        }else if([button.signInType isEqualToString:VSDK_TWITTER]) {
          
            if (self.selectBlock) {
                [self clicklogWithType:@"twitter"];
                self.selectBlock(VSSelectLoginTypeTwitter);
            }

        }else{
            
            if (self.selectBlock) {
                [self clicklogWithType:@"guest"];
                self.selectBlock(VSSelectLoginTypeGuest);
            }
        }
            
        }else{
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:VSLocalString(@"By logging in, you agree to the Terms of Service.") preferredStyle:UIAlertControllerStyleAlert];
            [self clicklogWithType:@"agree"];
            [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                self.viewTerm.agreeBtn.selected = YES;
                VS_USERDEFAULTS_SETVALUE(@YES, @"vsdk_comfirm_select");
    
                if ([button.signInType isEqualToString:VSDK_FACEBOOK]) {
                    
                    if (self.selectBlock) {
                        [self clicklogWithType:@"facebook"];
                        self.selectBlock(VSSelectLoginTypeFacebook);
                    }
                    
                }else if ([button.signInType isEqualToString:VSDK_GOOGLE]) {
                    
                    if (self.selectBlock) {
                        [self clicklogWithType:@"google"];
                        self.selectBlock(VSSelectLoginTypeGoogle);
                    }
                    
                }else if([button.signInType isEqualToString:VSDK_TWITTER]) {
                    
                    if (self.selectBlock) {
                        [self clicklogWithType:@"twitter"];
                        self.selectBlock(VSSelectLoginTypeTwitter);
                    }

                }else{
                    
                    if (self.selectBlock) {
                        [self clicklogWithType:@"guest"];
                        self.selectBlock(VSSelectLoginTypeGuest);
                    }
                }
            
            }]];
            
            [VS_RootVC presentViewController:alert animated:YES completion:nil];
    }
}




-(void)loginWithType:(UIButton *)button{
    
    if (self.viewTerm.agreeBtn.selected == YES) {
        
        if ([button.signInType isEqualToString:VSDK_PLATFORM_ACCOUNT]) {
        
        if (self.selectBlock) {
            [self clicklogWithType:@"account"];
            self.selectBlock(VSSelectLoginTypeAccount);
        }
        
    }else{
      
        if (self.selectBlock) {
            [self clicklogWithType:@"guest"];
            self.selectBlock(VSSelectLoginTypeGuest);
        }

    }
        
    }else{
        
    
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:VSLocalString(@"Notice") message:VSLocalString(@"By logging in, you agree to the Terms of Service.") preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:VSLocalString(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self clicklogWithType:@"agree"];
            self.viewTerm.agreeBtn.selected = YES;
            VS_USERDEFAULTS_SETVALUE(@YES, @"vsdk_comfirm_select");
            
            if ([button.signInType isEqualToString:VSDK_PLATFORM_ACCOUNT]) {
                
                if (self.selectBlock) {
                    [self clicklogWithType:@"account"];
                    self.selectBlock(VSSelectLoginTypeAccount);
                }
                
            }else{
              
                if (self.selectBlock) {
                    
                    [self clicklogWithType:@"guest"];
                    
                    self.selectBlock(VSSelectLoginTypeGuest);
                }

            }
        
        }]];
        
        
        [VS_RootVC presentViewController:alert animated:YES completion:nil];
        
        
    }
    
}


- (void)selectLoginViewBlock:(VSSelectLoginViewBlock) block{
    
    self.selectBlock = block;
}
//
//-(UITableView *)tableOption{
//    
//    if (!_tableOption) {
//        
//        _tableOption = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStyleGrouped];
//        
//         if (@available(iOS 13.0, *)) {
//                
//             _tableOption.backgroundColor = [UIColor systemBackgroundColor];
//             
//         }else{
//             
//             _tableOption.backgroundColor = VSDK_WHITE_COLOR;
//         }
//        
//        _tableOption.delegate = self;
//        _tableOption.dataSource = self;
//        _tableOption.bounces = NO;
//        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.01)];
//        _tableOption.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableOption.tableHeaderView = headerView;
//        _tableOption.rowHeight = DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitH(125,[VSDeviceHelper getExpansionFactorWithphoneOrPad]): ADJUSTPadAndPhoneH(143);
//        
//    }
//    
//    return _tableOption;
//    
//}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return self.pCount;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width - 40 , 5)];

    if (@available(iOS 13.0, *)) {
            
     view.backgroundColor = [UIColor systemBackgroundColor];
         
     }else{
         
      view.backgroundColor = VSDK_WHITE_COLOR;
    }
        
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        if (kiPhone6||kiPhone5) {
            return 5;
        }else{
            return 10;
        }
    }else{
        return 10.0f;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width - 40 , 3)];
    view.backgroundColor = VSDK_ORANGE_COLOR;
    
    return view;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellid = @"optCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds =YES;
    cell.backgroundColor = VSDK_ORANGE_COLOR;
    cell.textLabel.textColor = VSDK_WHITE_COLOR;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    
    return cell;
                                                        
}

-(void)clicklogWithType:(NSString *)type{
    [[VSDKAPI shareAPI] vsdk_loginClickWithType:type Success:^(id responseObject) {
                    
                } Failure:^(NSString *errorMsg) {
                    
                }];
}

@end
