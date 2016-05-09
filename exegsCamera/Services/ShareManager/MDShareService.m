//
//  MDShareService.m
//  MeiMeiDa
//
//  Created by Yulin Ding on 6/24/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDShareService.h"
#import "MDShareQRCodeView.h"
#import <TencentOpenAPI/QQApiInterface.h>       //QQ互联 SDK
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@implementation MDShareService

+ (BOOL)isThirdPartyInstalled:(MDShareType)shareType {
    if (shareType == MDShareTypeWeChatTimeline ||
        shareType == MDShareTypeWeChatSession) {
        return [WXApi isWXAppInstalled];
    } else if (shareType == MDShareTypeQQ ||
               shareType == MDShareTypeQZone) {
        return [QQApiInterface isQQInstalled];
    } else if (shareType == MDShareTypeWeibo) {
        return [WeiboSDK isWeiboAppInstalled];
    }
    
    return YES;
}

+ (instancetype)sharedInstance {
    static MDShareService *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)setup {
    [UMSocialData setAppKey:kMDUMengAppKey];
    [UMSocialWechatHandler setWXAppId:kMDWeChatAppKey appSecret:kMDWeChatAppSecret url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:kMDQQAppId appKey:kMDQQAppKey url:@"http://www.umeng.com/social"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:kMDWeiboAuthCallback];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kMDWeiboAppKey secret:kMDWeiboAppSecret RedirectURL:kMDWeiboAuthCallback];
}

- (BOOL)isShareTypeEnabled:(MDShareType)shareType {
    return NO;
}

- (BOOL)isIndividualAuthorized:(MDShareType)shareType {
    if (shareType == MDShareTypeWeibo) {
        return [UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina];
    }
    
    return NO;
}

- (BOOL)canIndividualAuthorized:(MDShareType)shareType {
    return NO;
}

- (void)authorize:(MDShareType)shareType withCompletion:(MDShareAuthorizeCompletion)completion {
    //TODO
}

- (void)shareContent:(MDShareItem *)shareItem
            withType:(NSInteger)shareTypes
      withCompletion:(MDShareCompletion)completion {

    if (shareTypes & MDShareTypeWeibo) {
        if (![UMSocialAccountManager isOauthAndTokenNotExpired:UMShareToSina]) {
            [[MDShareService sharedInstance] login:MDShareTypeWeibo withCompletion:^(MDShareLoginStatus status, UMSocialAccountEntity *userInfo) {
                if (status == MDShareLoginStatusSuccess) {
                    [self publish:shareItem
                         withType:shareTypes
                   withCompletion:completion];
                } else {
                    if (completion) {
                        completion(MDShareStatusFail);
                    }
                }
            }];
        } else {
            [self publish:shareItem
                 withType:shareTypes
           withCompletion:completion];
        }
    } else {
        [self publish:shareItem
             withType:shareTypes
       withCompletion:completion];
    }
    
}

