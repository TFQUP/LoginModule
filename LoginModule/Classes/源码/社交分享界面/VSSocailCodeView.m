//
//  VSSocailCodeView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSocailCodeView.h"
#import "VSSDKDefine.h"
#import "VSSocialTableViewCell.h"
@interface VSSocailCodeView ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)UIButton * closeBtn;
@property(nonatomic,strong)UIView * indicatorView;
@property(nonatomic,strong)UIView * desView;
@property(nonatomic,strong)UIView * socialBgView;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIButton * shareBtn;
@property(nonatomic,strong)UITextView * textView;
@property(nonatomic,strong)UIView * activeCodeView;
@property(nonatomic,strong)UIView * desInfoView;
@property(nonatomic,strong)UILabel * myCode;
@property(nonatomic,strong)NSMutableArray * likeDataArr;
@property(nonatomic,strong)NSMutableArray * inviteDataArr;
@property(nonatomic,strong)NSMutableArray * shareDataArr;
@property(nonatomic,strong)NSDictionary * infoDic;
@property(nonatomic,strong)UITextField * textField;
@property(nonatomic,strong)UIView * rewardView;
@property(nonatomic,strong)UITableView * likeTableView;
//模块标题数组
@property(nonatomic,strong) NSMutableArray * arr;


@end

@implementation VSSocailCodeView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

-(NSMutableArray *)likeDataArr{
    
    if (!_likeDataArr) {
        
        _likeDataArr = [[self.infoDic objectForKey:@"like_event"]count]>0?[[NSMutableArray alloc]initWithArray:[[self.infoDic objectForKey:@"like_event"]objectForKey:@"list"]]:[[NSMutableArray alloc]init];
    }
    
    return _likeDataArr;
    
}

-(NSMutableArray *)inviteDataArr{
    
    if (!_inviteDataArr) {
        
        _inviteDataArr =   [[self.infoDic objectForKey:@"invite_event"]count]>0?[[NSMutableArray alloc]initWithArray:[[self.infoDic objectForKey:@"invite_event"]objectForKey:@"list"]]:[[NSMutableArray alloc]init];
    }
    
    return _inviteDataArr;
    
}

-(NSMutableArray *)shareDataArr{
    
    if (!_shareDataArr) {
        
        _shareDataArr =   [[self.infoDic objectForKey:@"share_event"]count]>0?[[NSMutableArray alloc]initWithArray:[[self.infoDic objectForKey:@"share_event"]objectForKey:@"list"]]:[[NSMutableArray alloc]init];
    }
    
    return _shareDataArr;
}

-(NSDictionary *)infoDic{
    
    if (!_infoDic) {
        
        _infoDic = [[NSDictionary alloc]initWithDictionary:[VSDeviceHelper preSaveSocialData]];
        
        
    }
    return _infoDic;
    
}



