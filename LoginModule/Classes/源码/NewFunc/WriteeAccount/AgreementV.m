//
//  AgreementV.m
//  VVSDK
//
//  Created by admin on 7/20/22.
//

#import "AgreementV.h"
#import "Masonry.h"
#import "EditerStr.h"
#import "VSSDKDefine.h"
@implementation AgreementV

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

-(void)setUI{
    self.backgroundColor = [UIColor clearColor];
    self.frame = [UIScreen mainScreen].bounds;
    self.mainV = [[UIView alloc] init];
    self.mainV.backgroundColor = [UIColor whiteColor];
    self.mainV.layer.masksToBounds = YES;
    self.mainV.layer.cornerRadius = 8;
    self.textV = [[UITextView alloc] init];
    self.textV.editable = NO;
    self.textV.text = [EditerStr shareInstance].str6;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = VSLocalString(@"Game Account Cancellation Agreement");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.confimBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.confimBtn setTitle:VSLocalString(@"Confirm") forState:UIControlStateNormal];
    [self.confimBtn setBackgroundColor:[UIColor redColor]];
    self.confimBtn.layer.masksToBounds = YES;
    self.confimBtn.layer.cornerRadius = 8;
    [self.confimBtn addTarget:self action:@selector(confimClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.closeBtn setBackgroundImage:[UIImage imageNamed:kSrcName(@"guanbi")] forState:UIControlStateNormal];
    [self addSubview:self.mainV];
    [self.mainV addSubview:self.titleLabel];
    [self.mainV addSubview:self.confimBtn];
    [self.mainV addSubview:self.textV];
    
//    self.titleLabel.backgroundColor = [UIColor blueColor];
//    self.textV.backgroundColor = [UIColor redColor];
//    self.confimBtn.backgroundColor = [UIColor orangeColor];
}

- (void)layoutSubviews{
    
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
    
    

    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainV);
        make.left.equalTo(self.mainV);
        make.right.equalTo(self.mainV);
        make.height.mas_equalTo(45);
    }];
    [self.confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.bottom.equalTo(self.mainV.mas_bottom).offset(-5);
        make.centerX.equalTo(self.mainV);
        
    }];
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(200, 200));
//        make.center.equalTo(self.mainV);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.bottom.equalTo(self.confimBtn.mas_top).offset(-5);
        make.left.equalTo(self.mainV);
        make.right.equalTo(self.mainV);
    }];
}


-(void)confimClick:(UIButton *)btn{
    [self removeFromSuperview];
}
@end
