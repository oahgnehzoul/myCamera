//
//  MDUtil.m
//  MeiMeiDa
//
//  Created by Jason Wong on 15/5/7.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import "MDUtil.h"
//#import "MDTongDunService.h"
#import <CommonCrypto/CommonDigest.h>
//#import "SSKeychain.h"
//#import "OpenUDID.h"
//#import <LWIMKit/IMEngine.h>
//#import <Reachability.h>

//#include <sys/socket.h>
//#include <sys/sysctl.h>
//#include <net/if.h>
//#include <net/if_dl.h>

//for idfa
//#import <AdSupport/AdSupport.h>

void md_dispatch_sync_on_main_thread(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void md_dispatch_async_on_global_thread(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void md_perform_block_on_main_thread_delay(dispatch_block_t block, NSTimeInterval delayInSeconds) {
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), block);
}

@implementation MDUtil

+ (MDEnvType)env {
#ifdef kMDEnvPre
    return MDEnvTypePrerelease;
#endif 
    
#ifdef kMDEnvDev
    return MDEnvTypeDeveloper;
#endif
    
    return MDEnvTypeRelease;
}

//+ (void)clearUserInfo {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:kDefaultUserLatitude];
//    [defaults removeObjectForKey:kDefaultUserLongitude];
//    
//    [defaults synchronize];
//}
//
//+ (CLLocationCoordinate2D)userCoordinate {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    return CLLocationCoordinate2DMake([defaults floatForKey:kDefaultUserLatitude],
//                                      [defaults floatForKey:kDefaultUserLongitude]);
//}
//
//+ (void)setUserCoordinate:(CLLocationCoordinate2D)coordinate {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setFloat:coordinate.latitude  forKey:kDefaultUserLatitude];
//    [defaults setFloat:coordinate.longitude forKey:kDefaultUserLongitude];
//    [defaults synchronize];
//}

+ (NSString *)urlEncode:(NSString *)aString {
    if (!aString) {
        return @"";
    }
    
    CFStringRef cfEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                          (CFStringRef)aString,NULL,
                                                                          (CFStringRef)@"!#$%&'()*+,/:;=?@[]",
                                                                          kCFStringEncodingUTF8);
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString*)cfEncodedString];
    CFRelease(cfEncodedString);
    
    return urlEncoded;
}

+ (NSString *)urlEncodeIgnoreURLSymbol:(NSString *)aString {
    if (!aString) {
        return @"";
    }
    
    CFStringRef cfEncodedString = CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                          (CFStringRef)aString,NULL,
                                                                          (CFStringRef)@"!$%'()*+,;@[]",
                                                                          kCFStringEncodingUTF8);
    NSString *urlEncoded = [NSString stringWithString:(__bridge NSString*)cfEncodedString];
    CFRelease(cfEncodedString);
    
    return urlEncoded;
}

+ (NSString *)urlDecode:(NSString *)aString {
    NSString *result = [(NSString *)aString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (NSString *)md5:(id)obj {
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *aString = (NSString *)obj;
        const char *cStr = [aString UTF8String];
        
        unsigned char result[16];
        CC_MD5(cStr, (int)strlen(cStr), result); // This is the md5 call
        return [NSString stringWithFormat:
                @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]];
    } else if ([obj isKindOfClass:[NSData class]]) {
        unsigned char result[CC_MD5_DIGEST_LENGTH];
        NSData *input = (NSData *)obj;
        CC_MD5(input.bytes, (int)input.length, result);
        NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
        for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
            [ret appendFormat:@"%02x",result[i]];
        }
        return ret;
    } else {
        return @"";
    }
}

+ (NSString *)signWithTime:(NSInteger)time {
    NSString *str = [NSString stringWithFormat:@"133ff1e10a8b244767ef734fb86f37fd%ldsync", (long)time];
    return [self md5:str];
}

+ (NSString *)shortNumber:(NSInteger)number {
    NSString *key = @"6BCMx(0gEwTj3FbUGPe7rtKfqosmZOX2S)5IvH.zu9DdQRL41AnV8ckylhp!YNWJi";
    NSUInteger l = [key length];
    NSMutableString *s = [NSMutableString string];
    
    while (number > 0) {
        NSUInteger x = number % l;
        number = floor(number / l);
        [s insertString:[key substringWithRange:NSMakeRange(x, 1)] atIndex:0];
    }
    
    return s;
}

+ (NSString *)version {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSInteger)buindVersion {
    return [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] integerValue];
}

