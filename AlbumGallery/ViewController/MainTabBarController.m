//
//  MainTabBarController.m
//  TestObjC
//
//  Created by 汤骏哲 on 2024/11/17.
//  这是应用程序的入口。

#import "MainTabBarController.h"
#import "CoverFlowViewController.h"
#import "AlbumListViewController.h"
#import "FavoritesViewController.h"
#import "AboutViewController.h"

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 创建子控制器
//    CoverFlowViewController *coverFlowVC = [[CoverFlowViewController alloc] init];
//    coverFlowVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cover Flow" image:nil tag:0];
//    
//    AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
//    albumListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Albums" image:nil tag:1];
//    
//    FavoritesViewController *favoritesVC = [[FavoritesViewController alloc] init];
//    favoritesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:nil tag:2];
//    
//    AboutViewController *aboutVC = [[AboutViewController alloc] init];
//    aboutVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"About" image:nil tag:3];
//    
//    // 添加到 TabBar 控制器
//    self.viewControllers = @[coverFlowVC, albumListVC, favoritesVC, aboutVC];
//    
    // 初始化子控制器
    CoverFlowViewController *coverFlowVC = [[CoverFlowViewController alloc] init];
    AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
    FavoritesViewController *favoritesVC = [[FavoritesViewController alloc] init];
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    
    // 设置 Tab Bar 的标题和图标
    coverFlowVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cover Flow"
                                                          image:[UIImage systemImageNamed:@"photo"]
                                                            tag:0];
    albumListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Albums"
                                                           image:[UIImage systemImageNamed:@"list.bullet"]
                                                             tag:1];
    favoritesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites"
                                                           image:[UIImage systemImageNamed:@"star"]
                                                             tag:2];
    aboutVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"About"
                                                       image:[UIImage systemImageNamed:@"info.circle"]
                                                         tag:3];
    
    // 将子控制器添加到 Tab Bar Controller
    self.viewControllers = @[coverFlowVC, albumListVC, favoritesVC, aboutVC];
}

@end
