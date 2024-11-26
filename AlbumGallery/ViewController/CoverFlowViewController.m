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
#import "AlbumShareViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface CoverFlowViewController () <CFCoverFlowViewDelegate>

@property (nonatomic, strong) NSArray<NSDictionary *> *albumDataArray;
@property (nonatomic, strong) UILabel *albumTitleLabel;
@property (nonatomic, strong) UILabel *albumArtistLabel;
@property (nonatomic, strong) UILabel *albumGenreAndReleaseDateLabel;
@property (nonatomic, strong) NSArray *currentTrackList;
//@property (nonatomic, assign) NSInteger currentAlbumIndex;
@end

@implementation CoverFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
#pragma mark - Cover Flow Area

    CFCoverFlowView *coverFlowView = [[CFCoverFlowView alloc] initWithFrame:CGRectMake(0, 75, self.view.bounds.size.width, self.view.bounds.size.height / 3)];
    
    coverFlowView.pageItemWidth = coverFlowView.bounds.size.height / 1.35;
    coverFlowView.pageItemHeight = coverFlowView.bounds.size.height / 1.35;
    coverFlowView.pageItemCoverWidth = 30.0;
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
    // 收藏+分享
    NSArray *buttonIcons = @[@"heart.fill", @"square.and.arrow.up"];
    NSArray *buttonTitles = @[@" 收藏", @" 分享"];
    NSArray *buttonSelectors = @[@"favoriteButtonTapped", @"shareButtonTapped"];

    CGFloat buttonWidth = 478 / 3;
    CGFloat buttonHeight = 144 / 3;
    CGFloat buttonSpacing = 48 / 3;
    CGFloat totalWidth = buttonWidth * buttonIcons.count + buttonSpacing * (buttonIcons.count - 1);
    CGFloat startX = (self.view.bounds.size.width - totalWidth) / 2;

    // 按钮*2
    for (int i = 0; i < buttonIcons.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(startX + i * (buttonWidth + buttonSpacing),
                                  CGRectGetMaxY(self.albumGenreAndReleaseDateLabel.frame) + 10,
                                  buttonWidth,
                                  buttonHeight);
        
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00];
        button.layer.cornerRadius = 10;
        button.clipsToBounds = YES;
        
        UIImage *iconImage = [UIImage systemImageNamed:buttonIcons[i]];
        if (iconImage) {
            UIImage *tintedImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [button setImage:tintedImage forState:UIControlStateNormal];
            [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00]];
        }
        
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
        SEL action = NSSelectorFromString(buttonSelectors[i]);
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        
        [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        [self.view addSubview:button];
    }
    
#pragma mark - Song List Area
    // TODO: 在这里展示歌曲
    
    
}

- (void)favoriteButtonTapped {
    NSLog(@"收藏按钮点击");
}

- (void)shareButtonTapped {
    NSLog(@"分享按钮点击");
//    AlbumShare *shareVC = [[AlbumShare alloc] init];
//    shareVC.modalPresentationStyle = UIModalPresentationPageSheet;
//
//    // 使用 currentAlbumIndex 获取当前专辑信息
//    if (self.currentAlbumIndex >= 0 && self.currentAlbumIndex < self.albumDataArray.count) {
//        shareVC.albumData = self.albumDataArray[self.currentAlbumIndex];
//    } else {
//        NSLog(@"无效的当前专辑索引: %@", @(self.currentAlbumIndex));
//    }
//
//    [self presentViewController:shareVC animated:YES completion:nil];
}

#pragma mark - Touch Animation
// 按钮点击时变淡的动画
- (void)buttonTouchDown:(UIButton *)button {
    [UIView animateWithDuration:0.4 animations:^{
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:0.5];
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:0.5] forState:UIControlStateNormal];
        [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:0.5]];
    }];
}

- (void)buttonTouchUpInside:(UIButton *)button {
    [UIView animateWithDuration:0.4 animations:^{
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00];
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00] forState:UIControlStateNormal];
        [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00]];    }];
}

- (void)buttonTouchUpOutside:(UIButton *)button {
    [UIView animateWithDuration:0.4 animations:^{
        button.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00];
        [button setTitleColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00] forState:UIControlStateNormal];
        [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00]];
    }];
}



#pragma mark - Action Monitor
// 每次滑动 Cover Flow 时调用一次，获取对应的专辑数据
- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didScrollPageItemToIndex:(NSInteger)index {
    if (index < 0 || index >= self.albumDataArray.count) {
        return;
    }

//    self.currentAlbumIndex = index;

    // 获取对应的专辑数据
    NSDictionary *albumData = self.albumDataArray[index];
    
    NSLog(@"当前专辑信息: %@", albumData);
    NSLog(@"位于索引的%@/%@", @(index), @(self.albumDataArray.count - 1));
    self.pageControl.currentPage = index;

    // 淡入淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.albumTitleLabel.alpha = 0;
        self.albumArtistLabel.alpha = 0;
        self.albumGenreAndReleaseDateLabel.alpha = 0;
    } completion:^(BOOL finished) {
        self.albumTitleLabel.text = albumData[@"title"];
        self.albumArtistLabel.text = albumData[@"artist"];
        
        // TODO: 这里获取专辑的歌曲信息，或许可以用在详细信息按钮，和显示曲目列表中
        self.currentTrackList = albumData[@"items"];
        NSLog(@"专辑曲目列表：%@", albumData[@"items"]);
        NSArray *items = albumData[@"items"];
        if (![items isKindOfClass:[NSArray class]]) {
            NSLog(@"items 不是一个数组");
            return;
        }
        for (MPMediaItem *item in items) {
            if ([item isKindOfClass:[MPMediaItem class]]) {
                NSString *trackTitle = [item valueForProperty:MPMediaItemPropertyTitle] ?: @"未知曲目";
                NSString *albumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle] ?: @"未知专辑";
                NSString *artistName = [item valueForProperty:MPMediaItemPropertyArtist] ?: @"未知艺术家";
                NSString *genre = [item valueForProperty:MPMediaItemPropertyGenre] ?: @"未知流派";
                NSNumber *duration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration]; // 播放时间以秒为单位
                NSDate *releaseDate = [item valueForProperty:MPMediaItemPropertyReleaseDate];

                NSLog(@"曲目标题: %@", trackTitle);
                NSLog(@"专辑名称: %@", albumTitle);
                NSLog(@"艺术家: %@", artistName);
                NSLog(@"流派: %@", genre);
                NSLog(@"播放时长: %.2f 分钟", [duration doubleValue] / 60.0);
                if (releaseDate) {
                    NSLog(@"发布日期: %@", releaseDate);
                } else {
                    NSLog(@"发布日期: 未知");
                }
            } else {
                NSLog(@"未识别的曲目对象：%@", item);
            }
        }
        

        NSDate *releaseDate = albumData[@"releaseDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy";
        NSString *year = [dateFormatter stringFromDate:releaseDate];

        self.albumGenreAndReleaseDateLabel.text = [NSString stringWithFormat:@"%@ ・ %@年", albumData[@"genre"], year ?: @"未知年份"];

        [UIView animateWithDuration:0.2 animations:^{
            self.albumTitleLabel.alpha = 1;
            self.albumArtistLabel.alpha = 1;
            self.albumGenreAndReleaseDateLabel.alpha = 1;
        }];
    }];
}

// 选择专辑封面时调用一次。可以添加长按逻辑
- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didSelectPageItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectPageItemAtIndex >>> %@", @(index));
}

- (IBAction)pageControlAction:(UIPageControl *)sender {
    // 分页控件变化时调用
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

