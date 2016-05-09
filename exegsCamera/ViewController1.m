//
//  ViewController1.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/6.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "ViewController1.h"
#import "UMSocial.h"
@interface ViewController1 ()<UMSocialUIDelegate>

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
-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData {
    NSLog(@"%@",platformName);
}
- (void)doShare {
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:kMDUMengAppKey shareText:@"123" shareImage:[UIImage imageNamed:@"1.jpg"] shareToSnsNames:@[UMShareToQQ,UMShareToSina,UMShareToWechatSession] delegate:self];
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