-(void)vsdk_openSocialShareCodePage{
    
    
    
    self.socialBgView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.socialBgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    CGFloat assW = ADJUSTPadAndPhonePortraitW(727);
    CGFloat assH = ADJUSTPadAndPhonePortraitH(614,[VSDeviceHelper getExpansionFactorWithphoneOrPad]);
    
    self.frame =isPad?DEVICEPORTRAIT?CGRectMake(0, 0, assW* 1.3,assH * 1.3):CGRectMake(0, 0, ADJUSTPadAndPhoneW(1187),ADJUSTPadAndPhoneH(991)):DEVICEPORTRAIT?CGRectMake(20, 30, SCREE_WIDTH - 40, (SCREE_WIDTH - 40)/1.2):CGRectMake(20, 30, (SCREE_HEIGHT - 50)*1.2, SCREE_HEIGHT - 50);
    
    self.layer.cornerRadius = 10;
    self.backgroundColor = VS_RGB(242, 244, 245);
    self.center =VS_RootVC.view.center;
    [self.socialBgView addSubview:self];
    
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.closeBtn.frame = isPad?CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(90), ADJUSTPadAndPhoneW(90)):DEVICEPORTRAIT?CGRectMake(self.frame.size.width/2 + self.center.x-30,self.frame.origin.y -30, ADJUSTPadAndPhonePortraitW(70), ADJUSTPadAndPhonePortraitW(70)):CGRectMake(self.frame.size.width/2 + self.center.x + 5,VS_VIEW_TOP(self) + 5, ADJUSTPadAndPhoneW(85), ADJUSTPadAndPhoneW(85));
    
    [self.closeBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeSocailView:) forControlEvents:UIControlEventTouchUpInside];
    [self.socialBgView addSubview:self.closeBtn];
    [VS_RootVC.view addSubview:self.socialBgView];
    
    
    self.arr = [[NSMutableArray alloc]init];
    
    NSArray * modelArr = @[@"like",@"share",@"invite"];
    
    for (int i = 0; i< modelArr.count; i++) {
        
        if ([[[VSDeviceHelper preSaveSocialData]objectForKey:[NSString stringWithFormat:@"%@_event",modelArr[i]]]count] != 0) {
            
            NSString * upString  = [NSString stringWithFormat:@"%@ Gift",[modelArr[i] stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[modelArr[i] substringToIndex:1] capitalizedString]]];
            
            [self.arr addObject:VSLocalString(upString)];
        }
    }
    
    
    for (int i = 0; i < self.arr.count; i++) {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = DEVICEPORTRAIT?CGRectMake(i*(self.frame.size.width)/self.arr.count , 0, (self.frame.size.width)/self.arr.count, 45): CGRectMake(i*(self.frame.size.width)/self.arr.count , 0, (self.frame.size.width)/self.arr.count, 45);
        
        button.tag = 520 + i;
        if (i == 0) {
            
            button.backgroundColor = VSDK_ORANGE_COLOR;
            [button setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
            
        }else{
            
            button.backgroundColor = VS_RGB(242, 244, 245);
            [button setTitleColor:VSDK_LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        }
        
        if (self.arr.count == 1) {
            
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            
        }else if (self.arr.count == 2){
            button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
            
        }else{
            button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        }
        
        
        [button setTitle:self.arr[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        CGRect rect = [button titleRectForContentRect:button.frame];
        UIImageView * tipsImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:kSrcName(@"vsdk_alert")]];
        tipsImageView.frame = CGRectMake(rect.origin.x -10, rect.origin.y+rect.size.height*0.1, rect.size.height* 0.8, rect.size.height *0.8);
        tipsImageView.tag = 10000 + i;
        
        
        if ([self.arr[i] isEqualToString:VSLocalString(@"Like Gift")]) {
            
            if ([self hideTipsViewDependStateWithEvent:@"like"]) {
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                [self addSubview:tipsImageView];
            }
            
        }else if ([self.arr[i] isEqualToString:VSLocalString(@"Share Gift")]){
            
            if ([self hideTipsViewDependStateWithEvent:@"share"]) {
                
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                [self addSubview:tipsImageView];
            }
            
        }else{
            
            if ([self hideTipsViewDependStateWithEvent:@"invite"]) {
                
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
                [self addSubview:tipsImageView];
            }
        }
        
    }
    
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 45, self.frame.size.width, self.frame.size.height - 45)];
    self.scrollView.backgroundColor = VSDK_WHITE_COLOR;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * self.arr.count, self.frame.size.height - 45);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    
    
    for (int i = 0; i < self.arr.count; i++) {
        
        if ([self.arr[i] isEqualToString:VSLocalString(@"Like Gift")]) {
            
            self.likeTableView = [[UITableView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - 90) style:UITableViewStylePlain];
            self.likeTableView.tag = 1314;
            self.likeTableView.backgroundColor = VSDK_WHITE_COLOR;
            self.likeTableView.delegate = self;
            self.likeTableView.dataSource = self;
            self.likeTableView.rowHeight = self.likeTableView.frame.size.height /4;
            self.likeTableView.backgroundColor = VSDK_WHITE_COLOR;
            [self.scrollView addSubview:self.likeTableView];
            
        }else if([self.arr[i] isEqualToString:VSLocalString(@"Share Gift")]){
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - 90)];
            
            if ([[[[self.infoDic objectForKey:@"share_event"]objectForKey:@"list"] firstObject]objectForKey:@"item_event_image"]) {
                [imageView sd_setImageWithURL:[NSURL URLWithString: [[[[self.infoDic objectForKey:@"share_event"]objectForKey:@"list"] firstObject]objectForKey:@"item_event_image"]]];
            }else{
                imageView.image = [UIImage imageNamed:kSrcName(@"vsdk_default_share_bg_image.jpg")] ;
                
            }
            [self.scrollView addSubview:imageView];
            
        }else{
            
            
            UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - 90) style:UITableViewStylePlain];
            tableView.tag = 3344;
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.rowHeight = tableView.frame.size.height /4;
            tableView.backgroundColor = VSDK_WHITE_COLOR;
            [self.scrollView addSubview:tableView];
            
        }
        
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(i*self.frame.size.width, self.frame.size.height - 90, self.frame.size.width, 45)];
        view.backgroundColor =  VSDK_ORANGE_COLOR;
        
        UIButton *desInfoBtn =  [UIButton buttonWithType:UIButtonTypeSystem];
        desInfoBtn.tag = 10 + i;
        if ([[VSDeviceHelper vsdk_systemLanguage]hasPrefix:@"ja"]) {
            desInfoBtn.frame = CGRectMake(view.frame.size.width-85, 8, 90, 25);
        }else{
            desInfoBtn.frame = CGRectMake(view.frame.size.width-70, 8, 90, 25);
        }
        [desInfoBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
        [desInfoBtn setTitle:VSLocalString(@"Rules") forState:UIControlStateNormal];
        desInfoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
        [desInfoBtn sizeToFit];
        [desInfoBtn addTarget:self action:@selector(desInfoClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:desInfoBtn];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(VS_VIEW_LEFT(desInfoBtn) + 1, VS_VIEW_BOTTOM(desInfoBtn) - 5, desInfoBtn.frame.size.width-2, 0.8)];
        lineView.backgroundColor = VSDK_WHITE_COLOR;
        [view addSubview:lineView];
        
        
        if ([self.arr[i] isEqualToString:VSLocalString(@"Like Gift")]) {
            
            UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            likeBtn.frame =  CGRectMake(20, 7.5, 70, 30);
            [likeBtn setTitle:VSLocalString(@"Like") forState:UIControlStateNormal];
            likeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 22, 0, 0);
            [likeBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_facebook_like")] forState:UIControlStateNormal];
            [likeBtn addTarget:self action:@selector(facebookLikeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:likeBtn];
            
        }else if([self.arr[i] isEqualToString:VSLocalString(@"Share Gift")]){
            
            self.shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            self.shareBtn.frame = CGRectMake(self.frame.size.width/2 - 46.5, 5, 93, 35);
            self.shareBtn.titleLabel.numberOfLines = 0;
            self.shareBtn.layer.cornerRadius = 5;
            self.shareBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            if ([[[[[self.infoDic objectForKey:@"share_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_state"] isEqual: @2]) {
                
                [self.shareBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_code_btn_bg")] forState:UIControlStateNormal];
                [self.shareBtn setTitle:[self.shareDataArr[0]objectForKey:@"item_event_gift_code"] forState:UIControlStateNormal];
                [self.shareBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                
                
            }else if([[[[[self.infoDic objectForKey:@"share_event"]objectForKey:@"list"]firstObject]objectForKey:@"item_event_state"]  isEqual: @1]){
                
                [self.shareBtn setTitle:VSLocalString(@"Claim") forState:UIControlStateNormal];
                [self.shareBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                [self.shareBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
                
            }else{
                
                [self.shareBtn setTitle:VSLocalString(@"Share") forState:UIControlStateNormal];
                [self.shareBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_twinkling_blue_btn")] forState:UIControlStateNormal];
                [self.shareBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
            }
            
            [self.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:self.shareBtn];
            
        }else{
            
            UIButton * invitedBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            invitedBtn.hidden = YES;
            if ([[VSDeviceHelper vsdk_systemLanguage]hasPrefix:@"ja"]) {
                invitedBtn.frame = CGRectMake(20, 8, 90, 25);
            }else{
                invitedBtn.frame = CGRectMake(20, 8, 90, 25);
            }
            
            [invitedBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
            [invitedBtn setTitle:VSLocalString(@"Invite Code") forState:UIControlStateNormal];
            invitedBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
            [invitedBtn sizeToFit];
            [invitedBtn addTarget:self action:@selector(invitedBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:invitedBtn];
            
            UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(VS_VIEW_LEFT(invitedBtn) + 1, VS_VIEW_BOTTOM(invitedBtn) - 5, invitedBtn.frame.size.width-2, 0.8)];
            lineView.hidden = YES;
            lineView.backgroundColor = VSDK_WHITE_COLOR;
            [view addSubview:lineView];
            
            if ([self.infoDic objectForKey:@"invite_code"]&&[[self.infoDic objectForKey:@"invite_state"] integerValue] >= 0){
                
                invitedBtn.hidden = NO;
                lineView.hidden = NO;
            }
            
            
            UIButton * inputBtn  = [UIButton buttonWithType:UIButtonTypeSystem];
            [inputBtn setTitle:VSLocalString(@"Invite") forState:UIControlStateNormal];
            if ([[VSDeviceHelper vsdk_systemLanguage]hasPrefix:@"ja"]){
                
                inputBtn.frame =  CGRectMake(self.frame.size.width/2 - 52.5, 5, 105, 35);
                
            }else{
                
                inputBtn.frame =  CGRectMake(self.frame.size.width/2 - 46.5, 5, 93, 35);
                
            }
            [inputBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_code_btn_bg")] forState:UIControlStateNormal];
            [inputBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
            [inputBtn addTarget:self action:@selector(invitationCodeBtnActiuon) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:inputBtn];
            
        }
        
        [self.scrollView addSubview:view];
        
    }
    
    
    [VSDeviceHelper addAnimationInView:self Duration:0.5];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 3344) {
        
        return self.inviteDataArr.count;
        
    }else{
        
        return  self.likeDataArr.count;
        
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag  == 1314) {
        
        static NSString * cellid = @"1314cellid";
        VSSocialTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        if (!cell) {
            
            cell = [[VSSocialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.backgroundColor = VSDK_WHITE_COLOR;
        cell.btnClaim.tag = 100 + indexPath.row;
        [cell.btnClaim addTarget:self action:@selector(claimBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[self.likeDataArr[indexPath.row]objectForKey:@"item_event_state"] isEqual: @2]) {
            [cell.btnClaim setBackgroundImage:[UIImage     imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
            [cell.btnClaim setTitle:[self.likeDataArr[indexPath.row]objectForKey:@"item_event_gift_code"] forState:UIControlStateNormal];
            
            
        }else if([[self.likeDataArr[indexPath.row]objectForKey:@"item_event_state"]  isEqual: @1]){
            [cell.btnClaim setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
            [cell.btnClaim setTitle:VSLocalString(@"Claim") forState:UIControlStateNormal];
        }else{
            [cell.btnClaim setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_gam_unconform_btn_bg") ] forState:UIControlStateNormal];
            [cell.btnClaim setTitle:VSLocalString(@"Undone") forState:UIControlStateNormal];
            cell.btnClaim.userInteractionEnabled = NO;
            [cell.btnClaim setTitleColor:VSDK_GRAY_COLOR  forState:UIControlStateNormal];
        }
        
        [cell.imageIcon sd_setImageWithURL:[NSURL URLWithString:[self.likeDataArr[indexPath.row]objectForKey:@"item_event_image"]]];
        cell.lbShareTitle.text  = [self.likeDataArr[indexPath.row]objectForKey:@"item_event_task"];
        cell.lbShareDetail.text = [self.likeDataArr[indexPath.row]objectForKey:@"item_event_prize"];
        
        return cell;
        
    }else{
        
        static NSString * cellid = @"520cellid";
        VSSocialTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        
        if (!cell) {
            
            cell = [[VSSocialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        }
        cell.backgroundColor = VSDK_WHITE_COLOR;
        cell.btnClaim.tag = 1000 + indexPath.row;
        [cell.btnClaim addTarget:self action:@selector(claimBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[self.inviteDataArr[indexPath.row]objectForKey:@"item_event_state"] isEqual: @2]) {
            
            [cell.btnClaim setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
            [cell.btnClaim setTitle:[self.inviteDataArr[indexPath.row]objectForKey:@"item_event_gift_code"] forState:UIControlStateNormal];
            
        }else if ([[self.inviteDataArr[indexPath.row]objectForKey:@"item_event_state"]  isEqual: @1]){
            
            [cell.btnClaim setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
            [cell.btnClaim setTitle:VSLocalString(@"Claim") forState:UIControlStateNormal];
            
        }else{
            
            [cell.btnClaim setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
            [cell.btnClaim setTitle:[NSString stringWithFormat:@"%@(%@/%@)",VSLocalString(@"Invited"),[self.inviteDataArr[indexPath.row]objectForKey:@"item_event_value"],[self.inviteDataArr[indexPath.row]objectForKey:@"item_event_target"]] forState:UIControlStateNormal];
            
        }
        
        
        if ([cell.btnClaim.titleLabel.text length]>8) {
            
            cell.btnClaim.titleLabel.font = [UIFont systemFontOfSize:10];
            
        }
        
        [cell.imageIcon sd_setImageWithURL:[NSURL URLWithString:[self.inviteDataArr[indexPath.row]objectForKey:@"item_event_image"]]];
        cell.lbShareTitle.text  = [self.inviteDataArr[indexPath.row]objectForKey:@"item_event_task"];
        cell.lbShareTitle.text = [self.inviteDataArr[indexPath.row]objectForKey:@"item_event_prize"];
        
        return cell;
        
    }
}


-(void)claimBtnClickAction:(UIButton *)sender{
    
    //点赞
    if (sender.tag >= 100&&sender.tag < 1000) {
        
        [self getLikeRewardWithClickBtnTag:sender];
    }
    //邀请
    if (sender.tag >= 1000) {
        
        if ([[self.inviteDataArr[sender.tag - 1000]objectForKey:@"item_event_state"] isEqual:@0]) {
            
            [self invitationCodeBtnActiuon];
            
        }else{
            
            [self getinvitedRewardWithClickBtnTag:sender];
            
        }
    }
}


-(void)getLikeRewardWithClickBtnTag:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:VSLocalString(@"Claim")]) {
        
        [[VSDKAPI shareAPI]ssLikeRewardWithEventType:@"like" EventId:[self.likeDataArr[sender.tag -100]objectForKey:@"item_event_id"] EventCert:[self.likeDataArr[sender.tag -100]objectForKey:@"item_event_cert"] Success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                VS_SHOW_SUCCESS_STATUS(@"Claim Successfully");
                
                NSString * likeActiveCodeKey = [NSString stringWithFormat:@"vsdk_like_activeCode_%ld",sender.tag -100];
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"item_event_gift_code"], likeActiveCodeKey);
                
                [sender setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
                [sender setTitle:[GETRESPONSEDATA:@"item_event_gift_code"] forState:UIControlStateNormal];
                
                NSDictionary * dic = self.infoDic ;
                
                [[[dic objectForKey:@"like_event"]objectForKey:@"list"][sender.tag - 100]setValue:@2 forKey:@"item_event_state"];
                
                [dic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];

                if ([self hideTipsViewDependStateWithEvent:@"like"] == NO) {
                    UIImageView * imageView = (UIImageView *)[self viewWithTag:10000];
                    imageView.hidden = YES;
                    UIButton * likePageBtn = (UIButton *)[self viewWithTag:520];
                    likePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                }
                
                
            }else{
                
                VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
            }
            
        } Failure:^(NSString *failure) {
            
        }];
        
    }else{
        
        NSString * likeActiveCodeKey = [NSString stringWithFormat:@"vsdk_like_activeCode_%ld",sender.tag -100];
        NSString * code = [[self.likeDataArr[sender.tag - 100] objectForKey:@"item_event_gift_code"] length] >0?[self.likeDataArr[sender.tag - 100] objectForKey:@"item_event_gift_code"]:VS_USERDEFAULTS_GETVALUE(likeActiveCodeKey);
        
        VS_USERDEFAULTS_SETVALUE(code, @"vsdk_ready_show_code");
        
        [self copyActiveCode];
        
        
    }
    
}

-(void)getinvitedRewardWithClickBtnTag:(UIButton *)sender{
    
    if ([sender.titleLabel.text isEqualToString:VSLocalString(@"Claim")]) {
        
        [[VSDKAPI shareAPI]  ssLikeRewardWithEventType:@"invite" EventId:[self.inviteDataArr[sender.tag -1000]objectForKey:@"item_event_id"] EventCert:[self.inviteDataArr[sender.tag -1000]objectForKey:@"item_event_cert"] Success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                NSString * inviteActiveCodeKey = [NSString stringWithFormat:@"vsdk_invite_activeCode_%ld",sender.tag -1000];
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"item_event_gift_code"], inviteActiveCodeKey);
                
                
                [sender setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
                [sender setTitle:[GETRESPONSEDATA:@"item_event_gift_code"] forState:UIControlStateNormal];
                NSDictionary * dic = self.infoDic ;
                
                [[[dic objectForKey:@"invite_event"]objectForKey:@"list"][sender.tag - 1000]setValue:@2 forKey:@"item_event_state"];
                
                [dic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];
                
                if ([self hideTipsViewDependStateWithEvent:@"invite"] == NO) {
                    
                    if ([self.arr[0] isEqualToString:VSLocalString(@"Invite Gift")]) {
                        
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10000];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:520];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }else if([self.arr[1] isEqualToString:VSLocalString(@"Invite Gift")]){
                                    
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10001];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:521];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }else{
                        
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10002];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:522];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }
                }
                
            }else{
                
                VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
            }
            
        } Failure:^(NSString *failure) {
            
        }];
        
    }else{
        
        NSString * inviteActiveCodeKey = [NSString stringWithFormat:@"vsdk_invite_activeCode_%ld",sender.tag -1000];
        NSString * code = [[self.inviteDataArr[sender.tag - 1000] objectForKey:@"item_event_gift_code"]length]>0?[self.inviteDataArr[sender.tag - 1000] objectForKey:@"item_event_gift_code"]:VS_USERDEFAULTS_GETVALUE(inviteActiveCodeKey);
        
        VS_USERDEFAULTS_SETVALUE(code, @"vsdk_ready_show_code");
        
        [self copyActiveCode];
        
    }
}

/// Facebook点赞接口
/// @param sender 响应的按钮
-(void)facebookLikeBtnAction:(UIButton *)sender{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[VSDKAPI shareAPI]  ssSocialEventReportWithEvent:@"like" Type:@"click"];
        
    });
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[self.infoDic objectForKey:@"fb_like_url"]] options:@{} completionHandler:^(BOOL success) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (![[self.likeDataArr[0]objectForKey:@"item_event_state"]isEqualToNumber:[NSNumber numberWithInteger:2]]) {
                
                for (NSUInteger i = 0; i<self.likeDataArr.count; i++) {
                    
                    NSDictionary * dic = self.likeDataArr[i];
                    
                    if ([[dic objectForKey:@"item_event_target"] isEqual: @1] ) {
                        
                        VSSocialTableViewCell * cell = [self.likeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                        [cell.btnClaim setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
                        [cell.btnClaim setTitle:VSLocalString(@"Claim") forState:UIControlStateNormal];
                        [cell.btnClaim setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                        cell.btnClaim.userInteractionEnabled = YES;
                        [[[self.infoDic objectForKey:@"like_event"]objectForKey:@"list"][0]setValue:@1 forKey:@"item_event_state"];
                        [self.infoDic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];
                        
                    }
                }
            }
            
        });
        
        [[VSDKAPI shareAPI]  ssSocialEventReportWithEvent:@"like" Type:@"complete"];
        
    }];
    
}



/// Facebook分享按钮
/// @param sender 响应的按钮
-(void)shareBtnClick:(UIButton *)sender{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[VSDKAPI shareAPI]  ssSocialEventReportWithEvent:@"share" Type:@"click" ];
        
    });
    
    
    if ([sender.titleLabel.text isEqualToString:VSLocalString(@"Share")]) {
        
        NSString * shareUrl = [NSString stringWithFormat:@"%@&%@",[self.infoDic objectForKey:@"share_url"],[VSDeviceHelper getBasicRequestWithParams:@{VSDK_PARAM_SERVER_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID),VSDK_PARAM_SERVER_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME),VSDK_PARAM_ROLE_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID),VSDK_PARAM_ROLE_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME),VSDK_PARAM_ROLE_LEVEL:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL)}]];
        
        
        [self shareLinkToDiversifiedPaltformWithTitle:[self.infoDic objectForKey:@"share_title"]?[self.infoDic objectForKey:@"share_title"]:VSDK_APP_DISPLAY_NAME Description:[self.infoDic objectForKey:@"share_desc"]?[self.infoDic objectForKey:@"share_desc"]:[NSString stringWithFormat:@"Click to download，Join《%@》and have fun together~",VSDK_APP_DISPLAY_NAME] Url:shareUrl thumbImage:nil linkShareBlock:^(BOOL ifSuccess, id resultInfo, NSError *error) {
            
            if (ifSuccess) {
                
                [[VSDKAPI shareAPI]  ssSocialEventReportWithEvent:@"share" Type:@"complete"];
                [self.shareBtn setTitle:VSLocalString(@"Claim") forState:UIControlStateNormal];
                [self.shareBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                [self.shareBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
                
                NSDictionary * dic = self.infoDic ;
                
                [[[[dic objectForKey:@"share_event"]objectForKey:@"list"]firstObject]setValue:@1 forKey:@"item_event_state"];
                
               [dic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];

                
                if ([self hideTipsViewDependStateWithEvent:@"share"] == NO) {
                    
                    if ([self.arr[0] isEqualToString:VSLocalString(@"Share Gift")]) {
                        
                        
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10000];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:520];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }else{
                        
                        
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10001];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:521];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }
                }
                
                
            }else{
                
                VS_SHOW_ERROR_STATUS(@"Share Failed~");
            }
            
        }];
        
    }else if([sender.titleLabel.text isEqualToString:VSLocalString(@"Claim")]){
        
        [[VSDKAPI shareAPI]  ssLikeRewardWithEventType:@"share" EventId:[[self.shareDataArr firstObject]objectForKey:@"item_event_id"] EventCert:[[self.shareDataArr firstObject]objectForKey:@"item_event_cert"] Success:^(id responseObject) {
            
            if (REQUESTSUCCESS) {
                
                VS_USERDEFAULTS_SETVALUE([GETRESPONSEDATA:@"item_event_gift_code"], @"vsdk_share_activeCode");
                
                VS_SHOW_SUCCESS_STATUS(@"The gift code has been generated, click the gift code to copy.")
                
                [sender setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_code_btn_bg")] forState:UIControlStateNormal];
                [sender setTitle:[GETRESPONSEDATA:@"item_event_gift_code"] forState:UIControlStateNormal];
                [sender setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
                
                NSDictionary * dic = self.infoDic ;
                [[[dic objectForKey:@"share_event"]objectForKey:@"list"][0]setValue:@2 forKey:@"item_event_state"];
                
               [dic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];
                

                if ([self hideTipsViewDependStateWithEvent:@"share"] == NO) {
                    
                    if ([self.arr[0] isEqualToString:VSLocalString(@"Share Gift")]) {

                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10000];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:520];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }else if([self.arr[1] isEqualToString:VSLocalString(@"Share Gift")]){
                        
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10001];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:521];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }else{
                        
                        UIImageView * imageView = (UIImageView *)[self viewWithTag:10002];
                        imageView.hidden = YES;
                        UIButton * sharePageBtn = (UIButton *)[self viewWithTag:522];
                        sharePageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                        
                    }
                }
                
            }else{
                
                VS_SHOW_INFO_MSG(VSDK_MISTAKE_MSG);
            }
            
        } Failure:^(NSString *failure) {
            
        }];
        
    }else {
        
        VS_USERDEFAULTS_SETVALUE([[self.shareDataArr[0] objectForKey:@"item_event_gift_code"]length]>0?[self.shareDataArr[0] objectForKey:@"item_event_gift_code"]:VS_USERDEFAULTS_GETVALUE(@"vsdk_share_activeCode"), @"vsdk_ready_show_code");
        [self copyActiveCode];
        
    }
    
}