//+ (void)setDefaultsUserAgent:(NSString *)userAgent {
//    [[NSUserDefaults standardUserDefaults] setObject:userAgent forKey:kDefaultsUserAgent];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

//+ (NSString *)defaultsUserAgent {
//    NSString *ua = [[NSUserDefaults standardUserDefaults] stringForKey:kDefaultsUserAgent];
//    return ua ?: @"Mozilla/5.0 AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 Safari/8536.2 Fake_UA";
//}
//
//+ (NSString *)udid {
//    return [OpenUDID value] ?: @"None";
//}

+ (NSString *)userAgent {
    UIDevice *device = [UIDevice currentDevice];
    return [NSString stringWithFormat:@"KongGe/%@ (%@; %@, %@-%@; %@) %@", [MDUtil version], device.model, [MDUtil urlEncode:device.name], device.systemName, device.systemVersion, [[NSLocale preferredLanguages] objectAtIndex:0] ?: @"Unknown",  @"Mozilla/5.0 AppleWebKit/600.1.4 (KHTML, like Gecko) Mobile/12F70 Safari/8536.2 Fake_UA"];
}

//+ (void)storeUserPhone:(NSString *)phone {
//    if (!phone) {
//        [SSKeychain deletePasswordForService:kDefaultServiceName account:kDefaultUserPhone];
//        [[MDMemoryCacheService sharedInstance] removeObjectForKey:kDefaultUserPhone];
//    } else {
//        [SSKeychain setPassword:phone forService:kDefaultServiceName account:kDefaultUserPhone];
//        [[MDMemoryCacheService sharedInstance] setObject:phone forKey:kDefaultUserPhone];
//    }
//}
//
//+ (void)storeUserToken:(NSString *)token {
//    if (!token) {
//        [SSKeychain deletePasswordForService:kDefaultServiceName account:kDefaultUserToken];
//        [[MDMemoryCacheService sharedInstance] removeObjectForKey:kDefaultUserToken];
//    } else {
//        [SSKeychain setPassword:token forService:kDefaultServiceName account:kDefaultUserToken];
//        [[MDMemoryCacheService sharedInstance] setObject:token forKey:kDefaultUserToken];
//    }
//}
//
//+ (void)storeDeviceToken:(NSString *)deviceToken {
//    [SSKeychain setPassword:deviceToken forService:kDefaultServiceName account:kDefaultDeviceToken];
//    [[MDMemoryCacheService sharedInstance] setObject:deviceToken forKey:kDefaultDeviceToken];
//}

//+ (void)storeUserId:(NSString *)userId {
//    if (!userId) {
//        [SSKeychain deletePasswordForService:kDefaultServiceName account:kDefaultUserId];
//        [[MDMemoryCacheService sharedInstance] removeObjectForKey:kDefaultUserId];
//    } else {
//        [SSKeychain setPassword:[NSString stringWithFormat:@"%@", userId] forService:kDefaultServiceName account:kDefaultUserId];
//        [[MDMemoryCacheService sharedInstance] setObject:[NSString stringWithFormat:@"%@", userId] forKey:kDefaultUserId];
//    }
//}

//+ (NSString *)userId {
//    if (![self isLogined]) {
//        return nil;
//    }
//    
//    NSString *x = [[MDMemoryCacheService sharedInstance] objectForKey:kDefaultUserId];
//    if (!x) {
//        x = [SSKeychain passwordForService:kDefaultServiceName account:kDefaultUserId];
//        
//        if (x) {
//            [[MDMemoryCacheService sharedInstance] setObject:x forKey:kDefaultUserId];
//        }
//    }
//    
//    return x;
//}
//
//+ (NSString *)deviceToken {
//    NSString *x = [[MDMemoryCacheService sharedInstance] objectForKey:kDefaultDeviceToken];
//   
//    if (!x) {
//        x = [SSKeychain passwordForService:kDefaultServiceName account:kDefaultDeviceToken];
//        
//        if (x) {
//            [[MDMemoryCacheService sharedInstance] setObject:x forKey:kDefaultDeviceToken];
//        }
//    }
//    
//    return x;
//}
//
//+ (NSString *)userToken {
//    NSString *x = [[MDMemoryCacheService sharedInstance] objectForKey:kDefaultUserToken];
//    
//    if (!x) {
//        x = [SSKeychain passwordForService:kDefaultServiceName account:kDefaultUserToken];
//        
//        if (x) {
//            [[MDMemoryCacheService sharedInstance] setObject:x forKey:kDefaultUserToken];
//        }
//    }
//    
//    return x;
//}
//
//+ (NSString *)userPhone {
//    NSString *x = [[MDMemoryCacheService sharedInstance] objectForKey:kDefaultUserPhone];
//    
//    if (!x) {
//        x = [SSKeychain passwordForService:kDefaultServiceName account:kDefaultUserPhone];
//        
//        if (x) {
//            [[MDMemoryCacheService sharedInstance] setObject:x forKey:kDefaultUserPhone];
//        }
//    }
//    
//    return x;
//}

