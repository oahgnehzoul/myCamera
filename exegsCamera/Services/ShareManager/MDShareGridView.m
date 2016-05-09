//
//  MDShareGridView.m
//  MeiMeiDa
//
//  Created by Yulin Ding on 7/12/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDShareGridView.h"
#import "WeiboSDK.h"
#import "WXApi.h"

const CGFloat kMDShareViewMarginBottom = 12;
const CGFloat kMDShareViewMarginRight = 15;
const CGFloat kMDShareViewButtonIconSize = 50;

@interface MDShareGridView()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, assign) CGFloat shareButtonWidth;
@property (nonatomic, assign) CGFloat shareButtonHeight;

@end

@implementation MDShareGridView

- (instancetype)initWithFrame:(CGRect)frame
                   shareTypes:(NSInteger)shareTypes
                    iconWidth:(CGFloat)iconWidth {
    if (self = [super initWithFrame:frame]) {
        _buttons = [@[] mutableCopy];
        _shareButtonWidth = iconWidth;
        _shareButtonHeight = iconWidth + 24;
        
        if ((shareTypes & MDShareTypeWeChatTimeline) &&
            [MDShareService isThirdPartyInstalled:MDShareTypeWeChatTimeline]) {
            UIButton *wechatButton = [self generateButton:MDShareTypeWeChatTimeline];
            [self addSubview:wechatButton];
        }
        
        if ((shareTypes & MDShareTypeWeChatSession) &&
            [MDShareService isThirdPartyInstalled:MDShareTypeWeChatSession]) {
            UIButton *wechatButton = [self generateButton:MDShareTypeWeChatSession];
            [self addSubview:wechatButton];
        }
        
        if (shareTypes & MDShareTypeWeibo) {
            UIButton *weiboButton = [self generateButton:MDShareTypeWeibo];
            [self addSubview:weiboButton];
        }
        
        if ((shareTypes & MDShareTypeQQ) &&
            [MDShareService isThirdPartyInstalled:MDShareTypeQQ]) {
            UIButton *qqButton = [self generateButton:MDShareTypeQQ];
            [self addSubview:qqButton];
        }
        
        if ((shareTypes & MDShareTypeQZone) &&
            [MDShareService isThirdPartyInstalled:MDShareTypeQQ]) {
            UIButton *qzoneButton = [self generateButton:MDShareTypeQQ];
            [self addSubview:qzoneButton];
        }
        
        if (shareTypes & MDShareTypeQRCode) {
            UIButton *QRButton = [self generateButton:MDShareTypeQRCode];
            [self addSubview:QRButton];
        }
        
        if (shareTypes & MDShareTypeClipboard) {
            UIButton *clipButton = [self generateButton:MDShareTypeClipboard];
            [self addSubview:clipButton];
        }
        
        [self layout];
        
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame shareTypes:(NSInteger)shareTypes {
    return [self initWithFrame:frame shareTypes:shareTypes iconWidth:kMDShareViewButtonIconSize];
}

- (void)layout {
    CGFloat containerWidth = self.width;
    __block CGFloat remainWidth = containerWidth;
    __block CGFloat maxY = 0;
    __block CGFloat maxX = 0;
    __block CGFloat x = 0;
    __block CGFloat y = 0;
    
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *item = (UIButton *)obj;
        
        if (item.size.width <= remainWidth) {
            maxY = MAX(item.size.height + kMDShareViewMarginBottom, maxY);
        } else {
            x = 0;
            y = maxY;
            
            maxY += item.size.height + kMDShareViewMarginBottom;
            remainWidth = containerWidth;
        }
        
        item.left = x;
        item.top = y;
        
        x += item.size.width + kMDShareViewMarginRight;
        remainWidth = remainWidth - item.size.width - kMDShareViewMarginRight;
        maxX = MAX(maxX, x - kMDShareViewMarginRight);
    }];
    
    self.width = maxX;
    self.height = maxY;
}