-(void)invitedBtnClickAction:(UIButton *)sender{
    
    self.bgView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [VS_RootVC.view addSubview:self.bgView];
    
    self.activeCodeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3.5/5, kiPhone6?self.frame.size.width/1.8:self.frame.size.width/2)];
    self.activeCodeView.backgroundColor = VSDK_WHITE_COLOR;
    self.activeCodeView.layer.cornerRadius = 8;
    self.activeCodeView.center = VS_RootVC.view.center;
    [self.bgView addSubview:self.activeCodeView];
    
    
    UILabel * title = [[UILabel alloc]init];
    [self.activeCodeView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(self.activeCodeView.mas_top);
            make.left.equalTo(self.activeCodeView.mas_left).with.offset(50);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 100, 35));
            
        }else{
            make.top.equalTo(self.activeCodeView.mas_top);
            make.left.equalTo(self.activeCodeView.mas_left).with.offset(50);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 100, 45));
        }
    }];
    
    title.text = VSLocalString(@"Invite Code");
    title.textColor = [UIColor colorWithRed:231/255.0 green:112/255.0 blue:8/255.0 alpha:1];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    
    UIView * lineView = [[UIView alloc]init];
    [self.activeCodeView addSubview:lineView];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(title.mas_bottom);
            make.left.equalTo(self.activeCodeView.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 20, 0.5));
        }else{
            
            make.top.equalTo(title.mas_bottom);
            make.left.equalTo(self.activeCodeView.mas_left).with.offset(20);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 40, 0.5));
        }
        
    }];
    
    lineView.backgroundColor = VSDK_LIGHT_GRAY_COLOR;

    UIButton * closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.activeCodeView addSubview:closebtn];
    
    [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(title.mas_top).with.offset(8);
            make.left.equalTo(title.mas_right).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            
        }else{
            
            make.top.equalTo(title.mas_top).with.offset(10);
            make.left.equalTo(title.mas_right).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            
        }
        
    }];
    [closebtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
    
    [closebtn addTarget:self action:@selector(closeActiveCodeView:) forControlEvents:UIControlEventTouchUpInside];

    
    UILabel * tipsLabel = [[UILabel alloc]init];
    [self.activeCodeView addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(lineView.mas_bottom).with.offset(8);
            make.left.equalTo(lineView.mas_left);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 40, 20));
        }else{
            
            make.top.equalTo(lineView.mas_bottom).with.offset(5);
            make.left.equalTo(lineView.mas_left);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 40, 30));
        }
        
        
    }];
    tipsLabel.textColor = VSDK_LIGHT_GRAY_COLOR;
    tipsLabel.text = VSLocalString(@"Enter friend's invite code to bind to claim gift.");
    tipsLabel.font = [UIFont systemFontOfSize:12];
    
    
    self.textField = [[UITextField alloc]init];
    [self.activeCodeView addSubview:self.textField];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.left.equalTo(tipsLabel.mas_left);
            make.top.equalTo(tipsLabel.mas_bottom).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 85 , 25));
            
        }else{
            
            make.left.equalTo(tipsLabel.mas_left);
            make.top.equalTo(tipsLabel.mas_bottom).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 105 , 28));
            
        }
        
    }];
    self.textField.tintColor = VSDK_LIGHT_GRAY_COLOR;
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    
    if ([[self.infoDic objectForKey:@"invited_code"]length] >0) {
        self.textField.text = [self.infoDic objectForKey:@"invited_code"];
        self.textField.textColor = VSDK_GRAY_COLOR;
    }else{
        
        self.textField.placeholder = VSLocalString(@"Invite Code");
        
    }
    self.textField.delegate = self;
    self.textField.font = [UIFont systemFontOfSize:12];
    
    
    
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keyboardWillShow:)
//                                                name:UIKeyboardWillShowNotification
//                                              object:nil];
//    //监听键盘隐藏
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(keyboardWillHide:)
//                                                name:UIKeyboardWillHideNotification object:nil];
    
    
    UIButton * obtainBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.activeCodeView addSubview:obtainBtn];
    
    [obtainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(self.textField.mas_top).with.offset(1.5);
            make.left.equalTo(self.textField.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(55, 22));
            
            
        }else{
            make.top.equalTo(self.textField.mas_top).with.offset(1.5);
            make.left.equalTo(self.textField.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(55, 25));
            
        }
        
        
    }];
    
    
    obtainBtn.layer.cornerRadius = 5;
    obtainBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [obtainBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    
    if ([[self.infoDic objectForKey:@"invited_code"]length] >0) {
        [obtainBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_gam_received_btn_bg")] forState:UIControlStateNormal];
        obtainBtn.userInteractionEnabled = NO;
        [obtainBtn setTitle:VSLocalString(@"Bound") forState:UIControlStateNormal];
    }else{
        
        [obtainBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_receive_btn_bg")] forState:UIControlStateNormal];
        [obtainBtn setTitle:VSLocalString(@"Claim") forState:UIControlStateNormal];
    }
    
    
    [obtainBtn addTarget:self action:@selector(obtainBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView2 = [[UIView alloc]init];
    [self.activeCodeView addSubview:lineView2];
    
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(obtainBtn.mas_bottom).with.offset(18);
            make.left.equalTo(self.textField.mas_left);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 20, 0.5));
            
        }else{
            
            make.top.equalTo(obtainBtn.mas_bottom).with.offset(23);
            make.left.equalTo(self.textField.mas_left);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 40, 0.5));
            
        }
    }];
    
    lineView2.backgroundColor = VSDK_LIGHT_GRAY_COLOR;
    
    
    UILabel * codeTitle = [[UILabel alloc]init];
    
    [self.activeCodeView addSubview:codeTitle];
    
    [codeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(lineView2.mas_bottom).with.offset(13);
            make.left.equalTo(self.textField.mas_left);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 40 -15, 25));
            
        }else{
            
            
            make.top.equalTo(lineView2.mas_bottom).with.offset(15);
            make.left.equalTo(self.textField.mas_left);
            make.size.mas_equalTo(CGSizeMake(self.activeCodeView.frame.size.width - 40 -15, 28));
            
        }
    }];
    
    codeTitle.text = VSLocalString(@"My Invite Code");
    
    if (DEVICEPORTRAIT) {
        
        codeTitle.font = [UIFont systemFontOfSize:10];
        
    }else{
        
        codeTitle.font = [UIFont systemFontOfSize:12];
        
        
    }
    
    
    self.myCode = [[UILabel alloc]init];
    
    [self.activeCodeView addSubview:self.myCode];
    
    [self.myCode mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(codeTitle.mas_bottom);
            make.left.equalTo(self.textField.mas_left);
            
        }else{
            
            make.top.equalTo(codeTitle.mas_bottom);
            make.left.equalTo(self.textField.mas_left);
        }
    }];
    
    self.myCode.text = [self.infoDic objectForKey:@"invite_code"];
    self.myCode.textColor = [UIColor redColor];
    
    if (DEVICEPORTRAIT) {
        
        self.myCode.font = [UIFont systemFontOfSize:10];
        
    }else{
        
        self.myCode.font = [UIFont systemFontOfSize:12];
        
        
    }
    
    
    UIButton * copyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [self.activeCodeView addSubview:copyBtn];
    
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            
            make.top.equalTo(codeTitle.mas_top).with.offset(1.5);;
            make.right.equalTo(obtainBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(55, 22));
            
        }else{
            
            make.top.equalTo(codeTitle.mas_top).with.offset(1.5);;
            make.right.equalTo(obtainBtn.mas_right);
            make.size.mas_equalTo(CGSizeMake(55, 25));
            
        }
        
        
    }];
    
    [copyBtn setTitle:VSLocalString(@"Copy") forState:UIControlStateNormal];
    copyBtn.layer.cornerRadius = 5;
    copyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [copyBtn setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    [copyBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_code_btn_bg")] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [VSDeviceHelper addAnimationInView:self.activeCodeView Duration:0.5];
    
}

/// 输入邀请码按钮事件
-(void)invitationCodeBtnActiuon{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[VSDKAPI shareAPI]  ssSocialEventReportWithEvent:@"invite" Type:@"click"];
        
    });
    
    NSString * inviteUrl =[[self.infoDic objectForKey:@"invite_code"] length] >0?[[NSString stringWithFormat:@"%@&%@",[self.infoDic objectForKey:@"invite_url"],[VSDeviceHelper getBasicRequestWithParams:@{VSDK_PARAM_SERVER_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID),VSDK_PARAM_SERVER_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME),VSDK_PARAM_ROLE_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID),VSDK_PARAM_ROLE_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME),VSDK_PARAM_ROLE_LEVEL:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL),@"invite_code":[self.infoDic objectForKey:@"invite_code"]}]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]:[[NSString stringWithFormat:@"%@&%@",[self.infoDic objectForKey:@"invite_url"],[VSDeviceHelper getBasicRequestWithParams:@{VSDK_PARAM_SERVER_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_ID),VSDK_PARAM_SERVER_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_SERVER_NAME),VSDK_PARAM_ROLE_ID:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_ID),VSDK_PARAM_ROLE_NAME:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_NAME),VSDK_PARAM_ROLE_LEVEL:VS_USERDEFAULTS_GETVALUE(VSDK_SOCIAL_ROLE_LEVEL)}]]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self shareLinkToDiversifiedPaltformWithTitle:[self.infoDic objectForKey:@"invite_title"]?[self.infoDic objectForKey:@"invite_title"]:VSDK_APP_DISPLAY_NAME Description:[self.infoDic objectForKey:@"invite_desc"]?[self.infoDic objectForKey:@"invite_desc"]:[NSString stringWithFormat:@"Click to download，Join《%@》and have fun together~",VSDK_APP_DISPLAY_NAME] Url:inviteUrl thumbImage:nil linkShareBlock:^(BOOL ifSuccess, id resultInfo, NSError *error) {
        
        if (ifSuccess) {
            
            VS_SHOW_ERROR_STATUS(@"Invitation Sent Successfully");
            [[VSDKAPI shareAPI]  ssSocialEventReportWithEvent:@"invite" Type:@"complete"];
        }else{
            
            VS_SHOW_ERROR_STATUS(@"Invitation Sent Failed");
            
        }
    }];
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.activeCodeView.center = CGPointMake(self.activeCodeView.center.x, self.activeCodeView.center.y - self.activeCodeView.frame.size.height/2);
        
    }];
    
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    [UIView animateWithDuration:0.15 animations:^{
        
        self.activeCodeView.center  = VS_RootVC.view.center;
        
    }];
    
    return YES;
}



