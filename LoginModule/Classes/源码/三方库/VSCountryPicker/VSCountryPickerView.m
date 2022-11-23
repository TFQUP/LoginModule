//
//  MHD_CountryPicker.m
//  testDemo
//
//  Created by 马赫迪 on 2019/11/21.
//  Copyright © 2019 马赫迪. All rights reserved.
//

#import "VSCountryPickerView.h"
#import "VSSDKDefine.h"
//屏幕尺寸
#define MAIN_SIZE ([ [ UIScreen mainScreen ] bounds ].size)

@interface VSCountryPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,retain)UIView *toolView;
@property (nonatomic,retain)UIPickerView *pickerView;
@property (nonatomic,retain)UIButton *cancelBtn;
@property (nonatomic,retain)UIButton *confirmBtn;
@property (nonatomic,retain)UILabel *centerTitleLabel;
@property (nonatomic,copy)NSArray *jsonCountryArr;
@end

@implementation VSCountryPickerView
{
    NSInteger selectKeyIndex;
    NSInteger selectCountryIndex;
}
#pragma mark 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
        self.alpha = 0;
        self.hidden = true;
        _pickerViewHeight = 180.f;
        _pickerBackgroundColor = VSDK_WHITE_COLOR;
        _pickerLabelColor = VSDK_BLACK_COLOR;
        _toolViewBackgroundColor = VSDK_WHITE_COLOR;
        _cancelButtonTitle =VSLocalString(@"Cancel");
        _cancelButtonTitleColor = VSDK_GRAY_COLOR;
        _cancelButtonFontSize = 18.f;
        _confirmButtonTitle =VSLocalString(@"OK");
        _confirmButtonTitleColor = VSDK_ORANGE_COLOR;
        _confirmButtonFontSize = 18.f;
        _centerTitle = VSLocalString(@"Select");
        _centerTitleColor = VSDK_BLACK_COLOR;
        _centerTitleFontSize = 16.f;
        selectKeyIndex = 0;
        selectCountryIndex = 0;
        [self toolView];
        [self pickerView];
        [self cancelBtn];
        [self confirmBtn];
        [self centerTitleLabel];
        [self jsonCountryArr];
    }
    return self;
}
- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

#pragma mark 获取json文件的国家数组
- (NSArray *)jsonCountryArr
{
    if (!_jsonCountryArr) {
        
        if ([VSDeviceHelper getCountryAreaCodes].count > 0) {
        
            _jsonCountryArr = [VSDeviceHelper getCountryAreaCodes];
        
        }else{
            
            NSString * areaIssued = [VSDK_ISSUED_AREA hasPrefix:@"Area-"]?VSDK_ISSUED_AREA:@"Area-Global";
       
            _jsonCountryArr = [self readLocalFileWithName:[kBundleName stringByAppendingPathComponent:areaIssued]];
        
        }
    }
    return _jsonCountryArr;
}
#pragma mark 工具条视图
- (UIView *)toolView
{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, MAIN_SIZE.height-_pickerViewHeight-40, MAIN_SIZE.width, 40)];
        _toolView.backgroundColor = _toolViewBackgroundColor;
        [self addSubview:_toolView];
    }
    return _toolView;
}
#pragma mark 选择器视图
- (UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,  MAIN_SIZE.height-_pickerViewHeight, MAIN_SIZE.width, _pickerViewHeight)];
        _pickerView.backgroundColor = _pickerBackgroundColor;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}
#pragma mark 左侧取消按钮
- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:_cancelButtonTitle forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:_cancelButtonTitleColor forState:UIControlStateNormal];
        if (DEVICEPORTRAIT) {
         _cancelBtn.frame = IS_IPhoneX_All?CGRectMake(5, 0, 80, 30):CGRectMake(5, 0, 80, 30);
        }else{
            
        _cancelBtn.frame = IS_IPhoneX_All?CGRectMake(34, 0, 80, 30):CGRectMake(5, 0, 80, 30);
            
        }
        _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_cancelBtn addTarget:self action:@selector(cancelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}
