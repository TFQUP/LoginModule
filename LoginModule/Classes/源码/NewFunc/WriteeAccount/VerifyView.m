//
//  VerifyView.m
//  TextTest
//
//  Created by admin on 7/12/22.
//

#import "VerifyView.h"
#import "Masonry.h"
#import "EditerStr.h"
#import "VSSDKDefine.h"
#import "SDKENTRANCE.h"
#import "VSDeviceHelper.h"
@interface VerifyView()<UIScrollViewDelegate,UITextViewDelegate>
@property (nonatomic,copy) NSString *sureBtntxt;
//@property (nonatomic,copy) NSString *nocollingtxt;
@property (nonatomic,copy) NSString *collingtxt;
@end

@implementation VerifyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor grayColor];
        self.mainV = [[UIView alloc] init];
        self.agreeTextV = [[UITextView alloc] init];
        self.agreeTextV.delegate = self;
        self.bottomV = [[UIView alloc] init];
        self.containV = [[UIView alloc] init];
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectImgV = [[UIImageView alloc] init];
        self.tipLabel = [[UILabel alloc] init];
        self.clickTextLabel = [[UILabel alloc] init];
//        self.endLabel = [[UILabel alloc] init];
        self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.topV = [[UIView alloc] init];
        self.topLabel = [[UILabel alloc] init];
        self.topCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.coolingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.noCoolingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self addSubview:self.mainV];
        [self.mainV addSubview:self.agreeTextV];
        [self.mainV addSubview:self.bottomV];
        [self.mainV addSubview:self.containV];
        [self.containV addSubview:self.selectImgV];
        [self.containV addSubview:self.tipLabel];
        [self.containV addSubview:self.clickTextLabel];
//        [self.containV addSubview:self.endLabel];
        [self.containV addSubview:self.selectBtn];
        [self.bottomV addSubview:self.sureBtn];
        
        [self.bottomV addSubview:self.coolingBtn];
//        [self.bottomV addSubview:self.noCoolingBtn];
        
        [self addSubview:self.topV];
        [self.topV addSubview:self.topLabel];
        [self.topV addSubview:self.topCloseBtn];
        
        self.sureBtn.backgroundColor = [UIColor redColor];

        
        self.containV.hidden = YES;
        self.coolingBtn.hidden = YES;
//        self.noCoolingBtn.hidden = YES;
        
        self.collingtxt = VSLocalString(@"I need");