//-(void)keyboardWillShow:(NSNotification *)noti{
//    
//    if (DEVICEPORTRAIT) {
//        
//        NSDictionary * info = [noti userInfo];
//        
//        CGRect beginRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//        
//        CGRect endRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
//        
//        float offsety = endRect.origin.y - beginRect.origin.y ;
//        
//        CGRect fileRect = self.activeCodeView.frame;
//        
//        fileRect.origin.y = fileRect.origin.y+offsety + self.activeCodeView.frame.size.height;
//        
//        [UIView animateWithDuration:0.15 animations:^{
//            self.activeCodeView.frame = fileRect;
//        }];
//        
//    }else{
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            
//            self.activeCodeView.frame = DEVICEPORTRAIT?CGRectMake(VS_VIEW_LEFT(self.activeCodeView), 20, self.activeCodeView.frame.size.width, self.activeCodeView.frame.size.height):CGRectMake(VS_VIEW_LEFT(self.activeCodeView), 20, self.activeCodeView.frame.size.width, self.activeCodeView.frame.size.height);
//        }];
//        
//    }
//}
//
//-(void)keyboardWillHide:(NSNotification *)noti{
//    
//    
//    if (DEVICEPORTRAIT) {
//        
//        self.activeCodeView.center  = VS_RootVC.view.center;
//    }else{
//        
//        self.activeCodeView.center  = VS_RootVC.view.center;
//    }
//}

