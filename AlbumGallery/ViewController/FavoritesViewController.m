//
//  FavoritesViewController.m
//  TestObjC
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import "FavoritesViewController.h"

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 添加演示标签
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"Favorites View";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:label];
}

@end
