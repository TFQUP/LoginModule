//
//  VSShareView.m
//  VSDK
//
//  Created by admin on 7/2/21.


#import "VSShareView.h"
#import "VSShareButton.h"
#import "VSSharePlatform.h"
#import "VSSDKDefine.h"

static NSString * FbShareType;
static CGFloat const VSShreButtonHeight = 65.f;
static CGFloat const VSShreButtonWith = 51.f;
static CGFloat const VSShreHeightSpace = 15.f;//竖间距
static NSString * shareType;

@interface VSShareView()<UIGestureRecognizerDelegate,FBSDKSharingDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//底部view
@property (nonatomic,strong) UIView * bottomPopView;
@property (nonatomic,strong) NSMutableArray * platformArray;
@property (nonatomic,strong) NSMutableArray * buttonArray;
@property (nonatomic,strong) VSShareModel * shareModel;
@property (nonatomic,assign) VSShareContentType shareConentType;
@property (nonatomic,assign) CGFloat shreViewHeight;//分享视图的高度
@property (nonatomic,copy)void(^shareResult)(BOOL ifSuceess, id resultInfo ,NSError * error);

@property (nonatomic,strong)UIImagePickerController * pick;

@end

@implementation VSShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)vsdk_showShareViewWithModel:(VSShareModel*)shareModel shareContentType:(VSShareContentType)shareContentType shareResult:(void (^)(BOOL ifSuceess, id resultInfo, NSError * error))result{
    
    self.shareResult = result;
    self.shareModel = shareModel;
    self.shareConentType = shareContentType;
    
#pragma mark -- 根据分享类型来设置分享的平台
    [self vsdk_setUpSharePlatFormWithConentType];
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self];
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [VSDK_BLACK_COLOR colorWithAlphaComponent:.4f];
        self.bottomPopView.frame = CGRectMake(15, SCREE_HEIGHT - self.shreViewHeight-30, SCREE_WIDTH-30, self.shreViewHeight);
    }];
}