-(void)closeActiveCodeView:(UIButton *)sender{
    
    [self.activeCodeView removeFromSuperview];
    
    [self.bgView removeFromSuperview];
    
}

-(void)obtainBtnClick:(UIButton *)sender{
    
    NSString *pattern = @"[0-9A-Za-z]{8,}";
    
    if (![VSDeviceHelper RegexWithString:self.textField.text pattern:pattern]) {
        
        VS_SHOW_ERROR_STATUS(@"Incorrect invite code. Please enter a valid invite code.")
        
        return;
    }
    
    [self.textField resignFirstResponder];
    
    [[VSDKAPI shareAPI]  ssBindInviteCodeWithInviteCode:self.myCode.text Success:^(id responseObject) {
        
        if (REQUESTSUCCESS) {
            
            VS_SHOW_SUCCESS_STATUS(@"Bound");
            
            [sender setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_gam_received_btn_bg")] forState:UIControlStateNormal];
            [sender setTitle:VSLocalString(@"Bound") forState:UIControlStateNormal];
            
            NSDictionary * dic = self.infoDic ;
            
            [dic setValue:self.textField.text forKey:@"invited_code"];
            
            [dic writeToFile:VS_SOCIALINFO_PLIST_PATH atomically:YES];
            
        }else{
            
            VS_SHOW_INFO_MSG(@"Bind Failed,Please Retry!");
        }
        
    } Failure:^(NSString *failure) {
        
    }];
    
}


-(void)copyBtnClick:(UIButton *)sender{
    
    VS_SHOW_SUCCESS_STATUS(@"Copied");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.myCode.text;
}

/// 活动说明按钮点击事件
/// @param sender 点击的按钮
-(void)desInfoClickAction:(UIButton *)sender{
    
    NSString * ruleString;
    
    if ([self.arr[sender.tag - 10] isEqualToString:VSLocalString(@"Like Gift")]) {
        ruleString = [[self.infoDic objectForKey:@"like_event"]objectForKey:@"desc"];
        
    }else if ([self.arr[sender.tag - 10] isEqualToString:VSLocalString(@"Share Gift")]){
        
        ruleString = [[self.infoDic objectForKey:@"share_event"]objectForKey:@"desc"];
        
    }else{
        
        ruleString = [[self.infoDic objectForKey:@"invite_event"]objectForKey:@"desc"];
    }
    
    self.bgView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [VS_RootVC.view addSubview:self.bgView];
    
    self.desInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3.5/5, kiPhone6?self.frame.size.width/1.9:self.frame.size.width/2.1)];
    self.desInfoView.backgroundColor = VSDK_WHITE_COLOR;
    self.desInfoView.layer.cornerRadius = 8;
    self.desInfoView.center = VS_RootVC.view.center;
    
    [self.bgView addSubview:self.desInfoView];
    
    
    UILabel * title = [[UILabel alloc]init];
    [self.desInfoView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(self.desInfoView.mas_top);
            make.left.equalTo(self.desInfoView.mas_left).with.offset(50);
            make.size.mas_equalTo(CGSizeMake(self.desInfoView.frame.size.width - 100, 35));
            
        }else{
            
            make.top.equalTo(self.desInfoView.mas_top);
            make.left.equalTo(self.desInfoView.mas_left).with.offset(50);
            make.size.mas_equalTo(CGSizeMake(self.desInfoView.frame.size.width - 100, 45));
            
        }
    }];
    
    title.text =VSLocalString(@"Rules");
    title.textColor = [UIColor colorWithRed:231/255.0 green:112/255.0 blue:8/255.0 alpha:1];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    
    UIButton * closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.desInfoView addSubview:closebtn];
    
    [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(title.mas_top).with.offset(8);
            make.left.equalTo(title.mas_right).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            
        }else{
            
            make.top.equalTo(title.mas_top).with.offset(10);
            make.left.equalTo(title.mas_right).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            
        }
        
    }];
    
    [closebtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
    [closebtn addTarget:self action:@selector(closeActiveCodeView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView = [[UIView alloc]init];
    [self.desInfoView addSubview:lineView];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(title.mas_bottom);
        make.left.equalTo(self.desInfoView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(self.desInfoView.frame.size.width - 20, 0.5));
    }];
    
    lineView.backgroundColor = VSDK_LIGHT_GRAY_COLOR;
    
    
    UITextView * desTextView = [[UITextView alloc]init];
    
    [self.desInfoView addSubview:desTextView];
    
    [desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineView.mas_left);
        make.top.equalTo(lineView.mas_bottom).with.offset(0);
        make.right.equalTo(lineView.mas_right);
        make.bottom.equalTo(self.desInfoView.mas_bottom).with.offset(-20);
    }];
    desTextView.backgroundColor = VSDK_WHITE_COLOR;
    desTextView.textColor = VSDK_LIGHT_GRAY_COLOR;
    desTextView.text = ruleString;
    desTextView.textAlignment = NSTextAlignmentLeft;
    desTextView.font = [UIFont systemFontOfSize:13];
    desTextView.editable = NO;
    
    [VSDeviceHelper addAnimationInView:self.desInfoView Duration:0.5];
    
}


