//
//  MDShareView.h
//  MeiMeiDa
//
//  Created by Yulin Ding on 6/24/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDShareGridView.h"

@interface MDShareView : UIView

//@property (nonatomic, strong) MDShareItem *shareItem;
@property (nonatomic, weak) id<MDShareViewDelegate> delegate;

@property (nonatomic, strong) MDShareCompletion shareCompletion;

+ (MDShareView *)presentInView:(UIView *)view
                withShareTypes:(NSInteger)shareTypes
                      animated:(BOOL)animated;

+ (void)dismissInView:(UIView *)view
             animated:(BOOL)animated;

+ (void)dismissAll;

- (instancetype)initWithShareTypes:(NSInteger)shareTypes;

@end
