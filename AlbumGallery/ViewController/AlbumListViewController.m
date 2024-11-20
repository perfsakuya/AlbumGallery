//
//  AlbumListViewController.m
//  TestObjC
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import "AlbumListViewController.h"

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor systemGrayColor];
    self.title = @"Albums";

    // 添加演示标签
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"Album List View";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:label];
}

@end
