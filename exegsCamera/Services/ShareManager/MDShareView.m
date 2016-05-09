//
//  MDShareView.m
//  MeiMeiDa
//
//  Created by Yulin Ding on 6/24/15.
//  Copyright (c) 2015 Jason Wong. All rights reserved.
//

#import "MDShareView.h"
#import "MDShareGridView.h"
#import "UIImage+JWAdditions.h"
#import "KLCPopup.h"

const NSUInteger kMDShareViewTitleHeight = 40;
const NSUInteger kMDShareViewPaddingLeft = 15;
const NSUInteger kMDShareViewPaddingTop = 15;
const NSUInteger kMDShareViewSeparatorHeight = 15;
const NSUInteger kMDShareViewPaddingBottom = 10;

@interface MDShareView() <MDShareViewEventDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) MDShareGridView *gridView;
@property (nonatomic, strong) MDShareGridView *utilityView;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation MDShareView

+ (MDShareView *)presentInView:(UIView *)view
                withShareTypes:(NSInteger)shareTypes
                      animated:(BOOL)animated {
    MDShareView *shareView = [[MDShareView alloc] initWithShareTypes:shareTypes];
    
    KLCPopup *popup = [KLCPopup popupWithContentView:shareView
                                            showType:KLCPopupShowTypeSlideInFromBottom
                                         dismissType:KLCPopupDismissTypeSlideOutToBottom
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutLeft, KLCPopupVerticalLayoutBottom);
    [popup showWithLayout:layout];
    
    return shareView;
}

+ (void)dismissInView:(UIView *)view
             animated:(BOOL)animated {
    if ([view isKindOfClass:[MDShareView class]]) {
        [view dismissPresentingPopup];
    }
}

+ (void)dismissAll {
    [KLCPopup dismissAllPopups];
}

- (instancetype)initWithShareTypes:(NSInteger)shareTypes {
    if (self = [super init]) {
        self.width = APP_CONTENT_WIDTH;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        topBorder.backgroundColor = [UIColor colorWithHexString:kMDBorderColor];
        [_contentView addSubview:topBorder];
        
        NSInteger utilityTypes = 0;
        
        if (shareTypes & MDShareTypeClipboard) {
            utilityTypes = utilityTypes | MDShareTypeClipboard;
            shareTypes = shareTypes^MDShareTypeClipboard;
        }
        if (shareTypes & MDShareTypeQRCode) {
            utilityTypes = utilityTypes | MDShareTypeQRCode;
            shareTypes = shareTypes^MDShareTypeQRCode;
        }
        
        _gridView = [[MDShareGridView alloc] initWithFrame:CGRectMake(kMDShareViewPaddingLeft, kMDShareViewPaddingTop, self.width - kMDShareViewPaddingLeft*2, 0) shareTypes:shareTypes];
        _gridView.delegate = self.delegate;
        _gridView.eventDelegate = self;
        [_contentView addSubview:_gridView];
        
        WEAKSELF
        _gridView.shareCompletion = ^(MDShareStatus status) {
            [weakSelf.class dismissInView:weakSelf.superview animated:YES];
        };
        
        CGFloat height = kMDShareViewPaddingTop + _gridView.height + kMDShareViewPaddingBottom;;
        if (utilityTypes > 0) {
            _utilityView = [[MDShareGridView alloc] initWithFrame:CGRectMake(kMDShareViewPaddingLeft, _gridView.bottom + kMDShareViewSeparatorHeight, self.width - kMDShareViewPaddingLeft*2, 0) shareTypes:utilityTypes];
            _utilityView.delegate = self.delegate;
            [_contentView addSubview:_utilityView];
            
            _utilityView.shareCompletion = ^(MDShareStatus status) {
                [weakSelf.class dismissInView:weakSelf.superview animated:YES];
            };
            
            height += kMDShareViewSeparatorHeight + _utilityView.height;
        }
        
        
        _contentView.height = height;
        self.height = _contentView.height;
    }
    
    return self;
}

- (void)setDelegate:(id<MDShareViewDelegate>)delegate {
    _delegate = delegate;
    _gridView.delegate = delegate;
    _utilityView.delegate = delegate;
}

- (void)setShareCompletion:(MDShareCompletion)shareCompletion {
    _gridView.customShareCompletion = shareCompletion;
    _utilityView.customShareCompletion = shareCompletion;
}

- (MDShareCompletion)shareCompletion {
    return _gridView.customShareCompletion;
}

- (void)onTapped:(UITapGestureRecognizer *)gesture {
    [MDShareView dismissInView:self.superview animated:YES];
}

- (void)didSelectShareType:(MDShareType)shareType {
    [self dismissPresentingPopup];
}


@end
