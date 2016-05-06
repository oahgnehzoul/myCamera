//
//  MDNavigatorMaps.m
//  MeiMeiDa
//
//  Created by Jason Wong on 15/6/15.
//  Copyright (c) 2015年 Jason Wong. All rights reserved.
//

#import "MDNavigatorMaps.h"
#import "MDNavigator.h"
#import "Routable.h"

//#import "MDHomeViewController.h"
//#import "MDCategoryViewController.h"
//#import "MDDetailViewController.h"
//#import "MDWebViewController.h"
//#import "MDCityListViewController.h"
//#import "MDMyOrderDetailViewController.h"
//#import "MDMyOrderListViewController.h"
//#import "MDAddressViewController.h"
//#import "MDMyFavoritesViewController.h"
//#import "MDChatViewController.h"
//#import "MDReviewListViewController.h"
//#import "MDMCoinAddressBookViewController.h"
//#import "MDMCoinViewController.h"
//#import "MDBillViewController.h"
//#import "MDLocationViewController.h"
//#import "MDMapPointViewController.h"
//#import "MDWithdrawHistoryViewController.h"
//#import "MDSearchViewController.h"
//#import "MDProfileIndexViewController.h"
//#import "MDAlipayCreditViewController.h"
//#import "MDMyOrderRefundDetailViewController.h"
//#import "MDScanViewController.h"
//#import "MDNewsViewController.h"
//#import "MDMyServicesViewController.h"
//#import "MDPublishGalleryViewController.h"
//#import "MDPublishViewController.h"
//
//#import "MDExploreMCoinService.h"
//#import "MDMyCertDetailViewController.h"
//#import "MDMyCertListViewController.h"
//#import "MDBonusViewController.h"
//#import "MDHybridViewController.h"
//#import "MDOrderViewController.h"
//
//#import "MDSquareViewController.h"
//#import "MDSquareAskDetailViewController.h"
//#import "MDSquareAskReplyViewController.h"
//#import "MDSquareBBSDetailViewController.h"
//#import "MDMySquareViewController.h"
//#import "MDSquareIndexViewController.h"
//#import "MDSquareManageAskListViewController.h"
//#import "MDSquareManageCenterViewController.h"
//#import "MDSquareManageSearchViewController.h"
//#import "MDSquareManagePublishViewController.h"
//#import "MDSquareManageTelephoneViewController.h"
//#import "MDSquareManageCategoryOrderViewController.h"

@implementation MDNavigatorMaps