+ (void)storeCookieWithKey:(NSString *)key value:(NSString *)value {
    [self storeCookieWithKey:key value:value domain:@"shenghuozhe.net"];
    [self storeCookieWithKey:key value:value domain:@".shenghuozhe.net"];
    [self storeCookieWithKey:key value:value domain:@"kongge.com"];
    [self storeCookieWithKey:key value:value domain:@".kongge.com"];
}

+ (void)storeCookieWithKey:(NSString *)key
                     value:(NSString *)value
                    domain:(NSString *)domain {
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:key forKey:NSHTTPCookieName];
    [cookieProperties setObject:value forKey:NSHTTPCookieValue];
    [cookieProperties setObject:domain forKey:NSHTTPCookieDomain];
//    [cookieProperties setObject:domain forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:[NSDate dateWithTimeIntervalSinceNow:10*365*24*60*60] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

+ (void)removeCookieWithKey:(NSString *)key {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies){
        if (([[[cookie properties] objectForKey:NSHTTPCookieDomain] hasSuffix:@"shenghuozhe.net"] || [[[cookie properties] objectForKey:NSHTTPCookieDomain] hasSuffix:@"kongge.com"]) &&
            [[[cookie properties] objectForKey:NSHTTPCookieName] isEqualToString:key]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

+ (void)removeAllCookies {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies){
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        if ([[[cookie properties] objectForKey:NSHTTPCookieDomain] hasSuffix:@"shenghuozhe.net"] || [[[cookie properties] objectForKey:NSHTTPCookieDomain] hasSuffix:@"kongge.com"]) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}

//+ (void)logout {
//    [MDUtil storeUserPhone:nil];
//    [MDUtil storeUserId:nil];
//    [MDUtil storeUserToken:nil];
//    [MDUtil removeAllCookies];
////    [MDUtil removeCookieWithKey:@"sid"];
//    [[[IMEngine sharedIMEngine] apnsService] unregisterDevice:[MDUtil deviceToken] successBlock:nil failureBlock:nil];
//}

+ (BOOL)isLogined {
    return !![self userToken];
}

+ (NSString *)baseAPIURL {
    MDEnvType env = [self env];
    NSString *baseURL = env == MDEnvTypeRelease ?
                        @"http://lb.kongge.com" : (env == MDEnvTypePrerelease ?
                        @"http://pre-lb.kongge.com" :
//                                                   @"10.8.8.68:11001":
                        @"http://webdev1.shenghuozhe.net");
    
    return baseURL;
}

+ (NSString *)urlWithAPIName:(NSString *)apiName {
    return [NSString stringWithFormat:@"%@%@", [self baseAPIURL], apiName];
}

+ (NSString *)supportURL:(NSString *)relativePath {
    return [self generateURL:relativePath isMobile:NO];
}

+ (NSString *)shareURL:(NSString *)relativePath {
    return [self generateURL:relativePath isMobile:YES];
}

//+ (NSString *)generateURL:(NSString *)relativePath isMobile:(BOOL)isMobile {
//    NSString *originalHost = isMobile ? @"http://m.kongge.com" : @"http://www.kongge.com";
//    NSString *str = [NSString stringWithFormat:@"%@%@", originalHost, relativePath];
//    if ([relativePath hasPrefix:@"http://"]) {
//        str = relativePath;
//    }
//    NSURL *url = [NSURL URLWithString:str];
//    NSString *ret = [NSString stringWithFormat:@"%@%@%@", str, url.query.length > 0 ? @"&" : @"?", [NSString stringWithFormat:@"suid=%@&appid=%@&version=%@", [MDUserService user] ? [MDUserService user].userId : @"", @"1", [MDUtil version]]];
//    return ret;
//}

+ (NSString *)getAPINameFromURL:(NSString *)url {
    NSString *baseURL = [NSString stringWithFormat:@"%@/", [self baseAPIURL]];
    NSString *ret = nil;
    if (url.length > 0 && [url hasPrefix:baseURL]) {
        ret = [url substringFromIndex:baseURL.length];
    }
    
    return ret;
}

+ (NSDictionary *)getParamsFromURLQuery:(NSString *)URLQuery {
    NSMutableDictionary *params = [@{} mutableCopy];
    
    for (NSString *param in [URLQuery componentsSeparatedByString:@"&"]) {
        NSArray *paramPair = [param componentsSeparatedByString:@"="];
        if([paramPair count] < 2) {
            continue;
        }
        [params setObject:[paramPair lastObject] forKey:[paramPair firstObject]];
    }
    
    return [params copy];
}

+ (BOOL)isSafeHost:(NSString *)host {
    return [host hasSuffix:@"shenghuozhe.net"] ||
            [host hasSuffix:@"kongge.com"] ||
            [host hasSuffix:@"kongge.life"];
}

+ (NSString *)getNativeSchemeURLFromWeb:(NSURL *)url {
    __block NSString *ret = @"";
    NSArray *maps = @[@{@"match" : @"item.html", @"url" : @"detail/:id", @"params" : @[@"id"]},
                      @{@"match" : @"user.html", @"url" : @"user/:id", @"params" : @[@"id"]},
                      @{@"match" : @"order/cashier", @"url" : @"cashier/:sellerId", @"params" : @[@"sellerId"]},
                      ];
    
    if (![self isSafeHost:url.host]) {
        return  ret;
    }
    
    if (url.path.length > 0) {
        [maps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *dict = (NSDictionary *)obj;
            if ([url.path hasSuffix:dict[@"match"]]) {
                ret = dict[@"url"];
                if (dict[@"params"] && url.query.length > 0) {
                    NSArray *requiredParams = (NSArray *)dict[@"params"];
                    NSDictionary *inputParams = [self getParamsFromURLQuery:url.query];
                    [requiredParams enumerateObjectsUsingBlock:^(id item, NSUInteger iidx, BOOL *iStop) {
                        NSString *paramKey = (NSString *)item;
                        if (inputParams[paramKey]) {
                            ret = [ret stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@":%@", paramKey] withString:inputParams[paramKey]];
                        }
                    }];
                }
                
                *stop = YES;
                return;
            }
        }];
    }
    
    return ret;
}

