//
//  VSLoginView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSLoginView.h"
#import "VSTextBackView.h"
#import "VSSDKDefine.h"
API_AVAILABLE(ios(13.0))
static NSString * KpostChangeIconNotification = @"KpostChangeIconNotification";
@interface VSLoginView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong)UITableView *tableView;

@property (nonatomic ,strong)UIScrollView * scrollView;

@property (nonatomic ,strong)VSTextBackView * viewEmainBack;

@property (nonatomic ,strong)VSTextBackView * viewPswBack;

@property (nonatomic,strong)NSMutableArray * paltArr;

@end
@implementation VSLoginView


-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self layOutLoginView];
        
    }
    return self;
    
}


//懒加载数组
-(NSMutableArray *)userAccountData{
    
    if (!_userAccountData) {
        _userAccountData = [NSMutableArray arrayWithArray:[VSUserHelper executeLoadUserList]];
    }
    
    return _userAccountData;
}

//布局登录界面 ~
-(void)layOutLoginView{
    
    
    VSUser * user = [self.userAccountData firstObject];
    
    _viewEmainBack = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), 20, ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), 20, ADJUSTPadAndPhoneW(940), ADJUSTPadAndPhoneH(150))];
    
    _tfEmial = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Email/UID") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:NO];
    
    _tfEmial.text = user.account;
    
    _tfEmial.frame = DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(772), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(880), ADJUSTPadAndPhoneH(150));
    _tfEmial.delegate = self;
    _tfEmial.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_user")]];
    
    UIButton * emailRightBtn = [self emailTextFieldRightView];
    
    [emailRightBtn addTarget:self action:@selector(emainRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _tfEmial.rightView = emailRightBtn;
    
    [_viewEmainBack addSubview:_tfEmial];
    
    [self addSubview:_viewEmainBack];
    
    
    //    VS_VIEW_BOTTOM(_viewEmainBack)
    
    //密码输入框
    _viewPswBack = [[VSTextBackView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), ADJUSTPadAndPhonePortraitH(VS_VIEW_BOTTOM(_viewEmainBack) + 60,[VSDeviceHelper getExpansionFactorWithphoneOrPad]), ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), ADJUSTPadAndPhoneH(VS_VIEW_BOTTOM(_viewEmainBack)+ 60), ADJUSTPadAndPhoneW(469 * 2), ADJUSTPadAndPhoneH(150))];
    
    
    _tfPwd = [VSWidget textFieldWithPlaceholder:VSLocalString(@"Enter Your Password") borderStyle:UITextBorderStyleLine textAlign:NSTextAlignmentLeft backgroundColor:VSDK_WHITE_COLOR fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40): ADJUSTPadAndPhoneW(46) secure:YES];
    
    _tfPwd.delegate = self;
    
    _tfPwd.frame = DEVICEPORTRAIT?CGRectMake(0, 0, ADJUSTPadAndPhonePortraitW(772), ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(0, 0, ADJUSTPadAndPhoneW(880), ADJUSTPadAndPhoneH(150));
    
    _tfPwd.text = user.password;
    
    _tfPwd.leftView = [self textFieldLeftView:[UIImage imageNamed:kSrcName(@"vsdk_password")]];
    
    UIButton * pswRightBtn =  [self pswTextFieldRightView];
    _tfPwd.rightView = pswRightBtn;
    
    [pswRightBtn addTarget:self action:@selector(pswRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_viewPswBack addSubview:_tfPwd];
    
    [self addSubview:_viewPswBack];
    
    _btnLogin = [VSWidget buttonWithTitle:VSLocalString(@"Log In") titleColor:VSDK_WHITE_COLOR bgColor:VS_RGB(5, 51, 101) fontSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(46): ADJUSTPadAndPhoneW(60) textAlign:NSTextAlignmentCenter];
    _btnLogin.frame =DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), VS_VIEW_BOTTOM(_viewPswBack) + 20, _viewPswBack.frame.size.width, ADJUSTPadAndPhonePortraitH(135,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), VS_VIEW_BOTTOM(_viewPswBack) + 20, _viewPswBack.frame.size.width, ADJUSTPadAndPhoneH(150));
    _btnLogin.layer.cornerRadius = 5;
    _btnLogin.layer.masksToBounds = YES;
    [_btnLogin addTarget:self action:@selector(loginBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_btnLogin];
    
    UILongPressGestureRecognizer * LongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showLog)];
    LongPress.numberOfTouchesRequired = 1;
    LongPress.minimumPressDuration  = 2;
    [self addGestureRecognizer:LongPress];
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}