-(void)vsdk_setUpSharePlatFormWithConentType{
    
    self.platformArray = [NSMutableArray array];
    self.buttonArray = [NSMutableArray array];
    
    //初始化分享平台
    [self vsdk_setUpPlatformsItems];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    tapGestureRecognizer.delegate = self;
    [tapGestureRecognizer addTarget:self action:@selector(vsdk_closeShareView)];
    
    [self addGestureRecognizer:tapGestureRecognizer];
    
    //计算分享视图的总高度
    self.shreViewHeight = VSShreHeightSpace * 2 + VSShreButtonHeight;
    
    NSInteger columnCount = self.platformArray.count;
    //计算间隙
    CGFloat appMargin = (SCREE_WIDTH-columnCount*VSShreButtonWith)/(columnCount+8);
    
    for (int i=0; i<self.platformArray.count; i++) {
        VSSharePlatform * platform = self.platformArray[i];
        //计算列号和行号
        int colX=i%columnCount;
        int rowY=i/columnCount;
        //计算坐标
        CGFloat buttonX = appMargin+colX*(VSShreButtonWith+appMargin);
        CGFloat buttonY = VSShreHeightSpace+rowY*(VSShreButtonHeight+VSShreHeightSpace);
        VSShareButton *shareBut = [[VSShareButton alloc] init];
        [shareBut setTitle:platform.name forState:UIControlStateNormal];
        [shareBut setImage:[UIImage imageNamed:platform.iconStateNormal] forState:UIControlStateNormal];
        [shareBut addTarget:self action:@selector(clickShare:) forControlEvents:UIControlEventTouchUpInside];
        shareBut.tag = platform.sharePlatform;//这句话必须写！！！
        [self.bottomPopView addSubview:shareBut];
        shareBut.frame = CGRectMake(buttonX, buttonY, VSShreButtonWith, VSShreButtonHeight);
        [self.bottomPopView addSubview:shareBut];
        [self.buttonArray addObject:shareBut];
        
    }
    
    //按钮动画
    for (VSShareButton *button in self.buttonArray) {
        NSInteger idx = [self.buttonArray indexOfObject:button];
        
        CGAffineTransform fromTransform = CGAffineTransformMakeTranslation(0, 50);
        button.transform = fromTransform;
        button.alpha = 0.3;
        
        [UIView animateWithDuration:0.9+idx*0.1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            button.transform = CGAffineTransformIdentity;
            button.alpha = 1;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    [self addSubview:self.bottomPopView];

}


#pragma mark - 点击了分享按钮
-(void)clickShare:(UIButton *)sender{
    
    switch (sender.tag) {
        case VSShareTypeFacebook:
        {
            [self shareLinkToPlatform:VSPlatformTypeFacebook shareConentType:self.shareConentType];
        }
            break;
            
            
        case VSShareTypeTwitter:
        {
            
            [self shareLinkToPlatform:VSPlatformTypeTwitter shareConentType:self.shareConentType];
        }
            break;
            
        case VSShareTypeMore:{
            
            [self shareLinkToPlatform:VSPlatformTypeMore shareConentType:self.shareConentType];
            
        }
            break;
            
        default:
            break;
    }
    
    [self vsdk_closeShareView];
}


-(void)shareLinkToPlatform:(VSPlatformType)platfromType shareConentType:(VSShareContentType)shareConentType{
    
    switch (shareConentType) {
            
        case VSShareContentTypeText:
            
            if (platfromType == VSPlatformTypeTwitter) {}else{
            
                [self shareWithActivityItems:@[self.shareModel.title]];
                
            }
            
            break;
        case VSShareContentTypeImage:
            
            
            if (platfromType == VSPlatformTypeTwitter) {}else if (platfromType == VSPlatformTypeFacebook){
                
                FbShareType = FB_TYPE_SHAREPHOTO;
                [[VSDKAPI shareAPI] vsdk_beatPointWithType:FbShareType state:SHARE_CALL];
                FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] initWithImage:self.shareModel.thumbImage isUserGenerated:YES];
                FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
                content.photos = @[photo];
                [FBSDKShareDialog showFromViewController:[[[UIApplication sharedApplication] windows] objectAtIndex:0].rootViewController withContent:content delegate:self];

            }else{
                
                [self shareWithActivityItems: @[self.shareModel.thumbImage]];
            }
            
            break;
            
        case VSShareContentTypeLink:
            
            if (platfromType == VSPlatformTypeFacebook) {
                
                FbShareType = FB_TYPE_SHARELINK;
                [[VSDKAPI shareAPI] vsdk_beatPointWithType:FbShareType state:SHARE_CALL];
                FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
                //编码防止中文的出现
                
                NSString * shareLink = [NSString stringWithFormat:@"%@&share_type=%@",self.shareModel.url,VSDK_FACEBOOK];
                
                NSString * UTF8string = [shareLink stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                content.contentURL = [NSURL URLWithString:UTF8string];
                content.quote = self.shareModel.title;// 引文分享 用户可删除
                content.hashtag = [[FBSDKHashtag alloc]initWithString:self.shareModel.descr];
                [FBSDKShareDialog showFromViewController:[[[UIApplication sharedApplication] windows] objectAtIndex:0].rootViewController withContent:content delegate:self];
                
            }else if (platfromType == VSPlatformTypeTwitter){}else{
                
               NSURL * url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@&share_type=%@",self.shareModel.url,@"native"]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [self shareWithActivityItems: @[self.shareModel.title,self.shareModel.description,url]];
            }
            
            break;
            
        case VSShareContentTypeVideo:
            
            if (platfromType == VSPlatformTypeFacebook){
                
                FbShareType = FB_TYPE_SHAREVIDEO;
                [[VSDKAPI shareAPI] vsdk_beatPointWithType:FbShareType state:SHARE_CALL];
                
                shareType = VSDK_FACEBOOK;
                _pick = [[UIImagePickerController alloc]init];
                NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
                _pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType1,nil];
                [_pick setMediaTypes: arrMediaTypes];
                _pick.delegate = self;
                [VS_RootVC presentViewController:_pick animated:YES completion:nil];
                
            }else{
                
                shareType = @"other";
                _pick = [[UIImagePickerController alloc]init];
                NSString *requiredMediaType1 = (NSString *)kUTTypeMovie;
                _pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType1,nil];
                [_pick setMediaTypes: arrMediaTypes];
                _pick.delegate = self;
                [VS_RootVC presentViewController:_pick animated:YES completion:nil];
            }
            break;
            
        default:
            break;
    }
}

-(void)shareWithActivityItems:(NSArray *)activityItems{
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];

    // >=iOS8.0系统用这个方法
    activityVC.completionWithItemsHandler = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError){
        
        if (completed) { // 确定分享
            self.shareResult(YES, @"分享成功", nil);
            
        }else {
            
            self.shareResult(NO, @"分享取消",activityError);
        }
    };
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {

        activityVC.popoverPresentationController.sourceView = VS_RootVC.view;
        activityVC.popoverPresentationController.sourceRect = VS_RootVC.view.bounds;
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
         [VS_RootVC presentViewController:activityVC animated:YES completion:nil];
          
      }else{
          
          [VS_RootVC presentViewController:activityVC animated:YES completion:nil];
          
      }
    
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    [_pick dismissViewControllerAnimated:YES completion:nil];
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerPHAsset];
    FBSDKSharePhoto * photo = [[FBSDKSharePhoto alloc]initWithImage:nil isUserGenerated:YES];
    FBSDKShareVideo *video = [[FBSDKShareVideo alloc] initWithVideoURL:videoURL previewPhoto:photo];

    FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
    content.hashtag = [[FBSDKHashtag  alloc]initWithString:self.shareModel.descr];
    content.video = video;
    
    if ([shareType isEqualToString:VSDK_FACEBOOK]) {
        
        [FBSDKShareDialog showFromViewController:VS_RootVC withContent:content delegate:self];
        
    }else{
        
        [self shareWithActivityItems: @[self.shareModel.title ,videoURL]];
        
    }
    
}


