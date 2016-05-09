//
//  MDShareItem.h
//  MeiMeiDa
//
//  Created by Yulin Ding on 6/24/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, MDShareItemQRImageType) {
    MDShareItemQRImageTypeCircle = 1,
    MDShareItemQRImageTypeSquare = 2
};

@interface MDShareItem : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, assign) BOOL ignoreImageQuality;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *extInfo;
@property (nonatomic, assign) MDShareItemQRImageType QRCodeImageType;
/**
 *  是否微信的App类型
 */
@property (nonatomic, assign) BOOL wxMessageAppType;

@end
