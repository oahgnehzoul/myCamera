//
//  MDImageEditorService.h
//  MeiMeiDa
//
//  Created by Jason Wong on 15/10/12.
//  Copyright © 2015年 Jason Wong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^MDImageEditorServiceCompletionHandler)(NSError *error, UIImage *image);

@interface MDImageEditorService : NSObject

+ (instancetype)sharedInstance;

- (void)setup;

- (void)startWithImage:(UIImage *)image completionHandler:(MDImageEditorServiceCompletionHandler)completionHandler;

@end