/// 展示活动说明的View
/// @param tag 点击活动说明的按钮的标识
-(void)showDesIndfoViewWithTag:(NSUInteger)tag{
    
    NSArray * arr = @[[[self.infoDic objectForKey:@"like_event"]objectForKey:@"desc"],[[self.infoDic objectForKey:@"share_event"]objectForKey:@"desc"],[[self.infoDic objectForKey:@"invite_event"]objectForKey:@"desc"]];
    
    self.bgView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [VS_RootVC.view addSubview:self.bgView];
    
    self.desInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3.5/5, kiPhone6?self.frame.size.width/1.9:self.frame.size.width/2.1)];
    self.desInfoView.backgroundColor = VSDK_WHITE_COLOR;
    self.desInfoView.layer.cornerRadius = 8;
    self.desInfoView.center = VS_RootVC.view.center;
    
    [self.bgView addSubview:self.desInfoView];
    
    
    UILabel * title = [[UILabel alloc]init];
    [self.desInfoView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(self.desInfoView.mas_top);
            make.left.equalTo(self.desInfoView.mas_left).with.offset(50);
            make.size.mas_equalTo(CGSizeMake(self.desInfoView.frame.size.width - 100, 35));
            
        }else{
            
            make.top.equalTo(self.desInfoView.mas_top);
            make.left.equalTo(self.desInfoView.mas_left).with.offset(50);
            make.size.mas_equalTo(CGSizeMake(self.desInfoView.frame.size.width - 100, 45));
            
        }
    }];
    
    title.text =VSLocalString(@"Rules");
    title.textColor = [UIColor colorWithRed:231/255.0 green:112/255.0 blue:8/255.0 alpha:1];
    title.font = [UIFont systemFontOfSize:16];
    title.textAlignment = NSTextAlignmentCenter;
    
    UIButton * closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.desInfoView addSubview:closebtn];
    
    [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (DEVICEPORTRAIT) {
            
            make.top.equalTo(title.mas_top).with.offset(8);
            make.left.equalTo(title.mas_right).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(18, 18));
            
        }else{
            
            make.top.equalTo(title.mas_top).with.offset(10);
            make.left.equalTo(title.mas_right).with.offset(14);
            make.size.mas_equalTo(CGSizeMake(22, 22));
            
        }
        
    }];
    
    [closebtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
    [closebtn addTarget:self action:@selector(closeActiveCodeView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView = [[UIView alloc]init];
    [self.desInfoView addSubview:lineView];
    
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(title.mas_bottom);
        make.left.equalTo(self.desInfoView.mas_left).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(self.desInfoView.frame.size.width - 20, 0.5));
    }];
    
    lineView.backgroundColor = VSDK_LIGHT_GRAY_COLOR;
    
    
    UITextView * desTextView = [[UITextView alloc]init];
    
    [self.desInfoView addSubview:desTextView];
    
    [desTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lineView.mas_left);
        make.top.equalTo(lineView.mas_bottom).with.offset(0);
        make.right.equalTo(lineView.mas_right);
        make.bottom.equalTo(self.desInfoView.mas_bottom).with.offset(-20);
    }];
    desTextView.backgroundColor = VSDK_WHITE_COLOR;
    desTextView.textColor = VSDK_LIGHT_GRAY_COLOR;
    desTextView.text = arr[tag -10];
    desTextView.textAlignment = NSTextAlignmentLeft;
    desTextView.font = [UIFont systemFontOfSize:13];
    desTextView.editable = NO;
    
    [VSDeviceHelper addAnimationInView:self.desInfoView Duration:0.5];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    VSSocialTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self showRewardDetailsWithCell:cell];
    
}