//        self.nocollingtxt = VSLocalString(@"I don't need");
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.sureBtn setTitle:VSLocalString(@"Please fully read and confirm the contents of this page") forState:UIControlStateNormal];
    self.sureBtntxt = VSLocalString(@"Please fully read and confirm the contents of this page");
    [self setUI];
    self.sureBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 8;
    [self.sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.mainV.backgroundColor = [UIColor whiteColor];
    self.mainV.layer.masksToBounds = YES;
    self.mainV.layer.cornerRadius = 8;
    
//    self.agreeTextV.userInteractionEnabled = NO;
    
//    self.tipLabel.text = @"我已仔细阅读，充分理解并同意《游戏账号注销协议》全部条款";
    self.tipLabel.font = [UIFont systemFontOfSize:10];
//    self.endLabel.font = [UIFont systemFontOfSize:10];
    self.clickTextLabel.font = [UIFont systemFontOfSize:10];
    self.clickTextLabel.textColor = [UIColor redColor];
    
    self.selectImgV.image = [UIImage imageNamed:kSrcName(@"N")];
    [self.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.topLabel.text = VSLocalString(@"Delete Account");
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.topCloseBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"guanbi")] forState:UIControlStateNormal];
    [self.topCloseBtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.coolingBtn setTitle:VSLocalString(@"I need") forState:UIControlStateNormal];
    self.coolingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.coolingBtn.backgroundColor = [UIColor redColor];
    [self.coolingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.coolingBtn.layer.masksToBounds = YES;
    self.coolingBtn.layer.cornerRadius = 8;
    [self.coolingBtn addTarget:self action:@selector(agreeCooling:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.noCoolingBtn.layer.masksToBounds = YES;
//    self.noCoolingBtn.layer.cornerRadius = 8;
//    [self.noCoolingBtn setTitle:VSLocalString(@"I don't need") forState:UIControlStateNormal];
    
//    self.noCoolingBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [self.noCoolingBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    self.noCoolingBtn.layer.borderWidth = 1;
//    self.noCoolingBtn.layer.borderColor = [UIColor redColor].CGColor;
//    [self.noCoolingBtn addTarget:self action:@selector(dontAgreeColling:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.sureBtn.backgroundColor = [UIColor systemPinkColor];
    self.sureBtn.userInteractionEnabled = NO;
    
    self.agreeTextV.text = [EditerStr shareInstance].str1;
    
    self.tipLabel.text = [EditerStr shareInstance].tipLabel1;
    self.clickTextLabel.text = [EditerStr shareInstance].tipLabel2;
//    self.endLabel.text = [EditerStr shareInstance].tipLabel3;
    
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick)];
    [self.clickTextLabel addGestureRecognizer:labelTapGestureRecognizer];
    self.clickTextLabel.userInteractionEnabled = YES;
    
//    self.tipLabel.text = [EditerStr shareInstance].str11;
//    self.tipLabel.text = [[EditerStr shareInstance] showTipStrWithStep:self.step];
//    self.clickTextLabel.hidden = YES;
//    self.endLabel.hidden = YES;
//    self.clickTextLabel.text = @"";
//    self.endLabel.text = @"";
//    NSLog(@"%d",self.step);
    if (self.step == 1) {
        NSArray *strArr = [[EditerStr shareInstance] showTipStrWithStep:self.step];
        self.tipLabel.text = strArr[0];
        self.clickTextLabel.text = strArr[1];
//        self.endLabel.text = strArr[2];
    }else if (self.step == 2){

        self.sureBtn.hidden = YES;
        self.coolingBtn.hidden = NO;
//        self.noCoolingBtn.hidden = NO;
        self.tipLabel.hidden = YES;
        self.clickTextLabel.hidden = YES;

    }else{
        self.tipLabel.hidden = NO;
        self.tipLabel.text = [[EditerStr shareInstance] showTipStrWithStep:self.step];
        self.clickTextLabel.hidden = YES;
    }
    [self.agreeTextV setEditable:NO];
}

-(void)labelClick{
    if (self.labelClickBlock) {
        self.labelClickBlock();
    }
}

-(void)agreeCooling:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(YES);
    }
}

-(void)dontAgreeColling:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(NO);
    }
}

-(void)selectBtnClick:(UIButton *)btn{
    
    BOOL isSelect = !btn.isSelected;
    NSString *showStr = [[EditerStr shareInstance] stepWithSelect:isSelect WithStep:self.step];
    if (isSelect) {
        btn.selected = isSelect;
        self.selectImgV.image = [UIImage imageNamed:kSrcName(@"S")];
        self.sureBtn.backgroundColor = [UIColor redColor];
        self.sureBtn.userInteractionEnabled = YES;
    }else{
        btn.selected = isSelect;
        self.selectImgV.image = [UIImage imageNamed:kSrcName(@"N")];
        self.sureBtn.backgroundColor = [UIColor systemPinkColor];
        self.sureBtn.userInteractionEnabled = NO;
    }
    [self.sureBtn setTitle:showStr forState:UIControlStateNormal];
    self.sureBtntxt = showStr;
}


-(void)closeView:(UIButton *)btn{
    //关闭弹窗显示账号登录页面
//    [SDKENTRANCE resignWindow];
    if (self.vcloseBlock) {
        self.vcloseBlock();
    }
}

