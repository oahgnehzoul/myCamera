//
//  ViewController1.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/6.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "ViewController1.h"
#import "UMSocial.h"
#import "MDShareService.h"
#import "MDShareView.h"
@interface ViewController1 ()<MDShareViewDelegate>

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"挑战";
    
    
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _imgView.image = [UIImage imageNamed:@"1.jpg"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap)];
    _imgView.userInteractionEnabled = YES;
    [_imgView addGestureRecognizer:tap];
    [self.view addSubview:_imgView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];

}

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        _shareButton.titleLabel.font = [UIFont fontWithName:@"iconfont" size:15];
        [_shareButton setTitle:@"\U0000e601" forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor colorWithHexString:kMDColorBaseLevel2] forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(doShare) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
//    NSLog(@"%@",platformName);
//}
- (void)doShare {
    
    if ([self.view viewWithTag:999]) {
        [MDShareView dismissInView:self.view animated:YES];
        return;
    }
    MDShareView *shareView = [MDShareView presentInView:[MDUtil mainWindow] withShareTypes:MDShareTypeWeChatSession | MDShareTypeWeibo | MDShareTypeQQ animated:YES];
    shareView.tag = 999;
    shareView.delegate = self;
}

- (MDShareItem *)itemForShare:(MDShareType)shareType {
    MDShareItem *item = [MDShareItem new];
    item.title = @"分享图片";
    item.image = [UIImage imageNamed:@"1.jpg"];
    item.url = @"http://www.baidu.com";
    return item;
}

- (void)doTap {
    [[MDImageEditorService sharedInstance] startWithImage:self.imgView.image completionHandler:^(NSError *error, UIImage *image) {
        if (image) {
            //image为处理之后的图片。
            NSLog(@"1");
        }
    }];

}




@end
