//
//  VSActivicityPageView.m
//  VVSDK
//
//  Created by admin on 1/12/22.
//

#import "VSActivicityPageView.h"
#import "VSSDKDefine.h"
@interface VSActivicityPageView()<UIScrollViewDelegate>

@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,assign)NSUInteger pageCount;
@property(nonatomic,strong)UIPageControl * pageControl;
@property(nonatomic,strong)UIButton * closeBtn;
@property(nonatomic,strong)NSArray * list;
@end

@implementation VSActivicityPageView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self layOutContextView];
    }
    
    return self;
}


-(UIPageControl *)pageControl{
    
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(VS_VIEW_LEFT(self.scrollView) + self.scrollView.frame.size.width / 2 - self.scrollView.frame.size.width/2, VS_VIEW_BOTTOM(self.scrollView) + 5, self.scrollView.frame.size.width, 20)];
        _pageControl.numberOfPages = self.pageCount;
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        
        [_pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];
    }
    
    return _pageControl;;
}

-(void)pageControlValueChange:(UIPageControl *)pageControl{
    
    
    [UIView animateWithDuration:0.25 animations:^{
     
        self.scrollView.contentOffset = CGPointMake(pageControl.currentPage * self.scrollView.frame.size.width,0);
        
    }];

}

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        if (IS_IPhoneX_All) {
          
            _scrollView = [[UIScrollView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, SCREE_WIDTH* 5/6, SCREE_HEIGHT * 0.7):CGRectMake(0, 0, SCREE_WIDTH* 0.7, SCREE_HEIGHT* 4/5)];
            
        }else{
            
            _scrollView = [[UIScrollView alloc]initWithFrame:DEVICEPORTRAIT?CGRectMake(0, 0, SCREE_WIDTH* 5/6, SCREE_HEIGHT * 0.7):CGRectMake(0, 0, SCREE_WIDTH* 0.82, SCREE_HEIGHT* 4/5)];
            
        }
    
        _scrollView.center = self.center;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.layer.cornerRadius = 12;
        _scrollView.layer.masksToBounds = YES;
        _scrollView.bounces = NO;
        
        if (IS_IPhoneX_All) {
            _scrollView.contentSize = DEVICEPORTRAIT?CGSizeMake(self.pageCount * SCREE_WIDTH* 5/6, SCREE_HEIGHT* 0.7 ):CGSizeMake(self.pageCount * SCREE_WIDTH* 0.7, SCREE_HEIGHT* 4/5);
        }else{
            
            _scrollView.contentSize = DEVICEPORTRAIT?CGSizeMake(self.pageCount * SCREE_WIDTH* 5/6, SCREE_HEIGHT* 0.7 ):CGSizeMake(self.pageCount * SCREE_WIDTH* 0.82, SCREE_HEIGHT* 4/5);
        }
        
        _scrollView.delegate = self;
    }
    
    return  _scrollView;
}


-(NSArray *)list{
    
    if (!_list) {
        
        _list = [[NSArray alloc]initWithArray:[VSDK_DIC_WITH_PATH(VSDK_GRAPHIC_BULLTEIN_PATH) objectForKey:@"list"]];
    }
    return _list;
}

-(void)layOutContextView{
    
    NSDictionary * ppDic = VSDK_DIC_WITH_PATH(VSDK_GRAPHIC_BULLTEIN_PATH);

    if (ppDic.count == 0) return;

    self.pageCount = [[ppDic objectForKey:@"list"] count];
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
    
    for (int i = 0; i < self.pageCount; i++) {
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
         
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self.list[i] objectForKey:@"img"]]];
        
        imageView.tag = 10 + i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
        [imageView addGestureRecognizer:tap];
        
        [self.scrollView addSubview:imageView];
        
    }
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
    
    self.closeBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.closeBtn];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        if (DEVICEPORTRAIT) {
          
            make.bottom.equalTo(self.scrollView.mas_top).offset(-10);
            make.right.equalTo(self.scrollView.mas_right);
            
        }else{
           
            make.top.equalTo(self.scrollView.mas_top).offset(3);
            make.left.equalTo(self.scrollView.mas_right).offset(10);
        }
        
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    
    [self.closeBtn setImage:[UIImage imageNamed:kSrcName(@"vsdk_close_white")] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closePageView) forControlEvents:UIControlEventTouchUpInside];
    
    [VSDeviceHelper addAnimationInView:self Duration:0.4];
    
    
    if (!VS_USERDEFAULTS_GETVALUE(@"vsdk_activity_show_count")){
    
        VS_USERDEFAULTS_SETVALUE(@"1", @"vsdk_activity_show_count");
        
    }else{
        
        NSString * str1 = VS_USERDEFAULTS_GETVALUE(@"vsdk_activity_show_count");
        int intCount = [str1 intValue];
        intCount++;
        NSString * numCount = [NSString stringWithFormat:@"%d",intCount];
        VS_USERDEFAULTS_SETVALUE(numCount, @"vsdk_activity_show_count");

    }

}


-(void)imageViewTapAction:(UITapGestureRecognizer *)ges{
    
    UIImageView * imageView = (UIImageView *)(ges.view);
    
    NSString * imageUrl = [self.list[imageView.tag  - 10] objectForKey:@"link"];
    
    if (![imageUrl hasPrefix:@"https:"]||[imageUrl hasPrefix:@"http:"]||[imageUrl length] == 0) return;
    
    WKWebView * webView = [[WKWebView alloc]initWithFrame:imageView.frame];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]]];

    [imageView addSubview:webView];

}

-(void)closePageView{
    
    [self removeFromSuperview];
    
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSUInteger index = (scrollView.contentOffset.x + 1) / self.scrollView.frame.size.width;
    self.pageControl.currentPage = index;
    
}
@end
