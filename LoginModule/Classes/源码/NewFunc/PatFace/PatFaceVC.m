//
//  PatFaceVC.m
//  VVSDK
//
//  Created by admin on 6/14/22.
//

#import "PatFaceVC.h"
#import "VSSDKDefine.h"
#import "VSDeviceHelper.h"
#import "SDKENTRANCE.h"
#import <WebKit/WebKit.h>
#import "Pic_PatModel.h"
#import "VSDKHelper.h"
#import "VSTool.h"
#import "Level_PatModel.h"
@interface PatFaceVC ()
@property(nonatomic,strong) UIView *containV;
@property (nonatomic,strong) UIImageView *imgV;
//@property (nonatomic,strong) UIButton *tapBtn;
//@property (nonatomic,strong) NSMutableArray *imgArr;
//@property (nonatomic,strong) NSMutableArray *btnArr;
@property (nonatomic,strong) UIImageView *gotoImgV;
@property (nonatomic,strong) UIButton *gotoBtn;
@property (nonatomic,strong) UIView *imgContainV;
@property (nonatomic,strong) UIImageView *pichImgV;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIButton *pichBtn;
@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) NSMutableArray *pic_listArr;
@property (nonatomic,strong) NSMutableArray *level_pic_listArr;
@property (nonatomic,strong) NSMutableArray *level_show_ListArr;
@property (nonatomic,strong) WKWebView *imgWebV;

@property (nonatomic,copy) NSString *tipStr;
@end

@implementation PatFaceVC

