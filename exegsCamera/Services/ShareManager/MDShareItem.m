//
//  MDShareItem.m
//  MeiMeiDa
//
//  Created by Yulin Ding on 6/24/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDShareItem.h"

@implementation MDShareItem

- (void)setImageURL:(NSString *)imageURL {
    _imageURL = _ignoreImageQuality ? imageURL : [MDUtil imageStringWith:imageURL scaleSize:CGSizeMake(160, 160)];
}

@end
