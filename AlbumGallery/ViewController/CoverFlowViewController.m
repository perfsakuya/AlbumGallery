//
//  CoverFlowViewController.m
//  TestObjC
//
//  Created by 汤骏哲 on 2024/11/17.
//
#import "CoverFlowViewController.h"
#import "CFCoverFlowView.h"
#import "MusicLibraryManager.h"
#import "AlbumLocalization.h"
@interface CoverFlowViewController () <CFCoverFlowViewDelegate>

@property (nonatomic, strong) NSArray<NSDictionary *> *albumDataArray;
@property (nonatomic, strong) UILabel *albumTitleLabel;
@property (nonatomic, strong) UILabel *albumArtistLabel;
@property (nonatomic, strong) UILabel *albumGenreAndReleaseDateLabel;

@end

@implementation CoverFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cover Flow";
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark - Cover Flow Area
    
// 创建 Cover Flow 视图
    CFCoverFlowView *coverFlowView = [[CFCoverFlowView alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, self.view.bounds.size.height / 3)];
    
    coverFlowView.pageItemWidth = coverFlowView.bounds.size.height / 1.35;
    coverFlowView.pageItemHeight = coverFlowView.bounds.size.height / 1.35;
    coverFlowView.pageItemCoverWidth = 30.0;
//    coverFlowView.backgroundColor = [UIColor clearColor]; // 确保背景透明
    [self.view addSubview:coverFlowView];

    coverFlowView.delegate = self;

#pragma mark - Read & Save Test
    
    // 从 MusicLibraryManager 获取专辑信息
    // 现在是从am数据库存储信息并读取到内存中，以后应该只有第一次读取，然后存储在CoreData中，之后直接读取CoreData中的数据
    [[MusicLibraryManager sharedManager] fetchAlbumsWithCompletion:^(NSArray<NSDictionary *> *albums, NSError *error) {
        if (error) {
            NSLog(@"获取专辑信息失败：%@", error.localizedDescription);
            return;
        }

        NSMutableArray<UIImage *> *coverImages = [NSMutableArray array];
        for (NSDictionary *album in albums) {
            // 获取封面图片
            id coverImage = album[@"coverImage"];
            if (coverImage && ![coverImage isKindOfClass:[NSNull class]]) {
                [coverImages addObject:coverImage];
            } else {
                NSLog(@"专辑 %@ 没有封面图片，使用默认图片", album[@"title"]);
                UIImage *defaultImage = [UIImage imageNamed:@"NO_DATA"];
                [coverImages addObject:defaultImage];

            }
        }

        if (coverImages.count > 0) {
            // 更新 coverFlowView，传入封面图片数组
            NSLog(@"专辑数量: %@", @(albums.count));
            [coverFlowView setPageItemsWithImageArray:coverImages];
        } else {
            NSLog(@"未找到有效的封面图片");
        }
        // 保存专辑信息到 Core Data
        // [AlbumLocalization saveAlbumsToCoreData:albums];
        self.albumDataArray = albums;
        if (albums.count > 0) {
            [self coverFlowView:coverFlowView didScrollPageItemToIndex:0];
        }
    }];
    
//   // 从 Core Data 读取专辑信息
//    self.albumDataArray = [AlbumLocalization fetchAlbumsFromCoreData];

#pragma mark - Album Description
    // 专辑名称
    self.albumTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(coverFlowView.frame) + 10, self.view.bounds.size.width - 40, 25)];
    self.albumTitleLabel.font = [UIFont boldSystemFontOfSize:24];
    self.albumTitleLabel.textColor = [UIColor blackColor];
    self.albumTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.albumTitleLabel];

    // 作曲家
    self.albumArtistLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.albumTitleLabel.frame) + 5, self.view.bounds.size.width - 40, 25)];
    self.albumArtistLabel.font = [UIFont systemFontOfSize:24];
    self.albumArtistLabel.textColor = [UIColor colorWithRed: 0.98 green: 0.14 blue: 0.23 alpha: 1.00];
    self.albumArtistLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.albumArtistLabel];

    // 流派&发行日期
    self.albumGenreAndReleaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.albumArtistLabel.frame) + 5, self.view.bounds.size.width - 40, 25)];
    self.albumGenreAndReleaseDateLabel.font = [UIFont boldSystemFontOfSize:12];
    self.albumGenreAndReleaseDateLabel.textColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 1.00];
    self.albumGenreAndReleaseDateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.albumGenreAndReleaseDateLabel];