//邮箱地址右侧按钮点击事件
-(void)emainRightBtnAction:(UIButton *)button{
    
    button.selected = !button.selected;
    
    if (button.selected) {
        
        NSInteger count =  self.userAccountData.count>4?4:self.userAccountData.count;
        
        _tableAccount = [[UITableView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(ADJUSTPadAndPhonePortraitW(38.5), VS_VIEW_BOTTOM(self.viewEmainBack) + 1, self.viewEmainBack.frame.size.width, ADJUSTPadAndPhonePortraitH(106 * count,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(ADJUSTPadAndPhoneW(43), VS_VIEW_BOTTOM(self.viewEmainBack) + 1, self.viewEmainBack.frame.size.width, ADJUSTPadAndPhoneH(106* count)) style:UITableViewStylePlain];
        
        _tableAccount.dataSource =self;
        _tableAccount.delegate = self;
        _tableAccount.rowHeight = DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitH(106,[VSDeviceHelper getExpansionFactorWithphoneOrPad]): ADJUSTPadAndPhoneH(106);
        _tableAccount.layer.cornerRadius = 5;
        _tableAccount.layer.borderColor = VSDK_LIGHT_GRAY_COLOR.CGColor;
        _tableAccount.layer.borderWidth = 0.5;
        [self addSubview:_tableAccount];
        
    }else{
        
        _tableAccount.hidden = YES;
        
    }
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.userAccountData.count ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    VSUser * user =  [self.userAccountData objectAtIndex:indexPath.row];
    cell.textLabel.text  = user.account;
    cell.textLabel.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitH(44,[VSDeviceHelper getExpansionFactorWithphoneOrPad]): ADJUSTPadAndPhoneH(44)];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VSUser * user =  [self.userAccountData objectAtIndex:indexPath.row];
    self.tfEmial.text = user.account;
    self.tfPwd.text = user.password;
    UIButton * button =(UIButton * ) self.tfEmial.rightView;
    button.selected = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableAccount .hidden = YES;
    }];
}

-(void)pswRightBtnAction:(UIButton *)button{
    
    [self changeTextFieldSecure:self.tfPwd showBtn:button];
}



-(void)loginBtnAction:(UIButton *)button{
    
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    [paramDic setValue:@"account" forKey:@"click_type"];
    
    if ([VSTool isBlankString:self.tfEmial.text]) {
        [paramDic setValue:@"" forKey:@"name"];
    }else{
        [paramDic setValue:self.tfEmial.text forKey:@"name"];
    }
    
    if ([VSTool isBlankString:self.tfPwd.text]) {
        [paramDic setValue:@"" forKey:@"pass"];
    }else{
        [paramDic setValue:[VSEncryption md5:self.tfPwd.text] forKey:@"pass"];
    }
    
    [paramDic setValue:@"1" forKey:@"agree"];
    NSString * mD5str = [[VSDeviceHelper MD5SignWithDic:paramDic]stringByAppendingString:VSDK_GAME_KEY];
    NSString * sign = [VSEncryption md5:mD5str];
    [paramDic setValue:sign forKey:@"sign"];
    [VSHttpHelper POST:VSDk_LoginClick_API parameters:paramDic success:^(id  _Nonnull responseObject) {
        
    } failure:^(NSError * _Nonnull error) {

    }];
    
    if ([self.tfEmial.text rangeOfString:@"@"].location != NSNotFound) {
        
        if (![self checkInputAccount:self.tfEmial.text password:self.tfPwd.text]) {
            VS_SHOW_INFO_MSG(@"Please Enter The Correct Email Or Password");
        }else{
            
            if (self.loginCallback) {
                self.loginCallback(VSLoginViewBlockLogin);
            }
        }
        
    }else{
        
        if ([self.tfEmial.text length]>0&&[VSDeviceHelper isPureInt:self.tfEmial.text]&&[self.tfEmial.text integerValue] >0) {
            
            if (self.loginCallback) {
                self.loginCallback(VSLoginViewBlockLogin);
            }
            
        }else{
            
            VS_SHOW_INFO_MSG(@"Please Enter The Correct UID Or Password");
        }
    }
}



//显示日志
-(void)showLog{
    
    //查看相关日志
    if (self.loginCallback) {
        
        if (self.loginCallback) {
            self.loginCallback(VSLoginViewBlockSeeLog);
        }
    }
}


- (void)loginViewBlock:(VSLoginViewBlock)block {
    
    self.loginCallback = block;
}


@end
