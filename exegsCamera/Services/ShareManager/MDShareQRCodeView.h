//
//  MDShareQRCodeView.h
//  MeiMeiDa
//
//  Created by Yulin Ding on 10/20/15.
//  Copyright © 2015 Jason Wong. All rights reserved.
//

#import "MDShareItem.h"

@interface MDShareQRCodeView : UIView

+ (MDShareQRCodeView *)presentInView:(UIView *)view
                           shareItem:(MDShareItem *)shareItem
                      animated:(BOOL)animated;

+ (void)dismissInView:(UIView *)view
             animated:(BOOL)animated;

- (instancetype)initWithShareItem:(MDShareItem *)shareItem;

@end