-(void)sureClick:(UIButton *)btn{
    self.clickTextLabel.hidden = NO;
//    self.endLabel.hidden = NO;
    self.selectBtn.selected = NO;
    self.sureBtn.backgroundColor = [UIColor systemPinkColor];
    self.sureBtn.userInteractionEnabled = NO;
    self.selectImgV.image = [UIImage imageNamed:kSrcName(@"N")];
//    self.agreeTextV.text = [EditerStr shareInstance].str2;
//    self.tipLabel.text = [EditerStr shareInstance].str22;
    self.tipLabel.text = [EditerStr shareInstance].tipLabel1;
    self.clickTextLabel.text = [EditerStr shareInstance].tipLabel2;
//    self.endLabel.text = [EditerStr shareInstance].tipLabel3;
    self.step ++;
    self.containV.hidden = YES;
    NSString *showStr = [[EditerStr shareInstance] stepWithSelect:NO WithStep:self.step];
    [self.sureBtn setTitle:showStr forState:UIControlStateNormal];
    self.sureBtntxt = showStr;
    self.agreeTextV.text = [[EditerStr shareInstance] showAgreementWithStep:self.step];
    
    
//    if (self.step == 1) {
//        NSArray *strArr = [[EditerStr shareInstance] showTipStrWithStep:self.step];
//        self.tipLabel.text = strArr[0];
//        self.clickTextLabel.text = strArr[1];
////        self.endLabel.text = strArr[2];
//    }else if (self.step == 2){
//
//        self.sureBtn.hidden = YES;
//        self.coolingBtn.hidden = NO;
//        self.noCoolingBtn.hidden = NO;
//        self.tipLabel.hidden = YES;
//        self.clickTextLabel.hidden = YES;
//
//    }else{
//        self.tipLabel = [[EditerStr shareInstance] showTipStrWithStep:self.step];
//        self.clickTextLabel.hidden = YES;
//    }
    
    [self setUI];
    
}



-(void)setUI{
    
    if (self.step == 1) {
        NSArray *strArr = [[EditerStr shareInstance] showTipStrWithStep:self.step];
        self.tipLabel.text = strArr[0];
        self.clickTextLabel.text = strArr[1];
        self.tipLabel.hidden = NO;
        self.clickTextLabel.hidden = NO;
//        self.endLabel.text = strArr[2];
    }else if (self.step == 2){

        self.sureBtn.hidden = YES;
        self.coolingBtn.hidden = NO;
//        self.noCoolingBtn.hidden = NO;
        self.tipLabel.hidden = YES;
        self.clickTextLabel.hidden = YES;

    }else{
        self.tipLabel.hidden = NO;
        self.tipLabel.text = [[EditerStr shareInstance] showTipStrWithStep:self.step];
        self.clickTextLabel.hidden = YES;
    }
    
    if(DEVICEPORTRAIT){
        [self.mainV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(350, 300));
        }];
    }else{
        [self.mainV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(380, 300));
        }];
    }

    [self.topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainV);
        make.left.equalTo(self.mainV);
        make.right.equalTo(self.mainV);
        make.height.mas_equalTo(40);
    }];
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topV);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [self.topCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.right.equalTo(self.topV.mas_right);
        make.centerY.equalTo(self.topV);
    }];
    
    [self.bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainV);
        make.left.equalTo(self.mainV);
        make.right.equalTo(self.mainV);
        make.height.mas_equalTo(45);
    }];
    [self.containV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bottomV);
        make.left.equalTo(self.mainV);
        make.bottom.equalTo(self.bottomV.mas_top);
        make.width.equalTo(self.mainV);
        make.height.mas_equalTo(25);
    }];
    [self.agreeTextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topV.mas_bottom);
        make.left.equalTo(self.mainV);
        make.right.equalTo(self.mainV);
//        if (self.containV.isHidden) {
//            make.bottom.equalTo(self.bottomV.mas_top);
//        }else{
            make.bottom.equalTo(self.containV.mas_top);