+ (UIImage *)shotWithView:(UIView *)view {
//    BOOL retina = !!UIGraphicsBeginImageContextWithOptions;
    BOOL retina = YES;
    CGSize size = view.size;
    
    if (retina) {
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 24.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)defaultBannerImage {
    return [self createImageWithColor:[UIColor colorWithHexString:kMDColorBaseLevel6]];
}

//+ (NSDictionary *)HTTPHeaders {
//    return @{
//             @"User-Agent": [MDUtil userAgent],
//             @"X-SHZ-AppId": @"1",
//             @"X-SHZ-UDID": [MDUtil udid],
//             @"X-SHX-Enterprise": [NSString stringWithFormat:@"%@", kMDAppType ?: @""],
//             @"X-SHZ-Token": [MDUtil userToken] ?: @"",
//             @"X-SHZ-DeviceId": [MDUtil deviceToken] ? [NSString stringWithFormat:@"%@:%@", [MDUtil deviceToken], kMDAppType] : @"",
//             @"X-SHZ-Coordinate": [NSString stringWithFormat:@"%.6f,%.6f%@", [MDUtil userCoordinate].latitude, [MDUtil userCoordinate].longitude, [MDUserService locationCity] ? [NSString stringWithFormat:@",%@", [MDUserService locationCity].code] : @""],
//             @"X-SHZ-Resolution": [self getResolution],
//             @"X-SHZ-Net": [self getNetworkType],
//             @"X-SHZ-ChannelName": @"AppStore",
//             @"X-SHZ-Identifier": [MDUtil idfaString],
//             @"X-SHZ-BBId": [[MDTongDunService sharedInstance] getInfo]
//             };
//}

+ (NSURL *)imageURLWith:(NSString *)urlPath scaleSize:(CGSize)size {
    if ([urlPath hasSuffix:@"Q.jpg"]) {
        return [NSURL URLWithString:urlPath];
    }
    
    NSString *newUrlPath = [self imageStringWith:urlPath scaleSize:size];
    return [NSURL URLWithString:newUrlPath];
}

+ (NSString *)imageStringWith:(NSString *)urlPath scaleSize:(CGSize)size {
    if ([urlPath hasSuffix:@"Q.jpg"]) {
        return urlPath;
    }
    
    return [NSString stringWithFormat:@"%@@%.fw_%.fh_95Q.jpg", urlPath, fabs(size.width), fabs(size.height)];
}

//+ (CGSize)imageSize:(NSString *)urlPath defaultSize:(CGSize)defaultSize {
//    CGSize ret = defaultSize;
//    
//    NSString *regex = @"(\\d+)w_(\\d+)h";
//    NSArray *matches = [MDRegexUtil string:urlPath matches:regex ignoreCase:YES isDetail:YES];
//    
//    if ([matches count] > 0) {
//        NSTextCheckingResult *match = matches[0];
//        NSRange widthRange = [match rangeAtIndex:1];
//        NSRange heightRange = [match rangeAtIndex:2];
//        if (widthRange.length > 0 &&
//            heightRange.length > 0) {
//            NSString *w = [urlPath substringWithRange:widthRange];
//            NSString *h = [urlPath substringWithRange:heightRange];
//            ret = (CGSize){[w integerValue], [h integerValue]};
//        }
//    }
//    
//    return ret;
//}

// 1:上门服务，2:到店服务，3:在线服务，4:邮寄服务
+ (NSString *)tagNameWithServiceType:(NSInteger)serviceType {
    if (serviceType == MDItemTypeCustomer) {
        return @"上门";
    }
    
    if (serviceType == MDItemTypeShop) {
        return @"到店";
    }
    
    if (serviceType == MDItemTypeOnline) {
        return @"线上";
    }
    
    return @"邮寄";
}

+ (NSString *)tagNameWithSpot:(BOOL)isSpot {
    return isSpot ? @"有现货" : @"需定制";
}

+ (NSString *)getPriceStrict:(NSString *)price {
    NSString *ret;
    //考虑 price = 1010.999999的情况
    NSInteger priceInCent =  (NSInteger)round([price integerValue]);
    if (priceInCent%100 != 0) {
        ret = [NSString stringWithFormat:priceInCent%10 == 0?@"%0.1f":@"%0.2f", priceInCent/100.0];
    } else {
        ret = [NSString stringWithFormat:@"%ld", (long)(priceInCent / 100)];
    }
    return ret;
}

+ (NSString *)getPriceStrictByInteger:(NSInteger)price {
    NSString *str = [NSString stringWithFormat:@"%ld", (long)price];
    return [self getPriceStrict:str];
}

+ (NSString *)urlParamValueWithURL:(NSString *)url paramName:(NSString *)paramName {
    if (![paramName hasSuffix:@"="]) {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString *str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound) {
        unichar c = '?';
        if (start.location != 0) {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#') {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}

//+ (BOOL)checkLocationEnabled {
//    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied){
//        return YES;
//    } else {
//        return NO;
//    }
//}

+ (UIView *)emptyViewWithImageName:(NSString *)imageName subText:(NSString *)subText height:(CGFloat)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, height)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = [UIColor colorWithHexString:kMDBackgroundColor];
  
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.size = imageView.image.size;
    imageView.origin = CGPointMake((view.width - imageView.width) / 2, (view.height - imageView.width) / 2 - 60);
    [view addSubview:imageView];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 20, view.width, 20)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.textColor = [UIColor colorWithHexString:kMDColorBaseLevel2];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.font = [MDFont fontWithSize:13];
    subLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: subLabel.font, NSParagraphStyleAttributeName: paragraphStyle};
    subLabel.attributedText = [[NSAttributedString alloc] initWithString:subText attributes:attributes];
    
    [subLabel sizeToFit];
    subLabel.width = view.width;
    
    [view addSubview:subLabel];
    
    return view;
}

