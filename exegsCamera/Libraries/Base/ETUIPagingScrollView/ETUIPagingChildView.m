//
//  ETUIPagingChildView.m
//  ETLibDemo
//
//  Created by moxin.xt on 14-1-23.
//  Copyright (c) 2014年 Visionary. All rights reserved.
//

#import "ETUIPagingChildView.h"

@implementation ETUIPagingChildView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)childViewWillAppear
{
      NSLog(@"[PagingChildView:%@]-->will appear-->{%@,%ld}",self.class,self.reuseIdentifier, (long)self.pageIndex);
}
- (void)childViewDidAppear
{
      NSLog(@"[PagingChildView:%@]-->did appear-->{%@,%ld}",self.class,self.reuseIdentifier, (long)self.pageIndex);
}
- (void)childViewWillDisappear
{
      NSLog(@"[PagingChildView:%@]-->will disappear-->{%@,%ld}",self.class,self.reuseIdentifier, (long)self.pageIndex);
}
- (void)childViewDidDisappear
{
    NSLog(@"[PagingChildView:%@]-->did disappear-->{%@,%ld}",self.class,self.reuseIdentifier, (long)self.pageIndex);
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"[PagingChildView:%@]-->{%@,%ld}",[self class],self.reuseIdentifier, (long)self.pageIndex];
}

- (void)childViewWillBeRecycled
{
     NSLog(@"[PagingChildView:%@]-->will be recycled-->{%@,%ld}",self.class,self.reuseIdentifier, (long)self.pageIndex);
}

- (void)childViewDidBeRecycled
{
    NSLog(@"[PagingChildView:%@]-->did be recycled-->{%@,%ld}",self.class,self.reuseIdentifier, (long)self.pageIndex);
}
@end