+ (void)setup {
   
    [[Routable sharedRouter] setIgnoresExceptions:YES];
    
    /**
     *  map 命名不要以 mcoin 命名，改命名在入口被特殊处理了
     */
    
    /**
     *  主功能
     */
//    [MDNavigatorMaps map:@"home" toController:[MDHomeViewController class]]; //首页
//    [MDNavigatorMaps map:@"cate/:id" toController:[MDCategoryViewController class]]; // 分类
//    [MDNavigatorMaps map:@"search" toController:[MDSearchViewController class]]; //搜索
//    [MDNavigatorMaps map:@"search/:keyword" toController:[MDSearchViewController class]]; //搜索结果
//    [MDNavigatorMaps map:@"detail/:id" toController:[MDDetailViewController class]]; //详情
//    [MDNavigatorMaps map:@"comments/:id" toController:[MDDetailViewController class]]; //评论列表->详情页替换
//    [MDNavigatorMaps map:@"message/:type" toController:[MDNewsViewController class]]; //消息列表
//    [MDNavigatorMaps map:@"chat/:userId" toController:[MDChatViewController class]]; //聊天
//    [MDNavigatorMaps map:@"chat/:userId/itemId/:itemId" toController:[MDChatViewController class]]; // 商品聊天
//    [MDNavigatorMaps map:@"chat/:userId/orderId/:orderId" toController:[MDChatViewController class]]; // 订单聊天
//    [MDNavigatorMaps map:@"publish" toController:[MDPublishViewController class]]; //发布商品
//    [MDNavigatorMaps map:@"publish/:id" toController:[MDPublishViewController class]]; //编辑商品
//    [MDNavigatorMaps map:@"publishgallery" toController:[MDPublishGalleryViewController class]]; //发布作品秀
//    [MDNavigatorMaps map:@"hybrid/:appName" toController:[MDHybridViewController class]]; // react native
//    [MDNavigatorMaps map:@"hybrid/:appName/:url" toController:[MDHybridViewController class]]; // 用于测试用
//    [MDNavigatorMaps map:@"buy/:itemId" toController:[MDOrderViewController class]];
//    
//    /**
//     *  用户功能
//     */
//    [MDNavigatorMaps map:@"orderlist/:role" toController:[MDMyOrderListViewController class]]; //订单列表
//    [MDNavigatorMaps map:@"orderdetail/:id" toController:[MDMyOrderDetailViewController class]]; //订单详情
//    [MDNavigatorMaps map:@"bill" toController:[MDBillViewController class]]; //收支明细
//    [MDNavigatorMaps map:@"bill/:id" toController:[MDBillViewController class]]; //余额、m豆收支明细
//    [MDNavigatorMaps map:@"withdrawlist" toController:[MDWithdrawHistoryViewController class]]; //提现记录
//    [MDNavigatorMaps map:@"refunddetail/:id" toController:[MDMyOrderRefundDetailViewController class]]; //退款详情
//    [MDNavigatorMaps map:@"itemlist" toController:[MDMyServicesViewController class]]; //我发布的服务
//    [MDNavigatorMaps map:@"favorites" toController:[MDMyFavoritesViewController class]]; //我喜欢的服务
//    [MDNavigatorMaps map:@"redpaper/:type" toController:[MDBonusViewController class]]; //红包
//    
//    [MDNavigatorMaps map:@"certify" toController:[MDMyCertDetailViewController class]]; //添加认证
//    [MDNavigatorMaps map:@"certificationlist" toController:[MDMyCertListViewController class]]; //认证列表
//    [MDNavigatorMaps map:@"certification/:id" toController:[MDMyCertDetailViewController class]]; //查看认证，不包含模板参数
//    [MDNavigatorMaps map:@"certification/:id/tid/:tid" toController:[MDMyCertDetailViewController class]]; //查看认证，包含模板参数
//    
//    /**
//     *  用户辅助
//     */
//    [MDNavigatorMaps map:@"user/:id" toController:[MDProfileIndexViewController class]]; //个人主页
//    
//    /**
//     *  辅助功能
//     */
//    [MDNavigatorMaps map:@"unsafebrowse/:url" toController:[MDWebViewController class]]; //webview页
//    [MDNavigatorMaps map:@"citylist" toController:[MDCityListViewController class]]; //城市列表
//    [MDNavigatorMaps map:@"address" toController:[MDAddressViewController class]]; //地址管理
//    [MDNavigatorMaps map:@"scan" toController:[MDScanViewController class]]; //扫码
//    [MDNavigatorMaps map:@"bindzm" toController:[MDAlipayCreditViewController class]]; // 芝麻信用绑定
//    [MDNavigatorMaps map:@"location" toController:[MDLocationViewController class]]; //地图信息
//    [MDNavigatorMaps map:@"map/:latitude/:longitude" toController:[MDMapPointViewController class]]; //地图
//    
//    /**
//     *  营销功能
//     */
//    [MDNavigatorMaps map:@"mcoinaddressbook" toController:[MDMCoinAddressBookViewController class]]; //通讯录邀请
//    [MDNavigatorMaps map:@"mcoininvite/:code" toController:[MDMCoinViewController class]]; //挖豆
//    [MDNavigatorMaps map:@"mcoininvite" toController:[MDMCoinViewController class]]; //挖豆
//    
//    //随机发豆回调注册
//    [MDNavigatorMaps map:@"mcoin/:pointId/count/:count" toCallback:^(NSDictionary *params) {
//        if (params[@"pointId"] && params[@"count"]) {
//            [[MDExploreMCoinService sharedInstance] find:[params[@"count"] floatValue] poindId:params[@"pointId"]];
//        }
//    }];
//    
//    //外部唤起客户端打开web页面
//    [MDNavigatorMaps map:@"go/:url" toCallback:^(NSDictionary *params) {
//        NSString *urlStr = [MDUtil shareURL:@"/support/unsafe_host.html"];
//        if (params[@"url"]) {
//            NSString *paramStr = [MDUtil urlDecode:params[@"url"]];
//            NSURL *paramURL = [NSURL URLWithString:paramStr];
//            if ([MDUtil isSafeHost:paramURL.host]) {
//                urlStr = paramStr;
//            }
//        }
//        [[Routable sharedRouter] open:[NSString stringWithFormat:@"unsafebrowse/%@", [MDUtil urlEncode:urlStr]] animated:YES];
//    }];
//    
//    
//    /**
//     *  格子
//     */
//    [MDNavigatorMaps map:@"squareindex/:id" toController:[MDSquareIndexViewController class]];
//    [MDNavigatorMaps map:@"mysquares" toController:[MDMySquareViewController class]];
//    
//    /**
//     *  tab类型 service, ask, bbs, nearby
//     */
//    [MDNavigatorMaps map:@"squareindex/:id/tab/:tab" toController:[MDSquareIndexViewController class]];
//    
//    [MDNavigatorMaps map:@"squareaskdetail/:askid" toController:[MDSquareAskDetailViewController class]]; //互助站详情页
//    [MDNavigatorMaps map:@"squareaskreply/:askid" toController:[MDSquareAskReplyViewController class]]; //互助站普通回复页
//    
//    [MDNavigatorMaps map:@"squarebbsdetail/:topicid" toController:[MDSquareBBSDetailViewController class]]; //闲话厅详情页
//    
//    /**
//     *  格子管理
//     */
//    [MDNavigatorMaps map:@"squaremanage/index/:geziid" toController:[MDSquareManageCenterViewController class]]; //管理中心
//    [MDNavigatorMaps map:@"squaremanage/notice/:geziid" toController:[MDSquareManagePublishViewController class]]; //管理中心－发布公告
//    [MDNavigatorMaps map:@"squaremanage/members/:geziid" toController:[MDSquareManageSearchViewController class]]; //管理中心-成员列表
//    [MDNavigatorMaps map:@"squaremanage/service/:geziid" toController:[MDSquareManageCategoryOrderViewController class]]; //管理中心－服务社类目排序
//    [MDNavigatorMaps map:@"squaremanage/phone/:geziid" toController:[MDSquareManageTelephoneViewController class]]; //管理中心－便民电话
//    [MDNavigatorMaps map:@"squaremanage/asklist/:geziid" toController:[MDSquareManageAskListViewController class]]; //管理中心－需解答求助列表
//    
}

+ (void)map:(NSString *)format toController:(Class)controllerClass {
    [[Routable sharedRouter] map:format toController:controllerClass];
//    [[[MDNavigator sharedInstance] maps] addObject:format];
}

+ (void)map:(NSString *)format toCallback:(RouterOpenCallback)callback {
    [[Routable sharedRouter] map:format toCallback:callback];
//    [[[MDNavigator sharedInstance] maps] addObject:format];
}

@end
