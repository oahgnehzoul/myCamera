//
//  MDShareQRCodeView.m
//  MeiMeiDa
//
//  Created by Yulin Ding on 10/20/15.
//  Copyright © 2015 Jason Wong. All rights reserved.
//

#import "MDShareQRCodeView.h"
#import "QRCodeGenerator.h"
#import "KLCPopup.h"

@interface MDShareQRCodeView()

@property (nonatomic, strong) MDShareItem *shareItem;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation MDShareQRCodeView

+ (MDShareQRCodeView *)presentInView:(UIView *)view
                           shareItem:(MDShareItem *)shareItem
                      animated:(BOOL)animated {
    MDShareQRCodeView *shareView = [[MDShareQRCodeView alloc] initWithShareItem:shareItem];
    KLCPopup *popup = [KLCPopup popupWithContentView:shareView
                                            showType:KLCPopupShowTypeBounceIn
                                         dismissType:KLCPopupDismissTypeBounceOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    [popup show];
    
    return shareView;
}

+ (void)dismissInView:(UIView *)view
             animated:(BOOL)animated {
    [KLCPopup dismissAllPopups];
}

- (instancetype)initWithShareItem:(MDShareItem *)shareItem {
    if (self = [super init]) {
        _shareItem = shareItem;
        
        _contentView = [self generateContentView];
        [self addSubview:_contentView];
        
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setBackgroundColor:[UIColor clearColor]];
        [_saveButton addTarget:self action:@selector(saveQRCode:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *iconText = @"\U0000e695";
        NSString *text = @"保存到相册";
        NSString *allText = [NSString stringWithFormat:@"%@ %@", iconText, text];
        
        NSDictionary *attrs = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                NSFontAttributeName: [MDFont fontWithSize:14]};
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:allText attributes:attrs];
        
        [attrStr addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"iconfont" size:14]} range:NSMakeRange(0, iconText.length)];
        [_saveButton setAttributedTitle:attrStr forState:UIControlStateNormal];
        [self addSubview:_saveButton];
        [_saveButton sizeToFit];
        _saveButton.top = _contentView.bottom + 10;
        
        self.size = (CGSize){_contentView.width, _saveButton.bottom};
        _saveButton.left = (self.width - _saveButton.width)/2;
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setBackgroundColor:[UIColor clearColor]];
        TBCityIconInfo *closeIconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e680" size:24 color:[UIColor colorWithHexString:kMDColorBaseLevel4]];
        UIImage *closeIconImage = [UIImage iconWithInfo:closeIconInfo];
        _closeButton.size = closeIconImage.size;
        [_closeButton setImage:closeIconImage forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(doClose:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        _closeButton.left = _contentView.right - 15 - _closeButton.width;
        _closeButton.top = _contentView.top + 15;
    }
    
    return self;
}

- (UIView *)generateContentView {
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 375)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 10;
    ret.layer.masksToBounds = YES;
    [self addSubview:ret];
    
    CGFloat offsetY = 25;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, 60, 60)];
    imageView.left = (ret.width - imageView.width)/2;
    imageView.backgroundColor = [UIColor colorWithHexString:kMDBackgroundColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.layer.masksToBounds = YES;
    
    if (_shareItem.QRCodeImageType == MDShareItemQRImageTypeCircle) {
        imageView.layer.cornerRadius = 30;
    }
    
    if (_shareItem.image) {
        imageView.image = _shareItem.image;
    }
    
    [ret addSubview:imageView];
    
    offsetY += imageView.height;
    offsetY += 15;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetY, ret.width, 21)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [MDFont fontWithSize:18];
    titleLabel.textColor = [UIColor colorWithHexString:kMDColorBaseLevel2];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [ret addSubview:titleLabel];
    titleLabel.text = _shareItem.title;
   
    offsetY += titleLabel.height;
    offsetY += 10;
    
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, 200, 200)];
    codeView.left = (ret.width - codeView.width)/2;
    codeView.contentMode = UIViewContentModeScaleAspectFill;
    codeView.layer.masksToBounds = YES;
    codeView.image = [QRCodeGenerator qrImageForString:_shareItem.url imageSize:codeView.width*[UIScreen mainScreen].scale];
    [ret addSubview:codeView];
    
    offsetY += codeView.height;
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, 30, 30)];
    logoView.left = (codeView.width - logoView.width)/2;
    logoView.top = (codeView.height - logoView.height)/2;
    logoView.contentMode = UIViewContentModeCenter;
    logoView.backgroundColor = [UIColor colorWithHexString:kMDColorBaseLevel1];
    logoView.layer.masksToBounds = YES;
    logoView.layer.cornerRadius = 3;
    
    TBCityIconInfo *logoIconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e693" size:18 color:[UIColor blackColor]];
    UIImage *logoIconImage = [UIImage iconWithInfo:logoIconInfo];
    logoView.image = logoIconImage;
    [codeView addSubview:logoView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offsetY, ret.width, 15)];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.font = [MDFont fontWithSize:12];
    tipLabel.textColor = [UIColor colorWithHexString:kMDColorBaseLevel3];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [ret addSubview:tipLabel];
    tipLabel.text = _shareItem.content;
    
    return ret;
}

- (void)doClose:(id)sender {
    [self dismissPresentingPopup];
}

- (void)saveQRCode:(id)sender {
    UIGraphicsBeginImageContextWithOptions(_contentView.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [_contentView.layer renderInContext:context];
    UIImage *QRImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (QRImage) {
        UIImageWriteToSavedPhotosAlbum(QRImage, nil, nil, nil);
        MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
        progressHUD.labelText = @"已保存到相册";
        progressHUD.mode = MBProgressHUDModeText;
        [progressHUD show:YES];
        [progressHUD hide:YES afterDelay:1];
    }
}

@end
