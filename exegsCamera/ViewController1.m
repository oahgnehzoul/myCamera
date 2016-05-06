//
//  ViewController1.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/6.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@property (nonatomic, strong) UIImageView *imgView;

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