- (void)publish:(MDShareItem *)shareItemBefore
            withType:(NSInteger)shareTypesBefore
      withCompletion:(MDShareCompletion)completion {
    
    __block NSInteger shareTypes = shareTypesBefore;
    
    [self serializeShareItem:shareItemBefore withCompletion:^(MDShareItem *shareItem) {
        NSMutableArray *SNSShareTypes = [@[] mutableCopy];
        NSString *shareContent = nil;
        MDShareType individualType = MDShareTypeWeChatTimeline;
    
        if (shareTypes & MDShareTypeClipboard) {
            UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
            appPasteBoard.persistent = YES;
            [appPasteBoard setString:shareItem.url.length > 0 ? shareItem.url : [MDUtil supportURL:@""]];
            
            UIViewController *vc = [UIViewController currentViewController];
            if (vc) {
                MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                progressHUD.labelText = @"复制成功";
                progressHUD.mode = MBProgressHUDModeText;
                [progressHUD show:NO];
                [progressHUD hide:YES afterDelay:1];
            }
            
            if (completion) {
                completion(MDShareStatusSuccess);
            }
            
            return;
        }
    
        if (shareTypes & MDShareTypeQRCode) {
            [MDShareQRCodeView presentInView:[[UIApplication sharedApplication] keyWindow]
                                   shareItem:shareItem
                                    animated:YES];
            
            if (completion) {
                completion(MDShareStatusSuccess);
            }
            
            return;
        }
        
        if (shareTypes & MDShareTypeWeibo) {
            individualType = MDShareTypeWeibo;
            [SNSShareTypes addObject:UMShareToSina];
            shareContent = [NSString stringWithFormat:@"%@ %@ %@", shareItem.title, shareItem.content ?:@"", shareItem.url];
            
            //新版本微博sdk不再支持静默分享
            [self publishWeibo:shareItem
                       content:shareContent
                withCompletion:^(MDShareStatus status) {
                    if (shareTypes != MDShareTypeWeibo) {
                        shareTypes = shareTypes^MDShareTypeWeibo;
                        [self publish:shareItem
                             withType:shareTypes
                       withCompletion:completion];
                    }
                }];
            
            return;
        }
    
        UMSocialUrlResource *urlResource = nil;
        if (shareTypes & MDShareTypeWeChatTimeline) {
            [UMSocialData defaultData].extConfig.wxMessageType = shareItem.wxMessageAppType ? UMSocialWXMessageTypeApp: UMSocialWXMessageTypeWeb;
            
            [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareItem.url;
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareItem.title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.extInfo = shareItem.extInfo;
            
            shareContent = shareItem.content;
            [SNSShareTypes addObject:UMShareToWechatTimeline];
        }
        
        if (shareTypes & MDShareTypeWeChatSession) {
            [UMSocialData defaultData].extConfig.wxMessageType = shareItem.wxMessageAppType ? UMSocialWXMessageTypeApp: UMSocialWXMessageTypeWeb;
            
            [UMSocialData defaultData].extConfig.wechatSessionData.url = shareItem.url;
            [UMSocialData defaultData].extConfig.wechatSessionData.title = shareItem.title;
            [UMSocialData defaultData].extConfig.wechatTimelineData.extInfo = shareItem.extInfo;
            
            shareContent = shareItem.content;
            [SNSShareTypes addObject:UMShareToWechatSession];
            individualType = MDShareTypeWeChatSession;
        }
        
        if (shareTypes & MDShareTypeQQ) {
            [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
            [UMSocialData defaultData].extConfig.qqData.url = shareItem.url;
            [UMSocialData defaultData].extConfig.qqData.title = shareItem.title;
           
            shareContent = shareItem.content;
            individualType = MDShareTypeQQ;
            [SNSShareTypes addObject:UMShareToQQ];
            
            urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:
                                                shareItem.url];
        }
       
        
        [[UMSocialDataService defaultDataService]
         postSNSWithTypes:SNSShareTypes
         content:shareContent
         image:shareItem.image
         location:nil
         urlResource:urlResource
         presentedController:nil
         completion:^(UMSocialResponseEntity *response){
             if (response.responseCode == UMSResponseCodeSuccess) {
                 if (completion) {
                     completion(MDShareStatusSuccess);
                 }
                 NSLog(@"分享成功！");
             } else {
                 if (completion) {
                     completion(MDShareStatusFail);
                 }
             }
         }];
    }];
}

- (void)publishWeibo:(MDShareItem *)shareItem
             content:(NSString *)shareContent
      withCompletion:(MDShareCompletion)completion {
    
    if (shareContent.length > 140) {
        shareContent = [NSString stringWithFormat:@"%@...", [shareContent substringToIndex:136]];
    }
    
    [[UMSocialDataService defaultDataService]
     postSNSWithTypes:@[UMShareToSina]
     content:shareContent
     image:shareItem.image
     location:nil
     urlResource:nil
     presentedController:nil
     completion:^(UMSocialResponseEntity *response){
         UIViewController *vc = [UIViewController currentViewController];
         if (vc) {
             if (vc) {
                 MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:vc.view animated:YES];
                 progressHUD.labelText = response.responseCode == UMSResponseCodeSuccess ? @"成功分享到新浪微博" : @"分享到新浪微博失败，请重新尝试";
                 progressHUD.mode = MBProgressHUDModeText;
                 [progressHUD show:NO];
                 [progressHUD hide:YES afterDelay:1];
             }
         }
         if (completion) {
             completion(response.responseCode == UMSResponseCodeSuccess ? MDShareStatusSuccess : MDShareStatusFail);
         }
     }];
}

- (void)serializeShareItem:(MDShareItem *)shareItem
            withCompletion:(void (^)(MDShareItem *shareItem))completion {
    if (shareItem.imageURL.length == 0 &&
        !shareItem.image) {
        shareItem.image = [UIImage imageNamed:@"MDShareIcon"];
    }
    
    if (shareItem.image) {
        completion(shareItem);
    } else if (shareItem.imageURL) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:shareItem.imageURL]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 //NOTHING
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                if (image) {
                                    shareItem.image = image;
                                }
                                completion(shareItem);
                            }];
    }
}

- (void)login:(MDShareType)shareTypes withCompletion:(MDShareLoginCompletion)completion {
    UIViewController *vc = [UIViewController currentViewController];
    if (shareTypes & MDShareTypeQQ) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
        snsPlatform.loginClickHandler(vc, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
                if (completion) {
                    completion(MDShareLoginStatusSuccess, snsAccount);
                }
            } else {
                if (completion) {
                    completion(MDShareLoginStatusFail, nil);
                }
            }
        });
    } else if (shareTypes & MDShareTypeWeChatSession) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
        snsPlatform.loginClickHandler(vc,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
                if (completion) {
                    completion(MDShareLoginStatusSuccess, snsAccount);
                }
            } else {
                if (completion) {
                    completion(MDShareLoginStatusFail, nil);
                }
            }
        });
    } else if (shareTypes & MDShareTypeWeibo) {
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
        snsPlatform.loginClickHandler(vc, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
                if (completion) {
                    completion(MDShareLoginStatusSuccess, snsAccount);
                }
            } else {
                if (completion) {
                    completion(MDShareLoginStatusFail, nil);
                }
            }
        });
    
    }
}

+ (BOOL)isFromShareScheme:(NSURL *)url {
    return [url.scheme isEqualToString:kMDWeChatAppKey] || [url.scheme isEqualToString:kMDQQAppScheme] || [url.scheme isEqualToString:kMDQQAppScheme2] || [url.scheme isEqualToString:kMDWeiboAppScheme] || [url.scheme isEqualToString:kMDWeiboUMengAppScheme];
//    return YES;
}

+ (BOOL)openURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}

@end
