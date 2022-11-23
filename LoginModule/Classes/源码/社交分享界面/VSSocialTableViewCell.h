//
//  VSSocialTableViewCell.h
//  VSDK
//
//  Created by admin on 7/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VSSocialTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel * lbShareTitle;
@property(nonatomic,strong)UILabel * lbShareDetail;
@property(nonatomic,strong)UIImageView * imageIcon;
@property(nonatomic,strong)UIButton * btnClaim;
@end

NS_ASSUME_NONNULL_END