-(void)showRewardDetailsWithCell:(VSSocialTableViewCell *)cell{
    
    self.bgView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.bgView addSubview:self.rewardView];
    [VS_RootVC.view addSubview:self.bgView];
    
    
    UIView * titleBgView = [[UIView alloc]init];
    [self.rewardView addSubview:titleBgView];
    
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.rewardView);
        make.height.equalTo(@35);
        
    }];
    
    titleBgView.backgroundColor = VS_RGB(245, 246, 247);
    
    UIButton * closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [titleBgView addSubview:closebtn];
    
    [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.rewardView.mas_top).with.offset(3);
        make.right.equalTo(self.rewardView.mas_right).with.offset(-5);
        make.size.mas_equalTo(CGSizeMake(28, 28));
        
    }];
    
    [closebtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
    [closebtn addTarget:self action:@selector(closeView:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * detailTitle = [[UILabel alloc]init];
    [titleBgView addSubview: detailTitle];
    [detailTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rewardView.mas_top).with.offset(0);
        make.left.equalTo(self.rewardView.mas_left).with.offset(40);
        make.right.equalTo(self.rewardView.mas_right).with.offset(-40);
        make.bottom.equalTo(closebtn.mas_bottom).with.offset(5);
    }];
    
    detailTitle.text = VSLocalString(@"Reward");
    detailTitle.textAlignment = NSTextAlignmentCenter;
    detailTitle.textColor = VSDK_ORANGE_COLOR;
    detailTitle.font = [UIFont boldSystemFontOfSize:18];
    
    UITextView * textView = [[UITextView alloc]init];
    [self.rewardView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(detailTitle.mas_bottom).with.offset(10);
        make.left.equalTo(self.rewardView.mas_left).with.offset(10);
        make.right.equalTo(self.rewardView.mas_right).with.offset(-10);
        make.bottom.equalTo(self.rewardView.mas_bottom).with.offset(-10);
    }];
    textView.backgroundColor = VSDK_WHITE_COLOR;
    textView.textColor = VSDK_GRAY_COLOR;
    textView.text = cell.lbShareDetail.text;
    textView.font = [UIFont systemFontOfSize:15];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.contentMode = UIViewContentModeCenter;
    textView.editable = NO;
}