- (UIButton *)generateButton:(MDShareType)shareType {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = CGSizeMake(_shareButtonWidth, _shareButtonHeight);
    button.tag = shareType;
    [button addTarget:self action:@selector(shareIt:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _shareButtonWidth, _shareButtonWidth)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.layer.cornerRadius = _shareButtonWidth/2;
    [button addSubview:imageView];
    UIImage *image = nil;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10, button.width, 14)];
    titleLabel.font = [MDFont fontWithSize:12];
    titleLabel.textColor = [UIColor colorWithHexString:kMDColorBaseLevel3];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [button addSubview:titleLabel];
    NSString *title = @"";
    
    UIColor *backgroundColor = [UIColor lightGrayColor];
    if (shareType == MDShareTypeWeChatSession) {
        TBCityIconInfo *iconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e602" size:28 color:[UIColor colorWithHexString:kMDColorBaseLevel2]];
        image = [UIImage iconWithInfo:iconInfo];
        backgroundColor = [UIColor colorWithHexString:kMDColorBaseLevel1];
        title = @"微信好友";
    } else if (shareType == MDShareTypeWeChatTimeline) {
        TBCityIconInfo *iconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e606" size:28 color:[UIColor colorWithHexString:kMDColorBaseLevel2]];
        image = [UIImage iconWithInfo:iconInfo];
        backgroundColor = [UIColor colorWithHexString:kMDColorBaseLevel1];
        title = @"朋友圈";
    } else if (shareType == MDShareTypeQQ) {
        TBCityIconInfo *iconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e603" size:28 color:[UIColor colorWithHexString:kMDColorBaseLevel2]];
        image = [UIImage iconWithInfo:iconInfo];
        backgroundColor = [UIColor colorWithHexString:kMDColorBaseLevel1];
        title = @"QQ";
    } else if (shareType == MDShareTypeWeibo) {
        TBCityIconInfo *iconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e605" size:28 color:[UIColor colorWithHexString:kMDColorBaseLevel2]];
        image = [UIImage iconWithInfo:iconInfo];
        backgroundColor = [UIColor colorWithHexString:kMDColorBaseLevel1];
        title = @"微博";
    } else if (shareType == MDShareTypeQRCode) {
        TBCityIconInfo *iconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e604" size:28 color:[UIColor colorWithHexString:kMDColorBaseLevel2]];
        image = [UIImage iconWithInfo:iconInfo];
        backgroundColor = [UIColor clearColor];
        title = @"二维码";
    } else if (shareType == MDShareTypeClipboard) {
        TBCityIconInfo *iconInfo = [TBCityIconInfo iconInfoWithText:@"\U0000e607" size:28 color:[UIColor colorWithHexString:kMDColorBaseLevel2]];
        image = [UIImage iconWithInfo:iconInfo];
        backgroundColor = [UIColor clearColor];
        title = @"复制";
    }
    
    titleLabel.text = title;
    imageView.backgroundColor = backgroundColor;
    if (image) {
        imageView.image = image;
    }
    
    [_buttons addObject:button];
    
    return button;
}

- (void)shareIt:(id)sender {
    WEAKSELF
    MDShareType shareType = ((UIButton *)sender).tag;
    
    if (self.eventDelegate) {
        [self.eventDelegate didSelectShareType:shareType];
    }
    
    if (!self.delegate) {
        return;
    }
   
    if ([self.delegate respondsToSelector:@selector(prepareForShare:)]) {
        [self.delegate prepareForShare:^(MDShareItem *shareItem) {
            [[MDShareService sharedInstance] shareContent:shareItem
                                                 withType:((UIButton *)sender).tag
                                           withCompletion:^(MDShareStatus status) {
                                               if (weakSelf.shareCompletion) {
                                                   weakSelf.shareCompletion(status);
                                               }
                                               
                                               if (weakSelf.customShareCompletion) {
                                                   weakSelf.customShareCompletion(status);
                                               }
                                           }];
        }];
    } else if ([self.delegate respondsToSelector:@selector(itemForShare:)]) {
        MDShareItem *shareItem = [self.delegate itemForShare:shareType];
        [[MDShareService sharedInstance] shareContent:shareItem
                                             withType:((UIButton *)sender).tag
                                       withCompletion:^(MDShareStatus status) {
                                           if (weakSelf.shareCompletion) {
                                               weakSelf.shareCompletion(status);
                                           }
                                           
                                           if (weakSelf.customShareCompletion) {
                                               weakSelf.customShareCompletion(status);
                                           }
                                       }];
    }
}

@end