-(WKWebView *)imgWebV{
    if (_imgWebV == nil) {
        _imgWebV = [[WKWebView alloc] init];
        _imgWebV.backgroundColor = [UIColor clearColor];
        _imgWebV.allowsBackForwardNavigationGestures = YES;

    }
    return _imgWebV;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if(DEVICEPORTRAIT){
        self.portrait = YES;
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    [self setUI];
    [self loadDate];
    
}

-(void)loadDate{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [ud objectForKey:@"NEWPAT"];
    NSNumber *nub = [dic objectForKey:@"state"];
    NSString *state = [nub stringValue];
    NSDictionary *dateDic = [dic objectForKey:@"data"];
    NSArray *pic_lict = [dateDic objectForKey:@"pic_list"];
    NSArray *level_pic_list = [dateDic objectForKey:@"level_pic_list"];
    
    self.pic_listArr = [NSMutableArray array];
    self.level_pic_listArr = [NSMutableArray array];
    
    
    if ([self.showType isEqualToString:@"pic_list"]) {
        for (NSDictionary *dic in pic_lict) {
            NSString *imgStr = [dic objectForKey:@"img"];
            NSString *btnImgStr = [dic objectForKey:@"btn_img"];
            
            UIImage *img = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgStr];
            UIImage *btnImg = [[SDImageCache sharedImageCache] imageFromCacheForKey:btnImgStr];
            
            Pic_PatModel *pmodel = [[Pic_PatModel alloc] init];
            pmodel.img_id = [dic objectForKey:@"img_id"];
            pmodel.img = [dic objectForKey:@"img"];
            pmodel.link = [dic objectForKey:@"link"];
            pmodel.btn_img = [dic objectForKey:@"btn_img"];
            pmodel.jump_type = [dic objectForKey:@"jump_type"];
            pmodel.jump_page = [dic objectForKey:@"jump_page"];
            pmodel.mainImg = img;
            pmodel.btnImg = btnImg;
            [self.pic_listArr addObject:pmodel];
        }
        
        Pic_PatModel *pmd = self.pic_listArr[0];
        
        if (![[SDImageCache sharedImageCache] imageFromCacheForKey:pmd.img]) {
            [self.imgV sd_setImageWithURL:[NSURL URLWithString:pmd.img]];
        }else{
            self.imgV.image = pmd.mainImg;
        }
        
        if (![[SDImageCache sharedImageCache] imageFromCacheForKey:pmd.btn_img]) {
            [self.gotoImgV sd_setImageWithURL:[NSURL URLWithString:pmd.btn_img]];
        }else{
            self.gotoImgV.image = pmd.btnImg;
        }
        
        
        
        //第一张图片数据上报
        [[VSDKAPI shareAPI] vsdk_reportPatFaceDateWithImgID:pmd.img_id WithImgtitle:pmd.img_title WithImgUrl:pmd.img WithType:@"show" Success:^(id responseObject) {
                    
                } Failure:^(NSString *errorMsg) {
                    
                }];
        
    }else if ([self.showType isEqualToString:@"level_pic_list"]){
        for (NSDictionary *dic in level_pic_list) {
            NSString *imgStr = [dic objectForKey:@"img"];
            NSString *btnImgStr = [dic objectForKey:@"btn_img"];
            
            UIImage *img = [[SDImageCache sharedImageCache] imageFromCacheForKey:imgStr];
            UIImage *btnImg = [[SDImageCache sharedImageCache] imageFromCacheForKey:btnImgStr];
            
            Level_PatModel *pmodel = [[Level_PatModel alloc] init];
            pmodel.img_id = [dic objectForKey:@"img_id"];
            pmodel.img = [dic objectForKey:@"img"];
            pmodel.link = [dic objectForKey:@"link"];
            pmodel.btn_img = [dic objectForKey:@"btn_img"];
            pmodel.jump_type = [dic objectForKey:@"jump_type"];
            pmodel.jump_page = [dic objectForKey:@"jump_page"];
            pmodel.level_type = [dic objectForKey:@"level_type"];
            NSNumber *starLevelNub = [dic objectForKey:@"start_level"];
            NSInteger starlevel = [starLevelNub integerValue];
            pmodel.start_level = starlevel;
            NSNumber *endLevelNub = [dic objectForKey:@"end_level"];
            NSInteger endlevel = [endLevelNub integerValue];
            pmodel.end_level = endlevel;
            
            pmodel.mainImg = img;
            pmodel.btnImg = btnImg;
            [self.level_pic_listArr addObject:pmodel];
            
        }
        
        NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
        NSInteger lev = [roleLevel integerValue];
        self.level_show_ListArr = [NSMutableArray array];
        for (Level_PatModel *model in self.level_pic_listArr) {
            if ([model.level_type isEqualToString:@"appoint"]) {
                if (lev == model.start_level) {
                    [self.level_show_ListArr addObject:model];
                }
            }
            if ([model.level_type isEqualToString:@"up"]) {
                if (lev >= model.start_level) {
                    [self.level_show_ListArr addObject:model];
                }
            }
            if ([model.level_type isEqualToString:@"down"]) {
                if (lev <= model.start_level) {
                    [self.level_show_ListArr addObject:model];
                }
            }
            if ([model.level_type isEqualToString:@"range"]) {
                if (lev >= model.start_level && lev <= model.end_level) {
                    [self.level_show_ListArr addObject:model];
                }
            }
        }
        
        //拿出符合条件的图片进行展示
        Level_PatModel *pmd = self.level_show_ListArr[0];
        if (![[SDImageCache sharedImageCache] imageFromCacheForKey:pmd.img]) {
            [self.imgV sd_setImageWithURL:[NSURL URLWithString:pmd.img]];
        }else{
            self.imgV.image = pmd.mainImg;
        }
        
        if (![[SDImageCache sharedImageCache] imageFromCacheForKey:pmd.btn_img]) {
            [self.gotoImgV sd_setImageWithURL:[NSURL URLWithString:pmd.btn_img]];
        }else{
            self.gotoImgV.image = pmd.btnImg;
        }
        //第一张图片展示数据上报
        [[VSDKAPI shareAPI] vsdk_reportPatFaceDateWithImgID:pmd.img_id WithImgtitle:pmd.img_title WithImgUrl:pmd.img WithType:@"show" Success:^(id responseObject) {
                    
                } Failure:^(NSString *errorMsg) {
                    
                }];
    }
}

-(void)setUI{
    self.imgContainV = [[UIView alloc] init];
    self.imgContainV.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imgContainV];
    self.imgV = [[UIImageView alloc] init];
