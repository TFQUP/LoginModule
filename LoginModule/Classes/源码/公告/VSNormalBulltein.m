//
//  VSNormalBulltein.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSNormalBulltein.h"
#import "VSSDKDefine.h"
#import "VSWebView.h"
@interface VSNormalBulltein ()<VSPageMenuDelegate>
@property(nonatomic,strong)UIScrollView * scrollView;

@end

@implementation VSNormalBulltein

-(instancetype)initWithFrame:(CGRect)frame{
 
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = VSDK_WHITE_COLOR;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [self layOutNormalBulltein];
 
    }
    
    return self;
}

-(void)layOutNormalBulltein{
    

    NSDictionary * bulletinDic = VSDK_DIC_WITH_PATH(VSDK_NORMAL_BULLETIIN_PATH);
    self.bgMaskView = [[UIView alloc]initWithFrame:VS_RootVC.view.bounds];
    self.bgMaskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.bgMaskView addSubview:self];
    [VS_RootVC.view addSubview:self.bgMaskView];
    

    UILabel * bullteinTitle = [[UILabel alloc]init];
    [self addSubview:bullteinTitle];
    [bullteinTitle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.mas_top).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(50);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width - 100, 45));
        
    }];
    
    bullteinTitle.text = VSLocalString(@"Announcement");
    bullteinTitle.textAlignment = NSTextAlignmentCenter;
    bullteinTitle.font = [UIFont boldSystemFontOfSize:20];
    bullteinTitle.textColor = VSDK_ORANGE_COLOR;
    
    UIButton * closeBtn = [[UIButton alloc]init];
     [self addSubview:closeBtn];
     [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.top.equalTo(bullteinTitle.mas_top).with.offset(10);
         make.left.equalTo(bullteinTitle.mas_right).with.offset(10);
         make.size.mas_equalTo(CGSizeMake(25, 25));
         
     }];
     
    [closeBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_close")] forState:UIControlStateNormal];
   
    [closeBtn addTarget:self action:@selector(closeAnnouncementView:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
         make.top.equalTo(bullteinTitle.mas_bottom).with.offset(0);
         make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width , 0.8));
         
     }];
    
    lineView.backgroundColor = VSDK_GRAY_COLOR;
    
    NSArray * bullteinArr = [bulletinDic objectForKey:@"bulletin_list"];
    
    NSMutableArray * titleArr = [[NSMutableArray alloc]init];
    
    for (NSDictionary * dic in bullteinArr) {
        
        [titleArr addObject:[dic objectForKey:@"bulletin_title"]];
    }
    
    if (titleArr.count != 0) {
          
          VSPageMenu *pageMenu = [VSPageMenu pageMenuWithFrame:CGRectMake(0, 46, self.frame.size.width, 40) trackerStyle:VSPageMenuTrackerStyleLineAttachment];
          pageMenu.trackerWidth = 50;
          pageMenu.delegate = self;
          pageMenu.bridgeScrollView = self.scrollView;
          [pageMenu setItems:titleArr selectedItemIndex:0];

        for (int i = 0; i < bullteinArr.count; i++) {
            
            NSDictionary * dic = (NSDictionary *)bullteinArr[i];
            
            if ([[dic objectForKey:@"bulletin_type"]  isEqual: @1]) {
                VSPageMenuButtonItem *item = [VSPageMenuButtonItem itemWithTitle:titleArr[i] image:[UIImage imageNamed:kSrcName(@"vsdk_bulltein_new")]];
                        [pageMenu setItem:item forItemAtIndex:i];
            }else if([[dic objectForKey:@"bulletin_type"] isEqual: @2]){
                
                VSPageMenuButtonItem *item = [VSPageMenuButtonItem itemWithTitle:titleArr[i]   image:[UIImage imageNamed:kSrcName(@"vsdk_bulltein_hot")]];
               [pageMenu setItem:item forItemAtIndex:i];
                
            }else if([[dic objectForKey:@"bulletin_type"] isEqual: @3]){
                
                VSPageMenuButtonItem *item = [VSPageMenuButtonItem itemWithTitle:titleArr[i] image:[UIImage imageNamed:kSrcName(@"vsdk_bulltein_event")]];
                  [pageMenu setItem:item forItemAtIndex:i];
                
            }else{
                
            }
        }
        
        [self addSubview:pageMenu];

          self.scrollView = [[UIScrollView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 86, self.frame.size.width, self.frame.size.height-86): CGRectMake(0, 86, self.frame.size.width, self.frame.size.height-86)];
          self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 5, self.frame.size.height-86);
          self.scrollView.showsHorizontalScrollIndicator = YES;
          self.scrollView.showsVerticalScrollIndicator = NO;
          self.scrollView.backgroundColor = VSDK_ORANGE_COLOR;
          self.scrollView.pagingEnabled = YES;
          self.scrollView.scrollEnabled = NO;
          [self addSubview:self.scrollView];
          

          for (int i =0; i < bullteinArr.count; i++) {
              
              VSWebView  * web = [[VSWebView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(i*self.frame.size.width, 0 , self.scrollView.frame.size.width, self.scrollView.frame.size.height):CGRectMake(i*self.frame.size.width,0 , self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
              if ([[bullteinArr[i] objectForKey:@"bulletin_url"]length]>0) {
                  
                  web.url = [bullteinArr[i] objectForKey:@"bulletin_url"];
                  [web showWebView];
                  [self.scrollView addSubview:web];
                  
              }else{

                  web.htmlStr = [bullteinArr[i] objectForKey:@"bulletin_desc"];
                  [web showWebView];
                  [self.scrollView addSubview:web];
              }
             
            
          }
        
    }else{
      
        UILabel * noDataLabel = [[UILabel alloc]init];
        [self addSubview:noDataLabel];
        
        [noDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self.mas_top).with.offset(46);
            
            make.left.right.bottom.equalTo(self);
        }];
        
        noDataLabel.text = VSLocalString(@"No Announcement~");
        noDataLabel.textColor = VSDK_GRAY_COLOR;
        noDataLabel.font = [UIFont systemFontOfSize:20];
        noDataLabel.numberOfLines = 0;
        noDataLabel.textAlignment = NSTextAlignmentCenter;
    }

      [VSDeviceHelper addAnimationInView:self Duration:0.6];
}


-(void)closeAnnouncementView:(UIButton *)sender{
    
     [self.bgMaskView removeFromSuperview];
     [self removeFromSuperview];
}

@end
