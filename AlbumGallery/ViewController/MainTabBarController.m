//
//  MainTabBarController.m
//  AlbumGallery
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
    
    CoverFlowViewController *coverFlowVC = [[CoverFlowViewController alloc] init];
    FavoritesViewController *favoritesVC = [[FavoritesViewController alloc] init];
    AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    
//    self.view.backgroundColor = [UIColor whiteColor];
    coverFlowVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Cover Flow"
                                                          image:[UIImage systemImageNamed:@"square.stack"]
                                                            tag:0];
    favoritesVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"收藏"
                                                           image:[UIImage systemImageNamed:@"star"]
                                                             tag:2];
    albumListVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"专辑"
                                                           image:[UIImage systemImageNamed:@"list.bullet"]
                                                             tag:1];
    aboutVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"关于"
                                                       image:[UIImage systemImageNamed:@"info.circle"]
                                                         tag:3];
    
    self.viewControllers = @[coverFlowVC, favoritesVC, albumListVC, aboutVC];
}

@end
