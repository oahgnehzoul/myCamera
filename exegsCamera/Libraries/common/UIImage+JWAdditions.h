//
//  UIImage+JWAdditions.h
//  iZhihu2014
//
//  Created by Jason Wong on 14-1-28.
//  Copyright (c) 2014年 Jason Wong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JWAdditions)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end
