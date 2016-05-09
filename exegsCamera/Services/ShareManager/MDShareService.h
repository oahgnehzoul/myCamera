//
//  MDShareService.h
//  MeiMeiDa
//
//  Created by Yulin Ding on 6/24/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDShareItem.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"

@class UMSocialAccountEntity;

typedef NS_OPTIONS(NSInteger, MDShareType) {
    MDShareTypeWeChatTimeline = 1 << 0,
    MDShareTypeWeChatSession = 1 << 1,
    MDShareTypeWeibo = 1 << 2,
    MDShareTypeQQ = 1 << 3,
    MDShareTypeQZone = 1 << 4,
    MDShareTypeQRCode = 1 << 5,
    MDShareTypeClipboard = 1 << 6
};

typedef NS_ENUM(NSInteger, MDShareLoginStatus) {
    MDShareLoginStatusSuccess = 0,
    MDShareLoginStatusFail = 1
};

typedef NS_ENUM(NSInteger, MDShareAuthorizeStatus) {
    MDShareAuthorizeStatusSuccess = 0,
    MDShareAuthorizeStatusFail = 1
};

typedef NS_ENUM(NSInteger, MDShareStatus) {
    MDShareStatusSuccess = 0,
    MDShareStatusFail = 1
};

#define MDShareTypeMisc (MDShareTypeWeChatTimeline | MDShareTypeWeChatSession | MDShareTypeWeibo | MDShareTypeQQ | MDShareTypeQRCode)

@protocol MDShareServiceDelegate <NSObject>

@end

typedef void (^MDShareAuthorizeCompletion)(MDShareAuthorizeStatus authorizedStatus);
typedef void (^MDShareLoginCompletion)(MDShareLoginStatus authorizedStatus, UMSocialAccountEntity *userInfo);
typedef void (^MDShareCompletion)(MDShareStatus status);
typedef void (^MDSharePrepare)(MDShareItem *shareItem);

@interface MDShareService : NSObject

@property (nonatomic, weak) id<MDShareServiceDelegate> delegate;

/**
 *  三方应用是否已经安装
 *
 *  @param shareType 分享类型
 *
 *  @return 如果安装返回YES，反之
 */

+ (BOOL)isThirdPartyInstalled:(MDShareType)shareType;

+ (instancetype)sharedInstance;

/**
 *  初始化设置App Key和App Secret
 */
- (void)setup;

/**
 *  是否支持此分享类型
 *
 *  @param shareType 分享类型
 *
 *  @return 支持返回YES，反之
 */
- (BOOL)isShareTypeEnabled:(MDShareType)shareType;

/**
 *  是否已授权
 *
 *  @param shareType 分享类型
 *
 *  @return 如果已授权则返回YES，反之
 */
- (BOOL)isIndividualAuthorized:(MDShareType)shareType;

/**
 *  能否单独进行授权操作
 *
 *  @param shareType 分享类型
 *
 *  @return 如果能够进行单独授权返回YES，反之
 */
- (BOOL)canIndividualAuthorized:(MDShareType)shareType;

/**
 *  授权成功或者失败处理
 *
 *  @param shareType 分享类型
 *  @param completion 分享回调block
 */
- (void)authorize:(MDShareType)shareType withCompletion:(MDShareAuthorizeCompletion)completion;
/**
 *  分享内容
 *
 *  @param shareItem  分享item
 *  @param shareTypes 分享类型
 *  @param completion 分享后会回调
 */
- (void)shareContent:(MDShareItem *)shareItemBefore
            withType:(NSInteger)shareTypesBefore
      withCompletion:(MDShareCompletion)completion;

/**
 *  三方登录
 *
 *  @param shareType  三方登录类型
 *  @param completion 登录后回调
 */
- (void)login:(MDShareType)shareTypes withCompletion:(MDShareLoginCompletion)completion;
/**
 *  是否由外部分享唤起
 */
+ (BOOL)isFromShareScheme:(NSURL *)url;
/**
 *  封装分享唤起
 *
 *  @param url url
 */
+ (BOOL)openURL:(NSURL *)url;


@end