#pragma mark 左侧取消按钮点击事件
- (void)cancelBtnAction:(UIButton *)btn{
    
!_cancelClickBlock?:_cancelClickBlock(self.jsonCountryArr[selectKeyIndex][@"data"][selectCountryIndex][@"country_name"],[self.jsonCountryArr[selectKeyIndex][@"data"][selectCountryIndex][@"phone_code"]isEqualToString:@"(null)"]?@"":self.jsonCountryArr[selectKeyIndex][@"data"][selectCountryIndex][@"phone_code"]);
    [self hideCountryPickerView];
}
#pragma mark 右侧确认按钮
- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:_confirmButtonTitle forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:_confirmButtonTitleColor forState:UIControlStateNormal];
        
        if (DEVICEPORTRAIT) {
            _confirmBtn.frame = IS_IPhoneX_All?CGRectMake(MAIN_SIZE.width-80, 0, 80, 30):CGRectMake(MAIN_SIZE.width-80, 0, 80, 30);
             }else{
        _confirmBtn.frame = IS_IPhoneX_All?CGRectMake(MAIN_SIZE.width -34 -80, 0, 80, 30):CGRectMake(MAIN_SIZE.width-80, 0, 80, 30);
             }
        

        _confirmBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_confirmBtn addTarget:self action:@selector(confirmBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_toolView addSubview:_confirmBtn];
    }
    return _confirmBtn;
}
#pragma mark 右侧确认按钮点击事件
- (void)confirmBtnAction:(UIButton *)btn
{
!_confirmClickBlock?:_confirmClickBlock(self.jsonCountryArr[selectKeyIndex][@"data"][selectCountryIndex][@"country_name"],[self.jsonCountryArr[selectKeyIndex][@"data"][selectCountryIndex][@"phone_code"]isEqualToString:@"(null)"]?@"":self.jsonCountryArr[selectKeyIndex][@"data"][selectCountryIndex][@"phone_code"]);

    [self hideCountryPickerView];
}
#pragma mark 中心的标题文字
- (UILabel *)centerTitleLabel
{
    if (!_centerTitleLabel) {
        _centerTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_SIZE.width/3, 30)];
        _centerTitleLabel.center = CGPointMake(MAIN_SIZE.width/2, 20);
        _centerTitleLabel.text = _centerTitle;
        _centerTitleLabel.textColor = _centerTitleColor;
        _centerTitleLabel.font = [UIFont systemFontOfSize:_centerTitleFontSize];
        _centerTitleLabel.textAlignment = NSTextAlignmentCenter;
        [_toolView addSubview:_centerTitleLabel];
    }
    return _centerTitleLabel;
}
#pragma mark 返回选择器的区
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;
}
#pragma mark 返回每个区的单元格数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return self.jsonCountryArr.count;
            break;
        case 1:
            return [self.jsonCountryArr[selectKeyIndex][@"data"]count];
            break;
        default:
            return 0;
            break;
    }
}
#pragma mark 返回单元格宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    switch (component) {
        case 0:
            return MAIN_SIZE.width/4;
            break;
        case 1:
            return MAIN_SIZE.width*3/4;
            break;
        default:
            return 0;
            break;
    }
}
#pragma mark 返回单元格高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    return 30.f;
}
#pragma mark 返回单元格内容
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view API_UNAVAILABLE(tvos)
{
    switch (component) {
        case 0:
        {
            if ([VSDeviceHelper getCountryAreaCodes].count >0||self.jsonCountryArr.count == 1) {
             
                return nil;
                
            }else{
            
            UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAIN_SIZE.width/4, 30)];
            keyLabel.textColor = _pickerLabelColor;
            keyLabel.font = [UIFont systemFontOfSize:15.f];
            keyLabel.textAlignment = NSTextAlignmentCenter;
            keyLabel.text = self.jsonCountryArr[row][@"key"];
            return keyLabel;
                
            }
            
            return nil;
        }
            break;
        case 1:
        {
          
            UIView *countryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SIZE.width*3/4, 30)];
            countryView.backgroundColor = [UIColor clearColor];
            NSString *countryCode = self.jsonCountryArr[selectKeyIndex][@"data"][row][@"country_code"];
            UIImageView *falgImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[kBundleName stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.ico",countryCode]]]];//国旗图标
            falgImage.frame = CGRectMake(0, 0, 30, 30);
            falgImage.center = CGPointMake(15, 15);
            falgImage.contentMode = UIViewContentModeScaleAspectFit;
            [countryView addSubview:falgImage];
            UILabel *nameCodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, (MAIN_SIZE.width*3/4)-40, 25)];
            nameCodeLabel.center = CGPointMake(40+((MAIN_SIZE.width*3/4)-40)/2, 15);
            nameCodeLabel.textAlignment = NSTextAlignmentLeft;
            nameCodeLabel.textColor = _pickerLabelColor;
            nameCodeLabel.font = [UIFont systemFontOfSize:15.f];
            nameCodeLabel.text = [NSString stringWithFormat:@"%@(+%@)",VSLocalString(self.jsonCountryArr[selectKeyIndex][@"data"][row][@"country_name"]),self.jsonCountryArr[selectKeyIndex][@"data"][row][@"phone_code"]];
            [countryView addSubview:nameCodeLabel];
            return countryView;
            
            

        }
            break;
        default:
            break;
    }
    return nil;
}
#pragma mark 单元格选择事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    if (component==0) {
        selectKeyIndex = row;
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:true];
        selectCountryIndex = 0;
    }else if (component==1){
        selectCountryIndex = row;
    }
}
#pragma mark 显示该选择器
- (void)showCountryPickerView
{
    [self.pickerView selectRow:0 inComponent:0 animated:false];
    [self.pickerView selectRow:0 inComponent:1 animated:false];
    selectKeyIndex = 0;
    selectCountryIndex = 0;
    self.frame = CGRectMake(0, 0, MAIN_SIZE.width, MAIN_SIZE.height);
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 1;
        self.hidden = false;
    } completion:^(BOOL finished) {

    }];
}
#pragma mark 使选择器消失
- (void)hideCountryPickerView
{
    [UIView animateWithDuration:0.25f animations:^{
        self.alpha = 0;
        self.hidden = true;
    } completion:^(BOOL finished) {

    }];
}
#pragma mark 读取本地JSON文件
- (NSArray *)readLocalFileWithName:(NSString *)name {
    // 获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    // 将文件数据化
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    // 对数据进行JSON格式化并返回字典形式
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}
- (void)setPickerViewHeight:(float)pickerViewHeight
{
    _pickerViewHeight = pickerViewHeight;
    self.pickerView.frame = CGRectMake(0, MAIN_SIZE.height-_pickerViewHeight, MAIN_SIZE.width, _pickerViewHeight);
    self.toolView.frame = CGRectMake(0, MAIN_SIZE.height-_pickerViewHeight-40, MAIN_SIZE.width, 40);
    [self addSubview:self.pickerView];
    [self addSubview:self.toolView];
}
- (void)setPickerBackgroundColor:(UIColor *)pickerBackgroundColor
{
    _pickerBackgroundColor = pickerBackgroundColor;
    self.pickerView.backgroundColor = _pickerBackgroundColor;
}
- (void)setPickerLabelColor:(UIColor *)pickerLabelColor
{
    _pickerLabelColor = pickerLabelColor;
    [self.pickerView reloadAllComponents];
}
- (void)setToolViewBackgroundColor:(UIColor *)toolViewBackgroundColor
{
    _toolViewBackgroundColor = toolViewBackgroundColor;
    self.toolView.backgroundColor = _toolViewBackgroundColor;
}
- (void)setCancelButtonTitle:(NSString *)cancelButtonTitle
{
    _cancelButtonTitle = cancelButtonTitle;
    [self.cancelBtn setTitle:_cancelButtonTitle forState:UIControlStateNormal];
}
- (void)setCancelButtonTitleColor:(UIColor *)cancelButtonTitleColor
{
    _cancelButtonTitleColor = cancelButtonTitleColor;
    [self.cancelBtn setTitleColor:_cancelButtonTitleColor forState:UIControlStateNormal];
}
- (void)setCancelButtonFontSize:(float)cancelButtonFontSize
{
    _cancelButtonFontSize = cancelButtonFontSize;
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:_cancelButtonFontSize];
}
- (void)setConfirmButtonTitle:(NSString *)confirmButtonTitle
{
    _confirmButtonTitle = confirmButtonTitle;
    [self.confirmBtn setTitle:_confirmButtonTitle forState:UIControlStateNormal];
}
- (void)setConfirmButtonTitleColor:(UIColor *)confirmButtonTitleColor
{
    _confirmButtonTitleColor = confirmButtonTitleColor;
    [self.confirmBtn setTitleColor:_confirmButtonTitleColor forState:UIControlStateNormal];
}
- (void)setConfirmButtonFontSize:(float)confirmButtonFontSize
{
    _confirmButtonFontSize = confirmButtonFontSize;
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:_confirmButtonFontSize];
}
- (void)setCenterTitle:(NSString *)centerTitle
{
    _centerTitle = centerTitle;
    self.centerTitleLabel.text = _centerTitle;
}
- (void)setCenterTitleColor:(UIColor *)centerTitleColor
{
    _centerTitleColor = centerTitleColor;
    self.centerTitleLabel.textColor = _centerTitleColor;
}
- (void)setCenterTitleFontSize:(float)centerTitleFontSize
{
    _centerTitleFontSize = centerTitleFontSize;
    self.centerTitleLabel.font = [UIFont systemFontOfSize:_centerTitleFontSize];
}


@end
