//
//  ConsumeView.m
//  TextTest
//
//  Created by admin on 7/13/22.
//

#import "ConsumeView.h"
#import "Masonry.h"
#import "EditerStr.h"
#import "VSSDKDefine.h"
@implementation ConsumeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
//        self.backgroundColor = [UIColor grayColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(void)setUI{
    self.mainV = [[UIView alloc] init];
    self.textV = [[UITextView alloc] init];
    self.textFild = [[UITextField alloc] init];
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.mainV];
    [self.mainV addSubview:self.textV];
    [self.mainV addSubview:self.textFild];
    [self.mainV addSubview:self.cancelBtn];
    [self.mainV addSubview:self.sureBtn];
    
    self.mainV.backgroundColor = [UIColor whiteColor];
    self.textV.font = [UIFont systemFontOfSize:16];
    self.textFild.font = [UIFont systemFontOfSize:13];
    [self.textFild addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    self.textFild.backgroundColor = [UIColor blueColor];
//    self.cancelBtn.backgroundColor = [UIColor greenColor];
//    self.sureBtn.backgroundColor = [UIColor yellowColor];
    
    self.mainV.layer.masksToBounds = YES;
    self.mainV.layer.cornerRadius = 8;
    
    [self.textV setEditable:NO];
    
    self.textFild.placeholder = VSLocalString(@"I confirm to cancel the account and all roles under it");
    self.textFild.textAlignment = NSTextAlignmentCenter;
    [self.cancelBtn setTitle:VSLocalString(@"Cancel") forState:UIControlStateNormal];
    [self.sureBtn setTitle:VSLocalString(@"Confirm") forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 8;
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    self.cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    [self.cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 8;
    self.sureBtn.backgroundColor = [UIColor systemPinkColor];
    [self.sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    self.sureBtn.userInteractionEnabled = NO;
    
    if (self.type == 0) {
        self.textV.text = [[EditerStr shareInstance] showifHesitate:NO];
    }else{
        self.textV.text = [[EditerStr shareInstance] showifHesitate:YES];
    }
}

-(void)layoutSubviews{
    [self.mainV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(370, 250));
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainV).offset(-10);
        make.left.equalTo(self.mainV.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mainV).offset(-10);
        make.right.equalTo(self.mainV.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 35));
    }];
    [self.textFild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mainV);
        make.bottom.equalTo(self.cancelBtn.mas_top).offset(-10);
        make.left.equalTo(self.mainV).offset(10);
        make.right.equalTo(self.mainV).offset(-10);
        make.height.mas_equalTo(40);
    }];
    [self.textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainV).offset(10);
        make.left.equalTo(self.mainV).offset(10);
        make.right.equalTo(self.mainV).offset(-10);
        make.bottom.equalTo(self.textFild.mas_top).offset(-10);
    }];
    
}

-(void)cancelClick:(UIButton *)btn{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

-(void)sureClick:(UIButton *)btn{
    
    if ([self.textFild.text isEqualToString:VSLocalString(@"I confirm to cancel the account and all roles under it")]) {
        if (self.sureBlock) {
            self.sureBlock(self.type);
        }
    }
    
    
}

-(void)textFieldDidChange:(UITextField*)textField{
    if ([textField.text isEqualToString:VSLocalString(@"I confirm to cancel the account and all roles under it")]) {
        self.sureBtn.backgroundColor = [UIColor redColor];
        self.sureBtn.userInteractionEnabled = YES;
        
    }
}
@end
