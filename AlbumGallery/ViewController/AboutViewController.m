//
//  AboutViewController.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import "AboutViewController.h"

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView *appIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MyProfile"]];
    appIcon.contentMode = UIViewContentModeScaleAspectFit;
    appIcon.layer.cornerRadius = 20;
    appIcon.clipsToBounds = YES;
    [self.view addSubview:appIcon];
    appIcon.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [appIcon.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [appIcon.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:60],
        [appIcon.widthAnchor constraintEqualToConstant:150],
        [appIcon.heightAnchor constraintEqualToConstant:150]
    ]];
    
    // 应用名
    UILabel *appNameLabel = [[UILabel alloc] init];
    appNameLabel.text = @"Album Gallery";
    appNameLabel.font = [UIFont boldSystemFontOfSize:24];
    appNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:appNameLabel];
    appNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [appNameLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [appNameLabel.topAnchor constraintEqualToAnchor:appIcon.bottomAnchor constant:10]
    ]];
    
    // 版本信息
    UILabel *versionLabel = [[UILabel alloc] init];
    versionLabel.text = @"1.0.0";
    versionLabel.font = [UIFont systemFontOfSize:16];
    versionLabel.textColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 1.00];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    versionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [versionLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [versionLabel.topAnchor constraintEqualToAnchor:appNameLabel.bottomAnchor constant:5]
    ]];
    
    // 开发者信息
    UILabel *developerLabel = [[UILabel alloc] init];
    developerLabel.text = @"Developed by PerfSakuya with ♥.";
    developerLabel.font = [UIFont systemFontOfSize:20];
    developerLabel.textColor = [UIColor labelColor];
    developerLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:developerLabel];
    developerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [developerLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [developerLabel.topAnchor constraintEqualToAnchor:versionLabel.bottomAnchor constant:20]
    ]];
    
    // contact me
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [contactButton setTitle:@"My Blog" forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(contactMe) forControlEvents:UIControlEventTouchUpInside];
    contactButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:contactButton];
    contactButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [contactButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [contactButton.topAnchor constraintEqualToAnchor:developerLabel.bottomAnchor constant:10]
    ]];
    
    // 版权（真的有必要吗）
    UILabel *copyrightLabel = [[UILabel alloc] init];
    copyrightLabel.text = @"© 2024 PerfSakuya. All Rights Reserved.";
    copyrightLabel.font = [UIFont systemFontOfSize:14];
    copyrightLabel.textColor = [UIColor secondaryLabelColor];
    copyrightLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:copyrightLabel];
    copyrightLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [copyrightLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [copyrightLabel.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20]
    ]];
    
}

- (void)contactMe {
    NSURL *url = [NSURL URLWithString:@"https://blog.perfsky.online/about/"];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        NSLog(@"oops！无法打开网址。");
    }
}

@end
