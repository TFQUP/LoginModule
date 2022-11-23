//
//  VSAutoLoginView.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSAutoLoginView.h"
#import "WriteeVC.h"
#import "SDKENTRANCE.h"
@interface VSAutoLoginView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView * myTable;
@property (nonatomic,strong)NSMutableArray * arr;

@end
@implementation VSAutoLoginView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 10;
        [self layOutAutoLoginViews];
        
    }
    
    return self;
}

-(void)layOutAutoLoginViews{
    
    self.imageAvatar = [VSWidget imageViewWithFrame:CGRectMake(18, 10,self.frame.size.width/4 * 0.42, self.frame.size.width/4 * 0.46) imageName:@"vsdk_binding_account"];
    [self addSubview:self.imageAvatar];

    
    self.lbWelcome = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(VS_VIEW_RIGHT(self.imageAvatar) + 15, 10, ADJUSTPadAndPhonePortraitW(351), ADJUSTPadAndPhonePortraitH(46.4,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(VS_VIEW_RIGHT(self.imageAvatar) + 15, 10, ADJUSTPadAndPhoneW(400), ADJUSTPadAndPhoneH(60)) Text:VSLocalString(@"Welcome,") Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(40.4): ADJUSTPadAndPhoneW(60) TextColor:VSDK_LIGHT_GRAY_COLOR NumberOfLines:1 TextAlignment:NSTextAlignmentNatural];
    
    [self addSubview:self.lbWelcome];
    
    
    self.lbPlayerName = [VSWidget labelWithFrame:DEVICEPORTRAIT?CGRectMake(VS_VIEW_RIGHT(self.imageAvatar) + 15, VS_VIEW_BOTTOM(self.lbWelcome) +5, ADJUSTPadAndPhonePortraitW(450), ADJUSTPadAndPhonePortraitH(43.8,[VSDeviceHelper getExpansionFactorWithphoneOrPad])): CGRectMake(VS_VIEW_RIGHT(self.imageAvatar) + 15, VS_VIEW_BOTTOM(self.lbWelcome) + 5, ADJUSTPadAndPhoneW(500), ADJUSTPadAndPhoneH(55)) Text:nil Font:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(35): ADJUSTPadAndPhoneW(46) TextColor:VSDK_LIGHT_GRAY_COLOR NumberOfLines:1 TextAlignment:NSTextAlignmentNatural];
    
    [self addSubview:self.lbPlayerName];
    
    self.btnSwitch = [VSSwitchBtn buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.btnSwitch];
    
    [self.btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(17);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.bottom.equalTo(self.lbPlayerName.mas_bottom);

    }];
    
    [self.btnSwitch setTitle:VSLocalString(@"Switch")forState:UIControlStateNormal];
    [self.btnSwitch setImage:[[UIImage imageNamed:kSrcName(@"vsdk_switch")] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.btnSwitch.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.btnSwitch sizeToFit];
    [self.btnSwitch setTitleColor:VSDK_GRAY_COLOR forState:UIControlStateNormal];
    [self.btnSwitch addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
  
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, VS_VIEW_BOTTOM(self.lbPlayerName) + 10, self.frame.size.width, 0.3)];
    
    lineView.backgroundColor = VSDK_GRAY_COLOR;
    
    [self addSubview:lineView];
    
    
    NSMutableDictionary * useDic = [VSDeviceHelper plarformAvailable];

    NSMutableArray * aviPaltform = [[NSMutableArray alloc]init];
     
     for (NSString * key in useDic) {
        
         if ([[useDic objectForKey:key]isEqualToNumber:[NSNumber numberWithInt:1]]) {
             
             [aviPaltform addObject:key];
         }
     }
    
    [self.arr addObject:VSLocalString(@"Delete Account")];
    
     [self.arr addObject:VSLocalString(@"Account Binding")];
    
    if (@available(iOS 13.0, *)) {
        
        [self.arr addObject:VSLocalString(@"Apple Binding")];
    }
    
    if ([aviPaltform containsObject:VSDK_FACEBOOK]) {
        [self.arr addObject:VSLocalString(@"Facebook Binding")];
    }
    
    if ([aviPaltform containsObject:VSDK_GOOGLE]) {
        [self.arr addObject:VSLocalString(@"Google Binding")];
    }

    if ([aviPaltform containsObject:VSDK_TWITTER]) {
        [self.arr addObject:VSLocalString(@"Twitter Binding")];
    }
    
    
    
    self.btnContinue = [UIButton buttonWithType:UIButtonTypeSystem];
    [self addSubview:self.btnContinue];
    
    [self.btnContinue mas_makeConstraints:^(MASConstraintMaker *make) {
        if (DEVICEPORTRAIT) {
        make.left.equalTo(self.mas_left).with.offset(ADJUSTPadAndPhonePortraitW(38.5));
        make.bottom.equalTo(self.mas_bottom).with.offset(-15);
        make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhonePortraitW(823), ADJUSTPadAndPhonePortraitH(95,[VSDeviceHelper getExpansionFactorWithphoneOrPad])));
        }else{
        
            make.left.equalTo(self.mas_left).with.offset(ADJUSTPadAndPhoneW(43));
            make.bottom.equalTo(self.mas_bottom).with.offset(-15);
            make.size.mas_equalTo(CGSizeMake(ADJUSTPadAndPhoneW(938), ADJUSTPadAndPhoneH(120)));
        }
    }];
    
    self.btnContinue.backgroundColor = VS_RGB(5, 51, 101);
    [self.btnContinue setTitle:VSLocalString(@"Continue") forState:UIControlStateNormal];
    [self.btnContinue setTitleColor:VSDK_WHITE_COLOR  forState:UIControlStateNormal];
    self.btnContinue.layer.cornerRadius = 5;
    self.btnContinue.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.btnContinue.titleLabel.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(46): ADJUSTPadAndPhoneW(60)];
    [self.btnContinue addTarget:self action:@selector(continueToGameAction:) forControlEvents:UIControlEventTouchUpInside];
    
     self.labelDes = [[UILabel alloc]init];
     [self addSubview:self.labelDes];
     
     [self.labelDes mas_makeConstraints:^(MASConstraintMaker *make) {
          if (DEVICEPORTRAIT) {
              make.left.equalTo(self.btnContinue);
              make.bottom.equalTo(self.btnContinue.mas_top).with.offset(-5);
                make.width.equalTo(@(ADJUSTPadAndPhonePortraitW(823)));
            }else{
            
                make.left.equalTo(self.btnContinue);
                make.bottom.equalTo(self.btnContinue.mas_top).with.offset(-5);
                make.width.equalTo(@(ADJUSTPadAndPhoneW(938)));
            }
     }];
    
    self.labelDes.text =VSLocalString(@"Binding Account Can Keep Your Game Data Safe.");
    [self.labelDes sizeToFit];
    self.labelDes.textColor = VSDK_LIGHT_GRAY_COLOR;
    self.labelDes.font = [UIFont systemFontOfSize:DEVICEPORTRAIT?ADJUSTPadAndPhonePortraitW(38.5): ADJUSTPadAndPhoneW(44)];
    self.labelDes.textAlignment = NSTextAlignmentCenter;
    self.labelDes.numberOfLines = 0;

    
    self.myTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.myTable];
    
    
    [self.myTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.labelDes.mas_top).with.offset(-5);
        make.top.equalTo(lineView.mas_bottom);

    }];
    
    [self.myTable layoutIfNeeded];
    self.myTable.rowHeight = self.arr.count>4?self.myTable.frame.size.height/4:self.myTable.frame.size.height/self.arr.count;
    self.myTable.dataSource =self;
    self.myTable.delegate = self;
    
    [VSDeviceHelper addAnimationInView:self Duration:0.6];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.arr.count;
}