#pragma mark -- FBSDKSharingDelegate
//FB分享失败回调
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    self.shareResult(NO, nil, error);
    
}

//FB分享成功回调
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    [[VSDKAPI shareAPI] vsdk_beatPointWithType:FbShareType state:SHARE_COMPLETE_SUCCESS];
    self.shareResult(YES , results, nil);
    
    
}

//FB取消分享回调
- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    
    self.shareResult(NO , nil, nil);
    
}

-(UIView *)bottomPopView
{
    if (_bottomPopView == nil) {
        _bottomPopView = [[UIView alloc] initWithFrame:CGRectMake(15, SCREE_HEIGHT-30, SCREE_WIDTH - 30, self.shreViewHeight)];
        _bottomPopView.backgroundColor = VSDK_WHITE_COLOR;
        _bottomPopView.layer.cornerRadius = 20;
    }
    return _bottomPopView;
}

#pragma mark - 点击背景关闭视图
-(void)vsdk_closeShareView{
    
    [UIView animateWithDuration:.3f animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.bottomPopView.frame = CGRectMake(0, SCREE_HEIGHT, SCREE_WIDTH, self.shreViewHeight);
    } completion:^(BOOL finished) {
        
        self.hidden = YES;
    }];
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:self.bottomPopView]) {
        return NO;
    }
    return YES;
}

#pragma mark 设置平台
-(void)vsdk_setUpPlatformsItems{
    
    
    if (self.shareConentType == VSShareContentTypeVideo) {
        
        if (VSDK_FBINSTALLED) {
            
            VSSharePlatform *facebookModel = [[VSSharePlatform alloc] init];
            facebookModel.iconStateNormal = kSrcName(@"vsdk_facebook");
            facebookModel.sharePlatform = VSShareTypeFacebook;
            facebookModel.name = @"Facebook";
            [self.platformArray addObject:facebookModel];
            
        }
        
        VSSharePlatform *moreModel = [[VSSharePlatform alloc] init];
        moreModel.iconStateNormal = kSrcName(@"vsdk_more");
        moreModel.sharePlatform = VSShareTypeMore;
        moreModel.name = @"More";
        [self.platformArray addObject:moreModel];
        
    }else if (self.shareConentType == VSShareContentTypeImage){
        
        if (VSDK_FBINSTALLED) {
            
            VSSharePlatform *fbSessionModel = [[VSSharePlatform alloc] init];
            fbSessionModel.iconStateNormal = kSrcName(@"vsdk_facebook");
            fbSessionModel.sharePlatform = VSShareTypeFacebook;
            fbSessionModel.name = @"Facebook";
            [self.platformArray addObject:fbSessionModel];
        }
        

     
        VSSharePlatform *moreModel = [[VSSharePlatform alloc] init];
        moreModel.iconStateNormal = kSrcName(@"vsdk_more");
        moreModel.sharePlatform = VSShareTypeMore;
        moreModel.name = @"More";
        [self.platformArray addObject:moreModel];
        
    }else if (self.shareConentType == VSShareContentTypeText){
        
        
        VSSharePlatform *moreModel = [[VSSharePlatform alloc] init];
        moreModel.iconStateNormal = kSrcName(@"vsdk_more");
        moreModel.sharePlatform = VSShareTypeMore;
        moreModel.name = @"More";
        [self.platformArray addObject:moreModel];
        
    }else{
        
        if ([[[VSDeviceHelper plarformAvailable]objectForKey:VSDK_FACEBOOK] isEqual: @1]) {
        
            VSSharePlatform *fbSessionModel = [[VSSharePlatform alloc] init];
            fbSessionModel.iconStateNormal = kSrcName(@"vsdk_facebook");
            fbSessionModel.sharePlatform = VSShareTypeFacebook;
            fbSessionModel.name = @"Facebook";
            [self.platformArray addObject:fbSessionModel];
            
        }
        
      if ([[[VSDeviceHelper plarformAvailable]objectForKey:VSDK_TWITTER] isEqual: @1]) {
        
        VSSharePlatform *twitterModel = [[VSSharePlatform alloc] init];
        twitterModel.iconStateNormal = kSrcName(@"vsdk_twitter");
        twitterModel.sharePlatform = VSShareTypeTwitter;
        twitterModel.name = @"Twitter";
        [self.platformArray addObject:twitterModel];
        
      }

        VSSharePlatform *moreModel = [[VSSharePlatform alloc] init];
        moreModel.iconStateNormal = kSrcName(@"vsdk_more");
        moreModel.sharePlatform = VSShareTypeMore;
        moreModel.name = @"More";
        [self.platformArray addObject:moreModel];
        
    }
    
}
@end

