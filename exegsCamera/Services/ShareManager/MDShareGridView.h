//
//  MDShareGridView.h
//  MeiMeiDa
//
//  Created by Yulin Ding on 7/12/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDShareService.h"
#import "MDShareItem.h"

@protocol MDShareViewDelegate <NSObject>

@optional
- (MDShareItem *)itemForShare:(MDShareType)shareType;
- (void)prepareForShare:(MDSharePrepare)prepare;

@end

@protocol MDShareViewEventDelegate <NSObject>

- (void)didSelectShareType:(MDShareType)shareType;

@end

@interface MDShareGridView : UIView

@property (nonatomic, weak) id<MDShareViewDelegate> delegate;
@property (nonatomic, weak) id<MDShareViewEventDelegate> eventDelegate;
@property (nonatomic, copy) MDShareCompletion shareCompletion;
/**
 *  外部使用，MDShareView
 */
@property (nonatomic, copy) MDShareCompletion customShareCompletion;


- (instancetype)initWithFrame:(CGRect)frame
                   shareTypes:(NSInteger)shareTypes;

- (instancetype)initWithFrame:(CGRect)frame
                   shareTypes:(NSInteger)shareTypes
                    iconWidth:(CGFloat)iconWidth;
@end
