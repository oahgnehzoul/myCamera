//
//  MDUtil.h
//  MeiMeiDa
//
//  Created by Jason Wong on 15/5/7.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MDCityItem.h"
//#import "MDRegexUtil.h"

void md_dispatch_sync_on_main_thread(dispatch_block_t block);
void md_dispatch_async_on_global_thread(dispatch_block_t block);
void md_perform_block_on_main_thread_delay(dispatch_block_t block, NSTimeInterval delayInSeconds);

typedef NS_OPTIONS(NSUInteger, MDEnvType) {
    MDEnvTypeRelease    = 1 << 0,
    MDEnvTypeDeveloper  = 1 << 1,
    MDEnvTypePrerelease = 1 << 2
};

typedef NS_ENUM(NSUInteger, MDItemType) {
    MDItemTypeCustomer = 1, //上门
    MDItemTypeShop = 2, //到店
    MDItemTypeOnline = 3, //在线
    MDItemTypeDelivery = 4 //邮寄
};

typedef NS_ENUM(NSInteger, MDItemScopeType) {
    MDItemScopeTypeGlobal = 0,
    MDItemScopeTypeSquare = 1
};

@interface MDUtil : NSObject

/**
 *  是否是开发环境
 *
 *  @return BOOL
 */
+ (MDEnvType)env;
+ (void)clearUserInfo;
//+ (CLLocationCoordinate2D)userCoordinate;
//+ (void)setUserCoordinate:(CLLocationCoordinate2D)coordinate;
+ (NSString *)urlEncode:(NSString *)aString;
+ (NSString *)urlEncodeIgnoreURLSymbol:(NSString *)aString;
+ (NSString *)urlDecode:(NSString *)aString;
+ (NSString *)md5:(id)aString;
+ (NSString *)signWithTime:(NSInteger)time;
+ (NSString *)shortNumber:(NSInteger)number;
+ (NSString *)version;
+ (NSInteger)buindVersion;
+ (void)setDefaultsUserAgent:(NSString *)userAgent;
+ (NSString *)defaultsUserAgent;
+ (NSString *)userAgent;
+ (NSString *)udid;
+ (void)storeUserPhone:(NSString *)phone;
+ (void)storeUserToken:(NSString *)token;
+ (void)storeDeviceToken:(NSString *)deviceToken;
+ (void)storeUserId:(NSString *)userId;
+ (NSString *)userId;
+ (NSString *)userPhone;
+ (NSString *)userToken;
+ (NSString *)deviceToken;
+ (void)storeCookieWithKey:(NSString *)key value:(NSString *)value;
+ (void)storeCookieWithKey:(NSString *)key value:(NSString *)value domain:(NSString *)domain;
+ (void)removeCookieWithKey:(NSString *)key;
+ (void)removeAllCookies;
+ (void)logout;
+ (BOOL)isLogined;
+ (NSString *)urlWithAPIName:(NSString *)apiName;
+ (NSString *)getAPINameFromURL:(NSString *)url;

+ (UIImage *)shotWithView:(UIView *)view;
+ (UIImage *)createImageWithColor:(UIColor *)color;
+ (UIImage *)defaultBannerImage;
+ (NSDictionary *)HTTPHeaders;
+ (NSString *)imageStringWith:(NSString *)urlPath scaleSize:(CGSize)size;
+ (NSURL *)imageURLWith:(NSString *)urlPath scaleSize:(CGSize)size;
+ (CGSize)imageSize:(NSString *)urlPath defaultSize:(CGSize)defaultSize;
+ (NSString *)generateURL:(NSString *)relativePath isMobile:(BOOL)isMobile;
+ (NSString *)supportURL:(NSString *)relativePath;
+ (NSString *)shareURL:(NSString *)relativePath;
+ (NSDictionary *)getParamsFromURLQuery:(NSString *)URLQuery;
+ (BOOL)isSafeHost:(NSString *)host;
+ (NSString *)getNativeSchemeURLFromWeb:(NSURL *)url;

// 1:上门服务，2:到店服务，3:在线服务，4:邮寄服务
+ (NSString *)tagNameWithServiceType:(NSInteger)serviceType;
// YES 有现货 NO 需定做
+ (NSString *)tagNameWithSpot:(BOOL)isSpot;
/**
 *  严格格式化价格
 *
 *  @example 10000->100, 10050->100.5, 10005->100.05
 *
 *  @param price 以分计数的金额
 *
 *  @return 格式化后的字符串
 */
+ (NSString *)getPriceStrict:(NSString *)price;
+ (NSString *)getPriceStrictByInteger:(NSInteger)price;

/**
 *  获取设备屏幕信息
 *
 *  @return 以逗号分割的宽度和高度
 */
+ (NSString *)getResolution;
/**
 *  获取当前网络类型
 *
 *  @return 1为wifi，6为蜂窝网络
 */
+ (NSString *)getNetworkType;

+ (NSString *)urlParamValueWithURL:(NSString*)url paramName:(NSString *)paramName;

+ (BOOL)checkLocationEnabled;

+ (UIView *)emptyViewWithImageName:(NSString *)imageName subText:(NSString *)subText height:(CGFloat)height;
+ (UIView *)emptyViewWithIconName:(NSString *)iconName subText:(NSString *)subText height:(CGFloat)height;
+ (UIView *)emptyViewWithIconName:(NSString *)iconName
                          subText:(NSString *)subText
                  backgroundColor:(UIColor *)backgroundColor
                         iconSize:(CGFloat)iconSize
                       iconOffset:(CGFloat)iconOffset
                           height:(CGFloat)height;

/**
 *  根据指定size，对image进行缩放
 *
 *  @param image   UIimage
 *  @param newSize 大小
 *
 *  @return UIimage
 */
+ (UIImage *)imageWithImage:(UIImage *)image
          scaledToFitToSize:(CGSize)newSize;

/**
 *  对size进行缩放，宽高按照比例不超过targetSize
 *
 *  @param size       原size
 *  @param targetSize 目标size
 *
 *  @return CGSize 新的size
 */
+ (CGSize)sizeFit:(CGSize)size targetSize:(CGSize)targetSize;

/**
 *  缩放七牛图片
 *
 *  @param urlPath url
 *  @param size    size
 *
 *  @return NSURL
 */
+ (NSURL *)qiNiuimageURLWith:(NSString *)urlPath size:(CGSize)size;

/**
 *  缩放来往图片
 *
 *  @param urlPath url
 *  @param size    size
 *
 *  @return NSURL
 */
+ (NSURL *)lwImageURLWith:(NSString *)urlPath size:(CGSize)size;

/**
 *  当前显示UI的window
 *
 *  @return UIWindow
 */
+ (UIWindow *)mainWindow;

+ (NSString *)macString;

+ (NSString *)idfaString;

+ (NSString *)idfvString;
@end
