//
//  CoverFlowViewController.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/17.
//
#import "CoverFlowViewController.h"
#import "CFCoverFlowView.h"
#import "MusicLibraryManager.h"
#import "AlbumLocalization.h"
#import "AlbumInfoViewController.h"
#import "FavoritesViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CoverFlowViewController () <CFCoverFlowViewDelegate>

@property (nonatomic, strong) NSArray<NSDictionary *> *albumDataArray;
@property (nonatomic, strong) UILabel *albumTitleLabel;
@property (nonatomic, strong) UILabel *albumArtistLabel;
@property (nonatomic, strong) UILabel *albumGenreAndReleaseDateLabel;

@property (nonatomic, strong) UILabel *lineNumberLabel1;
@property (nonatomic, strong) UILabel *songNameLabel1;
@property (nonatomic, strong) UILabel *songDurationLabel1;

@property (nonatomic, strong) UILabel *lineNumberLabel2;
@property (nonatomic, strong) UILabel *songNameLabel2;
@property (nonatomic, strong) UILabel *songDurationLabel2;

@property (nonatomic, strong) UILabel *lineNumberLabel3;
@property (nonatomic, strong) UILabel *songNameLabel3;
@property (nonatomic, strong) UILabel *songDurationLabel3;

@property (nonatomic, assign) NSInteger currentAlbumIndex;
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
    
#pragma mark - Read & Save
    
    // 从 MusicLibraryManager 获取专辑信息，shuffle一下
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
    NSArray *buttonIcons = @[@"heart.fill", @"info.circle"];
    NSArray *buttonTitles = @[@" 收藏", @" 信息"];
    NSArray *buttonSelectors = @[@"favoriteButtonTapped", @"infoButtonTapped"];
    
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
    CGFloat startY = CGRectGetMaxY(self.albumGenreAndReleaseDateLabel.frame) + buttonHeight + 35;
    
    CGFloat labelSpacing = 10;
    CGFloat labelHeight = 40;
    CGFloat separatorHeight = 0.667;
    
    // 分割线
    UIView *separatorLine1 = [[UIView alloc] initWithFrame:CGRectMake(20, startY, self.view.bounds.size.width, separatorHeight)];
    separatorLine1.backgroundColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 0.3];
    [self.view addSubview:separatorLine1];
    
    UIView *separatorLine2 = [[UIView alloc] initWithFrame:CGRectMake(50, startY + 60, self.view.bounds.size.width, separatorHeight)];
    separatorLine2.backgroundColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 0.3];
    [self.view addSubview:separatorLine2];
    
    UIView *separatorLine3 = [[UIView alloc] initWithFrame:CGRectMake(50, startY + 120, self.view.bounds.size.width, separatorHeight)];
    separatorLine3.backgroundColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 0.3];
    [self.view addSubview:separatorLine3];
    
    UIView *separatorLine4 = [[UIView alloc] initWithFrame:CGRectMake(20, startY + 180, self.view.bounds.size.width, separatorHeight)];
    separatorLine4.backgroundColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 0.3];
    [self.view addSubview:separatorLine4];
    
    
    // 三个歌曲的名称和时长
    self.lineNumberLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, startY + labelSpacing, 20, labelHeight)];
    self.lineNumberLabel1.font = [UIFont systemFontOfSize:16];
    self.lineNumberLabel1.textColor = [UIColor grayColor];
    [self.view addSubview:self.lineNumberLabel1];
    
    self.songNameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(50, startY + labelSpacing, 240, labelHeight)];
    self.songNameLabel1.font = [UIFont systemFontOfSize:16];
    self.songNameLabel1.textColor = [UIColor blackColor];
    [self.view addSubview:self.songNameLabel1];

    self.songDurationLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, startY + labelSpacing, 80, labelHeight)];
    self.songDurationLabel1.font = [UIFont boldSystemFontOfSize:16];
    self.songDurationLabel1.textColor = [UIColor grayColor];
    self.songDurationLabel1.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.songDurationLabel1];

    
    self.lineNumberLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, startY + labelHeight + 3 * labelSpacing, 20, labelHeight)];
    self.lineNumberLabel2.font = [UIFont systemFontOfSize:16];
    self.lineNumberLabel2.textColor = [UIColor grayColor];
    [self.view addSubview:self.lineNumberLabel2];
    
    self.songNameLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(50, startY + labelHeight + 3 * labelSpacing, 240, labelHeight)];
    self.songNameLabel2.font = [UIFont systemFontOfSize:16];
    self.songNameLabel2.textColor = [UIColor blackColor];
    [self.view addSubview:self.songNameLabel2];

    self.songDurationLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, startY + labelHeight + 3 * labelSpacing, 80, labelHeight)];
    self.songDurationLabel2.font = [UIFont boldSystemFontOfSize:16];
    self.songDurationLabel2.textColor = [UIColor grayColor];
    self.songDurationLabel2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.songDurationLabel2];

    
    self.lineNumberLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(20, startY + 2 * labelHeight + 5 * labelSpacing, 20, labelHeight)];
    self.lineNumberLabel3.font = [UIFont systemFontOfSize:16];
    self.lineNumberLabel3.textColor = [UIColor grayColor];
    [self.view addSubview:self.lineNumberLabel3];
    
    self.songNameLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(50, startY + 2 * labelHeight + 5 * labelSpacing, 240, labelHeight)];
    self.songNameLabel3.font = [UIFont systemFontOfSize:16];
    self.songNameLabel3.textColor = [UIColor blackColor];
    [self.view addSubview:self.songNameLabel3];

    self.songDurationLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 100, startY + 2 * labelHeight + 5 * labelSpacing, 80, labelHeight)];
    self.songDurationLabel3.font = [UIFont boldSystemFontOfSize:16];
    self.songDurationLabel3.textColor = [UIColor grayColor];
    self.songDurationLabel3.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.songDurationLabel3];
    
}