+ (UIView *)emptyViewWithIconName:(NSString *)iconName subText:(NSString *)subText height:(CGFloat)height {
    return [self emptyViewWithIconName:iconName
                               subText:subText
                       backgroundColor:[UIColor clearColor]
                              iconSize:160
                            iconOffset:60
                                height:height];
}

+ (UIView *)emptyViewWithIconName:(NSString *)iconName
                          subText:(NSString *)subText
                  backgroundColor:(UIColor *)backgroundColor
                         iconSize:(CGFloat)iconSize
                       iconOffset:(CGFloat)iconOffset
                           height:(CGFloat)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, height)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    view.backgroundColor = backgroundColor ?: [UIColor colorWithHexString:kMDBackgroundColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (view.height - iconSize) / 2 - iconOffset, view.width, iconSize)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"iconfont" size:iconSize];
    label.textColor = [UIColor colorWithHexString:kMDColorBaseLevel5];
    label.text = iconName;
    [view addSubview:label];
    
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, label.bottom + 20, view.width, 20)];
    subLabel.backgroundColor = [UIColor clearColor];
    subLabel.textColor = [UIColor colorWithHexString:kMDColorBaseLevel3];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.font = [UIFont systemFontOfSize:13];
    subLabel.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: subLabel.font, NSParagraphStyleAttributeName: paragraphStyle};
    subLabel.attributedText = [[NSAttributedString alloc] initWithString:subText attributes:attributes];
    
    [subLabel sizeToFit];
    subLabel.width = view.width;
    
    [view addSubview:subLabel];
    
    return view;
}