//    self.imgV.layer.masksToBounds = YES;
//    self.imgV.layer.cornerRadius = 8;
//    self.tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.tapBtn addTarget:self action:@selector(tapImgV:) forControlEvents:UIControlEventTouchUpInside];
    self.gotoImgV = [[UIImageView alloc] init];
    self.gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.gotoBtn addTarget:self action:@selector(gotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.gotoBtn.backgroundColor = [UIColor clearColor];
    self.containV = [[UIView alloc] init];
    self.containV.backgroundColor = [UIColor clearColor];
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.closeBtn addTarget:self action:@selector(closePatV:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_close_white")] forState:UIControlStateNormal];
    [self.view addSubview:self.containV];
    [self.imgContainV addSubview:self.imgV];
    [self.imgContainV addSubview:self.imgWebV];
    self.imgWebV.hidden = YES;
//    [self.view addSubview:self.tapBtn];
    [self.view addSubview:self.gotoImgV];
    [self.gotoImgV addSubview:self.gotoBtn];
    self.gotoImgV.userInteractionEnabled = YES;
    [self.view addSubview:self.closeBtn];
    
    self.containV = [[UIView alloc] init];
    self.pichImgV = [[UIImageView alloc] init];
    self.tipLabel = [[UILabel alloc] init];
    
    self.tipStr = VSLocalString(@"No more prompts today");
    if ([VSTool isKorean]) {
        self.tipStr = @"오늘 보지 않기";
    };
    
    self.tipLabel.text = self.tipStr;
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.pichBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pichBtn addTarget:self action:@selector(changeImg:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.containV];
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//    NSString *time = [ud objectForKey:@"STIME"];
//    BOOL isS = [ud boolForKey:@"isS"];
//    //如果已经选择了今天不显示，并且选择的日期是今天
//    if ([VSTool nowisToday:time] && isS) {
//        self.containV.hidden = YES;
//    }else{
//        //新的一天初始化选择
//        [ud setBool:NO forKey:@"isS"];
//        [ud synchronize];
//        self.containV.hidden = NO;
//    }
    [self updeteSelectImg];

    
    
    [self.containV addSubview:self.pichImgV];
    [self.containV addSubview:self.tipLabel];
    [self.containV addSubview:self.pichBtn];
   
    if (self.portrait) {
        [self.imgContainV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-20);
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.7);
            make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.7);
        }];
    }else{
        [self.imgContainV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.7);
            make.height.mas_equalTo(self.view.mas_height).multipliedBy(0.7);
        }];
    };
    [self.imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.imgContainV);
        make.center.equalTo(self.imgContainV);
    }];
    [self.imgWebV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.imgContainV);
        make.center.equalTo(self.imgContainV);
    }];
    
    [self.gotoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgV.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.centerX.equalTo(self.imgV);
    }];
    
//    if (self.portrait) {
//        [self.gotoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.imgV.mas_bottom).offset(5);
////            make.width.equalTo(self.imgV).multipliedBy(0.2);
////            make.height.equalTo(self.imgV).multipliedBy(0.15);
//            make.size.mas_equalTo(CGSizeMake(100, 40));
//            make.centerX.equalTo(self.imgV);
//        }];
//    }else{
//        [self.gotoImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.imgV.mas_bottom).offset(5);
////            make.width.equalTo(self.imgV).multipliedBy(0.2);
////            make.height.equalTo(self.imgV).multipliedBy(0.15);
//            make.size.mas_equalTo(CGSizeMake(100, 40));
//            make.centerX.equalTo(self.imgV);
//        }];
//    }
    
    
    [self.gotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.size.equalTo(self.gotoImgV);
        make.center.equalTo(self.gotoImgV);
    }];
//    self.gotoBtn.backgroundColor = [UIColor whiteColor];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imgV.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.top.equalTo(self.imgV);
    }];
 
    
    CGFloat labelW = [VSDeviceHelper sizeWithFontStr:self.tipStr WithFontSize:13];
    
    [self.containV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(20 + labelW);
        make.bottom.equalTo(self.gotoBtn.mas_bottom).offset(0);
        make.right.equalTo(self.imgV);
//        make.height.equalTo(self.gotoBtn).multipliedBy(0.5);
        make.height.mas_equalTo(40);
    }];
//    self.containV.backgroundColor = [UIColor yellowColor];
    
    [self.pichImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.equalTo(self.containV);
        make.centerY.equalTo(self.containV);
    }];
//    self.pichImgV.backgroundColor = [UIColor redColor];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pichImgV.mas_right).offset(0);
        make.top.equalTo(self.containV.mas_top).offset(0);
        make.bottom.equalTo(self.containV.mas_bottom).offset(0);
        make.right.equalTo(self.containV.mas_right).offset(0);
    }];
//    self.tipLabel.backgroundColor = [UIColor grayColor];
    
    [self.pichBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.containV);
        make.center.equalTo(self.containV);
    }];
    self.pichBtn.backgroundColor = [UIColor clearColor];
    
    if (self.portrait) {
        [self.containV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(20 + labelW);
            make.height.mas_equalTo(40);
            make.top.equalTo(self.imgV.mas_bottom).offset(10);
            make.right.equalTo(self.imgV);
            
        }];
        [self.gotoImgV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containV.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(100, 40));
            make.centerX.equalTo(self.imgV);
        }];
    }
}


