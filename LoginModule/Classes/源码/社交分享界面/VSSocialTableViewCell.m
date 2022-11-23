//
//  VSSocialTableViewCell.m
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import "VSSocialTableViewCell.h"
#import "VSSDKDefine.h"
@implementation VSSocialTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
 
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.btnClaim = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview: self.btnClaim];
        self.btnClaim.titleLabel.numberOfLines = 0;
        self.btnClaim.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.btnClaim mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).with.offset(-10);
            
            make.centerY.equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(self.frame.size.height*2/3 * 2.17,self.frame.size.height*2/3));
        }];
        

        self.btnClaim.titleLabel.font = [UIFont systemFontOfSize:12];
        self.imageIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.imageIcon];
        
        [self.imageIcon mas_makeConstraints:^(MASConstraintMaker *make) {

                make.left.equalTo(self.mas_left).with.offset(10);
            make.centerY.equalTo(self.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(self.frame.size.height*2/3, self.frame.size.height*2/3));
        }];

        UIView * contenbgView = [[UIView alloc]init];
        [self.contentView addSubview:contenbgView];

        [contenbgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.imageIcon.mas_right).with.offset(10);
            make.right.equalTo(self.btnClaim.mas_left).with.offset(-10);
            make.height.equalTo(@40);
        }];
        
       self.lbShareTitle = [[UILabel alloc]init];
        
       [contenbgView addSubview:self.lbShareTitle];
        
        [self.lbShareTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(contenbgView);
            make.height.equalTo(@20);
        }];
         
        if (@available(iOS 13.0, *)) {
            
            self.lbShareTitle.textColor = VSDK_BLACK_COLOR;
            
        }
        self.lbShareTitle.font = [UIFont systemFontOfSize:16];
        
        
        
        self.lbShareDetail = [[UILabel alloc]init];
        [contenbgView addSubview:self.lbShareDetail];
        [self.lbShareDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.lbShareTitle.mas_bottom).with.offset(5);
            make.left.right.equalTo(contenbgView);
    
          make.height.equalTo(@15);
           
        }];
                
        self.lbShareDetail.textColor = VSDK_GRAY_COLOR;
        self.lbShareDetail.font = [UIFont systemFontOfSize:12];
              
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