-(NSMutableArray *)arr{
    
    if (!_arr) {
        
        _arr = [[NSMutableArray alloc]init];
          
    }
    return _arr;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cellID = @"cell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (indexPath.row == 0) {
        
        UIImageView * imageView = [VSWidget imageViewWithFrame:CGRectMake(cell.frame.size.width - 25,7,10,14) imageName:@"vsdk_binding_goto"];
        cell.accessoryView = imageView;
        
    }else{
        UIImageView * imageView = [VSWidget imageViewWithFrame:CGRectMake(cell.frame.size.width - 25,7,10,14) imageName:@"vsdk_binding_goweb"];
        cell.accessoryView = imageView;
        
    }
    
    cell.textLabel.text  = self.arr[indexPath.row];
    
    if (DEVICEPORTRAIT) {
        
        cell.textLabel.font = [UIFont systemFontOfSize:(15 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?padScreenAdjudtPortraitW:screenAdjudtPortraitW))];
    }else{
     
        cell.textLabel.font = [UIFont systemFontOfSize:(15 * (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad?padScreenAdjudtW:screenAdjudtW))];
        
    }

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.textLabel.text rangeOfString:VSLocalString(@"Account Binding")].location != NSNotFound) {
        if (self.bindViewBlock) {
                  self.bindViewBlock(VSBindAccountBlockPlatform);
              }
    }
    
    if ([cell.textLabel.text rangeOfString:@"Apple"].location != NSNotFound) {
         if (self.bindViewBlock) {
                   self.bindViewBlock(VSBindAccountBlockApple);
               }
     }
    
    if ([cell.textLabel.text rangeOfString:@"Facebook"].location != NSNotFound) {
        if (self.bindViewBlock) {
                   self.bindViewBlock(VSBindAccountBlockFacebook);
               }
               
    }
    if ([cell.textLabel.text rangeOfString:@"Google"].location != NSNotFound) {
        if (self.bindViewBlock) {
              self.bindViewBlock(VSBindAccountBlockGoogle);
          }
    }
    if ([cell.textLabel.text rangeOfString:@"Twitter"].location != NSNotFound) {
        if (self.bindViewBlock) {
                   self.bindViewBlock(VSBindAccountBlockTwitter);
               }
    }
    if ([cell.textLabel.text rangeOfString:VSLocalString(@"Delete Account")].location != NSNotFound) {
        //不显示当前页面
        self.hidden = YES;
        __weak typeof(self) ws = self;
//        [[VSDKHelper sharedHelper] vsdk_delectUserAccount];
        
        [VSDKHelper sharedHelper].Ablock = ^{
            [SDKENTRANCE resignWindow];
            [ws switchBtnAction:nil];
        };
        
        [VSDKHelper sharedHelper].Bblock = ^{
            [SDKENTRANCE resignWindow];
            [ws switchBtnAction:nil];
        };
        
        VSDelAccontView * delCount = [[VSDelAccontView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
        delCount.center = VS_RootVC.view.center;
        [VS_RootVC.view addSubview:delCount];
        
        delCount.closeBlock = ^{
            [ws switchBtnAction:nil];
        };
        
        
        
//        WriteeVC *writevc = [[WriteeVC alloc] init];
//        [SDKENTRANCE showViewController:writevc];
//        __weak typeof(self) ws = self;
//        writevc.consumV.cancelBlock = ^{
//            [SDKENTRANCE resignWindow];
//            [ws switchBtnAction:nil];
//        };
//        writevc.verifyV.vcloseBlock = ^{
//            [SDKENTRANCE resignWindow];
//            [ws switchBtnAction:nil];
//        };
        
    }
 

}


-(void)switchBtnAction:(UIButton *)button{
    
    if (self.bindViewBlock) {
        self.bindViewBlock(VSBindAccountBlockSwitch);
    }
}


/**
 继续游戏按钮
 
 @param button 按钮事件
 */
-(void)continueToGameAction:(UIButton *)button{
    
    if (self.bindViewBlock) {
        self.bindViewBlock(VSBindAccountBlockContinue);
    }

}

-(void)BindViewBlock:(VSAutoLoginViewBlock)block{
    
    self.bindViewBlock = block;
}



@end
