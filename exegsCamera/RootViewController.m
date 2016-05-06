//
//  RootViewController.m
//  exegsCamera
//
//  Created by oahgnehzoul on 16/5/6.
//  Copyright © 2016年 exegs. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "RDVTabBarItem.h"
@interface RootViewController ()

@end

@implementation RootViewController

- (instancetype)init {
    if (self = [super init]) {
        self.viewControllers =@[
                                [[JWNavigationViewController alloc] initWithRootViewController:[[ViewController1 alloc] init]],
                                [[JWNavigationViewController alloc] initWithRootViewController:[[ViewController2 alloc] init]],
                                [[JWNavigationViewController alloc] initWithRootViewController:[[ViewController3 alloc] init]]
                                ];
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.fd_prefersNavigationBarHidden = YES;
    RDVTabBar *tabBar = [self tabBar];
    NSArray *titles = @[@"挑战",@"拍照",@"发现"];
    NSArray *icons = @[@"MDTabA",@"MDTabC",@"MDTabE"];
    for (int i = 0; i < tabBar.items.count; i++) {
        NSString *title = titles[i];
        RDVTabBarItem *item = self.tabBar.items[i];
        item.titlePositionAdjustment = UIOffsetMake(0, 4);
        item.imagePositionAdjustment = UIOffsetMake(0, -2);
        item.badgeTextFont = [MDFont fontWithSize:9];
        item.badgePositionAdjustment = UIOffsetMake(-3, 0);
        item.badgeBackgroundColor = [UIColor colorWithHexString:kMDColorControlLevel1];

        // title style
        NSDictionary *unselectedTitleAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:kMDColorBaseLevel2], NSFontAttributeName: [MDFont fontWithSize:10]};
        NSDictionary *selectedTitleAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithHexString:kMDColorBaseLevel2], NSFontAttributeName: [MDFont fontWithSize:10]};
        item.unselectedTitleAttributes = unselectedTitleAttributes;
        item.selectedTitleAttributes = selectedTitleAttributes;
        item.title = title;
        item.backgroundColor = [UIColor whiteColor];
        
        // icon
        UIImage *icon = [UIImage imageNamed:icons[i]];
        UIImage *selectedIcon = [UIImage imageNamed:[NSString stringWithFormat:@"%@Selected", icons[i]]];
        [item setFinishedSelectedImage:selectedIcon withFinishedUnselectedImage:icon];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tabBar.width, 1)];
        line.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        line.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [tabBar addSubview:line];
        
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [super setSelectedIndex:selectedIndex];
}

//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}


@end