-(void)copyActiveCode{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string =VS_USERDEFAULTS_GETVALUE(@"vsdk_ready_show_code");
    VS_SHOW_SUCCESS_STATUS(VSLocalString(@"Copy successfully,Please go to the game to redeem"));
}


-(UIView *)rewardView{
    
    if (!_rewardView) {
        
        _rewardView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width-20, self.frame.size.height/3)];
        _rewardView.backgroundColor = VSDK_WHITE_COLOR;
        _rewardView.layer.cornerRadius = 5;
        _rewardView.center = VS_RootVC.view .center;
        
        [VSDeviceHelper addAnimationInView:_rewardView Duration:0.5];
        
    }
    return _rewardView;
}


-(void)closeView:(UIButton *)sender{
    
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    [self.rewardView removeFromSuperview];
    self.rewardView = nil;
    
}

-(void)closeSocailView:(UIButton *)sender{
    
    [self.socialBgView removeFromSuperview];
    [self removeFromSuperview];
}


-(void)closeDesView:(UIButton *)sender{
    
    [self.desView removeFromSuperview];
    [self.bgView removeFromSuperview];
}


-(void)btnClick:(UIButton *)sender{
    
    for (UIView * view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton * btn = (UIButton *)view;
            btn.selected = NO;
            btn.backgroundColor = VS_RGB(242, 244, 245);
            [btn setTitleColor:VSDK_LIGHT_GRAY_COLOR forState:UIControlStateNormal];
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.scrollView.contentOffset = CGPointMake((sender.tag -520) * self.frame.size.width, 0);
    }];
    
    
    sender.selected = YES;
    
    sender.backgroundColor = VSDK_ORANGE_COLOR;
    [sender setTitleColor:VSDK_WHITE_COLOR forState:UIControlStateNormal];
    
}

#pragma mark -- 判断Alert是否显示
-(BOOL)hideTipsViewDependStateWithEvent:(NSString *)event{
    
    NSArray * list = [[self.infoDic  objectForKey:[NSString stringWithFormat:@"%@_event",event]]objectForKey:@"list"];
    
    NSString * str = @"";
    
    for (NSDictionary * dic in list) {
        
        str = [str stringByAppendingFormat:@"%@",[dic objectForKey:@"item_event_state"]];
        
    }
    
    if ([str rangeOfString:@"1"].location == NSNotFound) {
        
        return NO;
    }else{
        
        return YES;
    }
}

-(void)shareLinkToDiversifiedPaltformWithTitle:(NSString *)title Description:(NSString *)descr Url:(NSString *)url thumbImage:(UIImage *)image linkShareBlock:(void (^)(BOOL ifSuccess,id resultInfo,NSError * error))block{
    
    VSShareView *shareView = [[VSShareView alloc] init];
    VSShareModel *shareModel = [[VSShareModel alloc] init];
    shareModel.title = title;
    shareModel.url = url;
    shareModel.descr = descr;
    shareModel.thumbImage = image;
    
    [shareView vsdk_showShareViewWithModel:shareModel shareContentType:VSShareContentTypeLink shareResult:^(BOOL ifSuceess, id resultInfo, NSError *error) {
        
        block(ifSuceess,  resultInfo, error);
        
    }];
    
}

-(void)shareTextToDiversifiedPaltformWithText:(NSString *)text textShareBlock:(void (^)(BOOL ifSuccess,id resultInfo,NSError * error))block{
    
    VSShareView *shareView = [[VSShareView alloc] init];
    VSShareModel *shareModel = [[VSShareModel alloc] init];
    shareModel.title = text;
    [shareView vsdk_showShareViewWithModel:shareModel shareContentType:VSShareContentTypeText shareResult:^(BOOL ifSuceess, id resultInfo, NSError *error) {
        
        block(ifSuceess,  resultInfo, error);
        
    }];
}


-(void)shareImageToDiversifiedPaltformWithImage:(UIImage *)image ImageShareBlock:(void (^)(BOOL ifSuccess,id resultInfo,NSError * error))block{
    
    VSShareView *shareView = [[VSShareView alloc] init];
    VSShareModel *shareModel = [[VSShareModel alloc] init];
    shareModel.thumbImage = image;
    [shareView vsdk_showShareViewWithModel:shareModel shareContentType:VSShareContentTypeImage shareResult:^(BOOL ifSuceess, id resultInfo, NSError *error) {
        
        block(ifSuceess,  resultInfo, error);
        
    }];
}


-(void)shareVideoToDiversifiedPaltformWithTitle:(NSString *)title  videoShareBlock:(void (^)(BOOL ifSuccess,id resultInfo,NSError * error))block{
    
    VSShareView *shareView = [[VSShareView alloc] init];
    VSShareModel *shareModel = [[VSShareModel alloc] init];
    shareModel.title = title;
    [shareView vsdk_showShareViewWithModel:shareModel shareContentType:VSShareContentTypeVideo shareResult:^(BOOL ifSuceess, id resultInfo, NSError *error) {
        block(ifSuceess,  resultInfo, error);
    }];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