+ (UIImage *)imageWithImage:(UIImage *)image
          scaledToFitToSize:(CGSize)newSize {
    //Only scale images down
    if (image.size.width < newSize.width && image.size.height < newSize.height) {
        return [image copy];
    }
    
    CGSize scaledSize = [self sizeFit:image.size targetSize:newSize];
    
    // 设置成为当前正在使用的context
    UIGraphicsBeginImageContext(scaledSize);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

+ (CGSize)sizeFit:(CGSize)size targetSize:(CGSize)targetSize {
    CGFloat widthScale = targetSize.width / (size.width > 0 ? size.width : 1);
    CGFloat heightScale = targetSize.height / (size.height > 0 ? size.height : 1);
    
    CGFloat scaleFactor;
    widthScale < heightScale ? (scaleFactor = widthScale) : (scaleFactor = heightScale);
    
    return CGSizeMake(size.width * scaleFactor, size.height * scaleFactor);
}

// ?imageView2/1/h/100
+ (NSURL *)qiNiuimageURLWith:(NSString *)urlPath size:(CGSize)size {
    // 宽度 或者 高度 不大于xxx像素
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/2/w/%.f/h/%.f", urlPath, size.width, size.height]];
    NSLog(@"qiNiuimageURLWith %@", url);
    return url;
}

// _wxh.jpg
+ (NSURL *)lwImageURLWith:(NSString *)urlPath size:(CGSize)size {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@_%.fx%.f.jpg", urlPath, size.width, size.height]];
    NSLog(@"lwImageURLWith %@", url);
    return url;
}

+ (NSString *)getResolution {
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGFloat screenWidth = mainScreen.size.width * screenScale;
    CGFloat screenHeight = mainScreen.size.height * screenScale;
    
    NSString *ret = [NSString stringWithFormat:@"%.0f,%.0f", screenWidth, screenHeight];
    return ret;
}

//+ (NSString *)getNetworkType {
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
//    
//    NetworkStatus status = [reachability currentReachabilityStatus];
//    if (status == ReachableViaWiFi) {
//        return @"1";
//    } else if (status == ReachableViaWWAN) {
//        return @"6";
//    } else {
//        return @"0";
//    }
//}

+ (UIWindow *)mainWindow {
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    }
    else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    return nil;
}


//+ (NSString *)macString {
//    int mib[6];
//    size_t len;
//    char *buf;
//    unsigned char *ptr;
//    struct if_msghdr *ifm;
//    struct sockaddr_dl *sdl;
//    
//    mib[0] = CTL_NET;
//    mib[1] = AF_ROUTE;
//    mib[2] = 0;
//    mib[3] = AF_LINK;
//    mib[4] = NET_RT_IFLIST;
//    
//    if ((mib[5] = if_nametoindex("en0")) == 0) {
//        printf("Error: if_nametoindex error\n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 1\n");
//        return NULL;
//    }
//    
//    if ((buf = malloc(len)) == NULL) {
//        printf("Could not allocate memory. error!\n");
//        return NULL;
//    }
//    
//    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
//        printf("Error: sysctl, take 2");
//        free(buf);
//        return NULL;
//    }
//    
//    ifm = (struct if_msghdr *)buf;
//    sdl = (struct sockaddr_dl *)(ifm + 1);
//    ptr = (unsigned char *)LLADDR(sdl);
//    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
//                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
//    free(buf);
//    
//    return macString;
//}

//+ (NSString *)idfaString {
//    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
//    return idfa ?: @"";
//}
//
//+ (NSString *)idfvString {
//    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
//        return [[UIDevice currentDevice].identifierForVendor UUIDString];
//    }
//    
//    return @"";
//}

@end