#pragma mark - Control Area
    // 收藏、信息、前往专辑、分享
    NSArray *buttonIcons = @[@"heart.fill", @"square.and.arrow.up"];
    NSArray *buttonTitles = @[@" 收藏", @" 分享"];
    NSArray *buttonSelectors = @[@"favoriteButtonTapped", @"shareButtonTapped"];

    // 按钮宽度、间距和高度
    CGFloat buttonWidth = 478 / 3;
    CGFloat buttonHeight = 144 / 3;
    CGFloat buttonSpacing = 48 / 3;
    CGFloat totalWidth = buttonWidth * buttonIcons.count + buttonSpacing * (buttonIcons.count - 1);
    CGFloat startX = (self.view.bounds.size.width - totalWidth) / 2;

    // 循环创建按钮
    for (int i = 0; i < buttonIcons.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 设置按钮位置和大小
        button.frame = CGRectMake(startX + i * (buttonWidth + buttonSpacing),
                                  CGRectGetMaxY(self.albumGenreAndReleaseDateLabel.frame) + 10,
                                  buttonWidth,
                                  buttonHeight);
        
        // 设置按钮样式
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        
        // 设置图标
        UIImage *iconImage = [UIImage systemImageNamed:buttonIcons[i]];
        if (iconImage) {
            UIImage *tintedImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button setImage:tintedImage forState:UIControlStateNormal];
            [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00]];
        }
        
        // 设置标题
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
        // 添加点击事件
        SEL action = NSSelectorFromString(buttonSelectors[i]);
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        // 添加点击动画效果
        [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        // 添加到视图
        [self.view addSubview:button];
    }
    
}

- (void)favoriteButtonTapped {
    NSLog(@"收藏按钮点击");
}

- (void)shareButtonTapped {
    NSLog(@"分享按钮点击");
}

// 按钮点击时变淡的动画
- (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.4 animations:^{
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:0.5]; // 淡化背景
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:0.5] forState:UIControlStateNormal]; // 淡化文字
        [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:0.5]]; // 淡化图标
    }];
}

- (void)buttonTouchUpInside:(UIButton *)button {
    [UIView animateWithDuration:0.4 animations:^{
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00]; // 恢复背景颜色
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00] forState:UIControlStateNormal]; // 恢复文字颜色
        [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00]]; // 恢复图标颜色
    }];
}

- (void)buttonTouchUpOutside:(UIButton *)button {
    [UIView animateWithDuration:0.4 animations:^{
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00]; // 恢复背景颜色
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00] forState:UIControlStateNormal]; // 恢复文字颜色
        [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00]]; // 恢复图标颜色
    }];
}

// 每次滑动 Cover Flow 时调用一次，获取对应的专辑数据
- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didScrollPageItemToIndex:(NSInteger)index {
//    NSLog(@"didScrollPageItemToIndex >>> %@", @(index));
    if (index < 0 || index >= self.albumDataArray.count) {
        return;
    }

    // 获取对应的专辑数据
    NSDictionary *albumData = self.albumDataArray[index];
    
    NSLog(@"当前专辑信息: %@", albumData);
    NSLog(@"位于索引的%@/%@", @(index), @(self.albumDataArray.count - 1));
    self.pageControl.currentPage = index;

    // 淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.albumTitleLabel.alpha = 0;
        self.albumArtistLabel.alpha = 0;
        self.albumGenreAndReleaseDateLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.albumTitleLabel.text = albumData[@"title"];  // 专辑名称
        self.albumArtistLabel.text = albumData[@"artist"];  // 作曲家（艺术家）

        // 提取年份
        NSDate *releaseDate = albumData[@"releaseDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy";
        NSString *year = [dateFormatter stringFromDate:releaseDate];

        self.albumGenreAndReleaseDateLabel.text = [NSString stringWithFormat:@"%@ ・ %@年", albumData[@"genre"], year ?: @"未知年份"];

        // 淡入
        [UIView animateWithDuration:0.2 animations:^{
            self.albumTitleLabel.alpha = 1;
            self.albumArtistLabel.alpha = 1;
            self.albumGenreAndReleaseDateLabel.alpha = 1;
        }];
    }];
}

// 选择专辑封面时调用一次
- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didSelectPageItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectPageItemAtIndex >>> %@", @(index));
}

- (IBAction)pageControlAction:(UIPageControl *)sender {
    // 可在此添加分页控件变化时的操作代码
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