#pragma mark - Bottom Control
- (void)favoriteButtonTapped {
    NSLog(@"收藏按钮点击");
    NSInteger currentIndex = self.currentAlbumIndex;
    
    if (![MusicLibraryManager sharedManager].favoriteIndices) {
        [MusicLibraryManager sharedManager].favoriteIndices = [NSMutableSet set];
    }

    NSNumber *indexNumber = @(currentIndex);
    
    // 将收藏的专辑索引添加到favoriteIndices中，并且可以取消收藏
    if ([[MusicLibraryManager sharedManager].favoriteIndices containsObject:indexNumber]) {
        [[MusicLibraryManager sharedManager].favoriteIndices removeObject:indexNumber];
        NSLog(@"取消收藏，favoriteIndices: %@", [MusicLibraryManager sharedManager].favoriteIndices);
    } else {
        [[MusicLibraryManager sharedManager].favoriteIndices addObject:indexNumber];
        NSLog(@"已收藏，favoriteIndices: %@", [MusicLibraryManager sharedManager].favoriteIndices);
    }    
}

- (void)infoButtonTapped {
    NSLog(@"信息按钮点击");
    AlbumInfo *shareVC = [[AlbumInfo alloc] init];
    shareVC.modalPresentationStyle = UIModalPresentationPageSheet;

    if (self.currentAlbumIndex >= 0 && self.currentAlbumIndex < self.albumDataArray.count) {
        shareVC.albumData = self.albumDataArray[self.currentAlbumIndex];
    } else {
        NSLog(@"当前专辑索引无效: %@", @(self.currentAlbumIndex));
    }

    [self presentViewController:shareVC animated:YES completion:nil];
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
        [button setTintColor:[UIColor colorWithRed:1.00 green:0.00 blue:0.18 alpha:1.00]];
    }];
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

    self.currentAlbumIndex = index;
    NSDictionary *albumData = self.albumDataArray[index];
    
    // 测试
    NSLog(@"当前专辑信息: %@", albumData);
    NSLog(@"位于索引的%@/%@", @(index), @(self.albumDataArray.count - 1));
    self.pageControl.currentPage = index;

    // 淡入淡出
    [UIView animateWithDuration:0.2 animations:^{
        self.albumTitleLabel.alpha = 0;
        self.albumArtistLabel.alpha = 0;
        self.albumGenreAndReleaseDateLabel.alpha = 0;
        self.lineNumberLabel1.alpha = 0;
        self.songNameLabel1.alpha = 0;
        self.songDurationLabel1.alpha = 0;
        self.lineNumberLabel2.alpha = 0;
        self.songNameLabel2.alpha = 0;
        self.songDurationLabel2.alpha = 0;
        self.lineNumberLabel3.alpha = 0;
        self.songNameLabel3.alpha = 0;
        self.songDurationLabel3.alpha = 0;
    } completion:^(BOOL finished) {
        // 标题、艺术家
        self.albumTitleLabel.text = albumData[@"title"];
        self.albumArtistLabel.text = albumData[@"artist"];
        
        // 年份和流派
        NSDate *releaseDate = albumData[@"releaseDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy";
        NSString *year = [dateFormatter stringFromDate:releaseDate];
        self.albumGenreAndReleaseDateLabel.text = [NSString stringWithFormat:@"%@ ・ %@年", albumData[@"genre"], year ?: @"未知年份"];

        // 三首曲目
        self.lineNumberLabel1.text = @"1";
        self.lineNumberLabel2.text = @"2";
        self.lineNumberLabel3.text = @"3";

        NSArray *currentTrackList = albumData[@"items"];
        NSArray *labels = @[
            @{@"nameLabel": self.songNameLabel1, @"durationLabel": self.songDurationLabel1},
            @{@"nameLabel": self.songNameLabel2, @"durationLabel": self.songDurationLabel2},
            @{@"nameLabel": self.songNameLabel3, @"durationLabel": self.songDurationLabel3}
        ];
        for (NSInteger i = 0; i < 3; i++) {
            UILabel *nameLabel = labels[i][@"nameLabel"];
            UILabel *durationLabel = labels[i][@"durationLabel"];

            if (i < currentTrackList.count) {
                MPMediaItem *item = currentTrackList[i];
                if ([item isKindOfClass:[MPMediaItem class]]) {
                    NSString *trackTitle = [item valueForProperty:MPMediaItemPropertyTitle] ?: @"未知曲目";
                    NSNumber *duration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration] ?: @0;
                    NSInteger minutes = [duration integerValue] / 60;
                    NSInteger seconds = [duration integerValue] % 60;

                    nameLabel.text = trackTitle;
                    durationLabel.text = [NSString stringWithFormat:@"%01ld:%02ld", (long)minutes, (long)seconds];
                } else {
                    nameLabel.text = @"N/A";
                    durationLabel.text = @"-:--";
                }
            } else {
                nameLabel.text = @"N/A";
                durationLabel.text = @"-:--";
            }
        }

        [UIView animateWithDuration:0.2 animations:^{
            self.albumTitleLabel.alpha = 1;
            self.albumArtistLabel.alpha = 1;
            self.albumGenreAndReleaseDateLabel.alpha = 1;
            self.lineNumberLabel1.alpha = 1;
            self.songNameLabel1.alpha = 1;
            self.songDurationLabel1.alpha = 1;
            self.lineNumberLabel2.alpha = 1;
            self.songNameLabel2.alpha = 1;
            self.songDurationLabel2.alpha = 1;
            self.lineNumberLabel3.alpha = 1;
            self.songNameLabel3.alpha = 1;
            self.songDurationLabel3.alpha = 1;
            
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