//        }
        
    }];
    
    [self.selectImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.containV);
        make.centerY.equalTo(self.containV);
        make.left.equalTo(self.containV).offset(20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containV);
        make.left.equalTo(self.containV);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    if (self.tipLabel.hidden == NO) {
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.selectImgV.mas_right);
    //        make.top.equalTo(self.containV);
            make.centerY.equalTo(self.containV);
    //        make.right.equalTo(self.containV);
            
            if (self.step == 1) {
                make.width.mas_equalTo([VSDeviceHelper sizeWithFontStr:[[EditerStr shareInstance] showTipStrWithStep:self.step][0] WithFontSize:10] + 2);
            }else{
                make.width.mas_equalTo([VSDeviceHelper sizeWithFontStr:[[EditerStr shareInstance] showTipStrWithStep:self.step] WithFontSize:10]);
            }
            
            make.height.mas_equalTo(40);
        }];
    }
//    self.tipLabel.backgroundColor = [UIColor redColor];
    if (self.clickTextLabel.hidden == NO) {
        [self.clickTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tipLabel.mas_right);
            make.centerY.equalTo(self.containV);
            if (self.step == 1) {
                make.width.mas_equalTo([VSDeviceHelper sizeWithFontStr:[[EditerStr shareInstance] showTipStrWithStep:self.step][1] WithFontSize:10]);
            }else{
                make.width.mas_equalTo([VSDeviceHelper sizeWithFontStr:[[EditerStr shareInstance] showTipStrWithStep:self.step]  WithFontSize:10]);
            }
            
            make.height.mas_equalTo(40);
        }];
    }
//    self.clickTextLabel.backgroundColor = [UIColor blueColor];
//    [self.endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.clickTextLabel.mas_right);
//        make.centerY.equalTo(self.containV);
//        make.right.equalTo(self.containV);
//        make.height.mas_equalTo(40);
//    }];
//    self.endLabel.backgroundColor = [UIColor greenColor];
    NSLog(@"%@",self.sureBtntxt);
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containV.mas_bottom);
        make.centerX.equalTo(self.containV);
        make.size.mas_equalTo(CGSizeMake([VSDeviceHelper sizeWithFontStr:self.sureBtntxt WithFontSize:14], 30));
    }];
    
    NSLog(@"%@",self.collingtxt);
//    NSLog(@"%@",self.nocollingtxt);
    
//    [self.noCoolingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bottomV);
//        make.left.equalTo(self.bottomV).offset(20);
//        make.size.mas_equalTo(CGSizeMake(150, 30));
////        make.size.mas_equalTo(CGSizeMake([VSDeviceHelper sizeWithFontStr:self.nocollingtxt WithFontSize:14], 30));
//    }];

    
    [self.coolingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomV);
//        make.right.equalTo(self.bottomV.mas_right).offset(-20);
        make.centerX.equalTo(self.bottomV);
        make.size.mas_equalTo(CGSizeMake(150, 30));
//        make.size.mas_equalTo(CGSizeMake([VSDeviceHelper sizeWithFontStr:self.collingtxt WithFontSize:14], 30));
    }];
    
    NSLog(@"%@",self.tipLabel.text);
    NSLog(@"%@",self.clickTextLabel.text);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1
    {

        CGPoint offset = scrollView1.contentOffset;

        

        CGRect bounds = scrollView1.bounds;

        

        CGSize size = scrollView1.contentSize;

        

        UIEdgeInsets inset = scrollView1.contentInset;

        

        CGFloat currentOffset = offset.y + bounds.size.height - inset.bottom;

        

        CGFloat maximumOffset = size.height;
            
        
        if ((maximumOffset - currentOffset) < 20) {
            if (self.containV.isHidden && self.step != 2) {
                self.containV.hidden = NO;
            }
        }

        }
@end