-(void)tapImgV:(UIButton *)btn{
    
}

-(void)changeImg:(UIButton *)btn{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isS = ![ud boolForKey:@"isS"];
    [ud setBool:isS forKey:@"isS"];
    [self updeteSelectImg];
    
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    // 得到当前时间（世界标准时间 UTC/GMT）
    NSDate *nowDate = [NSDate date];

    NSString *nowDateString = [dateFormatter stringFromDate:nowDate];

//    NSLog(@"现在时间: nowDate=%@, nowDateString=%@",nowDate,nowDateString);
    
    if (isS) {
        //保存当前时间
        [ud setValue:nowDateString forKey:@"STIME"];
    }else{
        [ud setValue:@"" forKey:@"STIME"];
    }
    [ud synchronize];
}

-(void)updeteSelectImg{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isS = [ud boolForKey:@"isS"];
    if (isS) {
        self.pichImgV.image = [UIImage imageNamed:kSrcName(@"select.png")];
    }else{
        self.pichImgV.image = [UIImage imageNamed:kSrcName(@"unselect.png")];
    }
}

-(void)closePatV:(UIButton *)btn{
    self.imgWebV.hidden = YES;
    self.imgV.hidden = NO;
    if (self.pic_listArr.count > 1) {
        
        [self.pic_listArr removeObjectAtIndex:0];
        Pic_PatModel *pmd = self.pic_listArr[0];
        if (![[SDImageCache sharedImageCache] imageFromCacheForKey:pmd.img]) {
            [self.imgV sd_setImageWithURL:[NSURL URLWithString:pmd.img]];
        }else{
            self.imgV.image = pmd.mainImg;
        }
        
        if (![[SDImageCache sharedImageCache] imageFromCacheForKey:pmd.btn_img]) {
            [self.gotoImgV sd_setImageWithURL:[NSURL URLWithString:pmd.btn_img]];
        }else{
            self.gotoImgV.image = pmd.btnImg;
        }
        
    }else{
        [SDKENTRANCE resignWindow];
    }
    
}

-(void)gotoBtnClick:(UIButton *)btn{
    
    if ([self.showType isEqualToString:@"pic_list"]) {
        Pic_PatModel *pmd = self.pic_listArr[0];
        
        if ([pmd.jump_type isEqualToString:@"game"]) {
            //游戏内处理
            if ([VSDKHelper sharedHelper].PatfaceBlock) {
                [VSDKHelper sharedHelper].PatfaceBlock(pmd.jump_page);
                [SDKENTRANCE resignWindow];
            }
            
        }
        
        
        if ([VSTool isBlankString:pmd.link]) {
            return;
        }
        
        NSString *requestUrl = [self connectParameterWithUrl:pmd.link WithImgid:pmd.img_id WithImgtitle:pmd.img_title WithImgurl:pmd.img WithType:pmd.jump_type];
        
        if ([pmd.jump_type isEqualToString:@"inside"]) {
            
            self.imgV.hidden = YES;
            self.imgWebV.hidden = NO;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
            [self.imgWebV loadRequest:request];
            
            [[VSDKAPI shareAPI] vsdk_reportPatFaceDateWithImgID:pmd.img_id WithImgtitle:pmd.img_title WithImgUrl:pmd.img WithType:@"click" Success:^(id responseObject) {
                        
                    } Failure:^(NSString *errorMsg) {
                        
                    }];
            
        }else if ([pmd.jump_type isEqualToString:@"outside"]){
            if ([VSTool isBlankString:pmd.link]) {
                return;
            }
//            [[VSDKHelper sharedHelper] vsdk_openWebPageInSafariWithUrl:requestUrl];
//            NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES};
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestUrl] options:options completionHandler:nil];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestUrl] options:@{} completionHandler:nil];
            
            [[VSDKAPI shareAPI] vsdk_reportPatFaceDateWithImgID:pmd.img_id WithImgtitle:pmd.img_title WithImgUrl:pmd.img WithType:@"click" Success:^(id responseObject) {
                        
                    } Failure:^(NSString *errorMsg) {
                        
                    }];
        }
        
    }else if ([self.showType isEqualToString:@"level_pic_list"]){
        Level_PatModel *pmd = self.level_show_ListArr[0];
        
        if ([pmd.jump_type isEqualToString:@"game"]) {
            //游戏内处理
            if ([VSDKHelper sharedHelper].PatfaceBlock) {
                [VSDKHelper sharedHelper].PatfaceBlock(pmd.jump_page);
                [SDKENTRANCE resignWindow];
            }
            
        }
        
        NSString *requestUrl = [self connectParameterWithUrl:pmd.link WithImgid:pmd.img_id WithImgtitle:pmd.img_title WithImgurl:pmd.img WithType:pmd.jump_type];
        if ([VSTool isBlankString:pmd.link]) {
            return;
        }
        if ([pmd.jump_type isEqualToString:@"inside"]) {
            
            self.imgV.hidden = YES;
            self.imgWebV.hidden = NO;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
            [self.imgWebV loadRequest:request];
            
            [[VSDKAPI shareAPI] vsdk_reportPatFaceDateWithImgID:pmd.img_id WithImgtitle:pmd.img_title WithImgUrl:pmd.img WithType:@"click" Success:^(id responseObject) {
                        
                    } Failure:^(NSString *errorMsg) {
                        
                    }];
        }else if ([pmd.jump_type isEqualToString:@"outside"]){
            if ([VSTool isBlankString:pmd.link]) {
                return;
            }
//            [[VSDKHelper sharedHelper] vsdk_openWebPageInSafariWithUrl:requestUrl];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:requestUrl] options:@{} completionHandler:nil];
            
            [[VSDKAPI shareAPI] vsdk_reportPatFaceDateWithImgID:pmd.img_id WithImgtitle:pmd.img_title WithImgUrl:pmd.img WithType:@"click" Success:^(id responseObject) {
                        
                    } Failure:^(NSString *errorMsg) {
                        
                    }];
        }
    }
}


//-(NSString *)combinParameterWithPatModel:(Pic_PatModel *)model{
//
//}



-(NSString *)connectParameterWithUrl:(NSString *) urlLink WithImgid:(NSString *)img_id WithImgtitle:(NSString *)img_title WithImgurl:(NSString *)imgurl WithType:(NSString *)type{
    // 初始化参数变量
    NSString *str = @"";
    
    if (![urlLink containsString:@"?"]) {
        urlLink = [NSString stringWithFormat:@"%@%@",urlLink,@"?"];
    }else{
        // 初始化参数变量
        str = @"&";
    }
    NSMutableDictionary * paramDic = [[NSMutableDictionary alloc]initWithDictionary:[VSDeviceHelper combineRequestParams]];
    //添加参数配置
    NSString * roleLevel = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_level");
    NSString * serviceid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_serviceid");
    NSString * roleid = VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid") == nil ? @"":VS_USERDEFAULTS_GETVALUE(@"vsdk_role_roleid");
    [paramDic setValue:VS_CONVERT_TYPE(serviceid) forKey:VSDK_PARAM_SERVER_ID];
    [paramDic setValue:VSDK_GAME_USERID forKey:VSDK_PARAM_USER_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleid) forKey:VSDK_PARAM_ROLE_ID];
    [paramDic setValue:VS_CONVERT_TYPE(roleLevel) forKey:VSDK_PARAM_ROLE_LEVEL];
    [paramDic setValue:img_id forKey:@"img_id"];
    [paramDic setValue:img_title forKey:@"img_title"];
    [paramDic setValue:imgurl forKey:@"img"];
    [paramDic setValue:type forKey:@"type"];
    NSString *token = [[VSDKHelper sharedHelper] vsdk_latestRefreshedLoginToken];
    [paramDic setValue:token forKey:@"token"];
    
  
    // 快速遍历参数数组
    for(id key in paramDic) {
//        NSLog(@"key :%@  value :%@", key, [paramDic objectForKey:key]);
        str = [str stringByAppendingString:key];
        str = [str stringByAppendingString:@"="];
        str = [str stringByAppendingString:[paramDic objectForKey:key]];
        str = [str stringByAppendingString:@"&"];
    }
    // 处理多余的&以及返回含参url
    if (str.length > 1) {
        // 去掉末尾的&
        str = [str substringToIndex:str.length - 1];
        // 返回含参url
        NSString *urlStr = [urlLink stringByAppendingString:str];
        urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        return urlStr;
    }
    return Nil;
}
@end
