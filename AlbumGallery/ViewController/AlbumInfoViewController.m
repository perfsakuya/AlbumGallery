//
//  AlbumInfoViewController.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/25.
//

#import "AlbumInfoViewController.h"
#import "MediaPlayer/MediaPlayer.h"
@interface AlbumInfo ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *songsTableView;

@end

// TODO: 本来是在这里显示专辑封面和标题（模仿am），并且设置保存按钮，或者长按保存，现在临时起意改成显示当前专辑信息
@implementation AlbumInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 封面图片
    CGFloat imageSize = 200;
    self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - imageSize) / 2, 60, imageSize, imageSize)];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.clipsToBounds = YES;
    self.coverImageView.layer.cornerRadius = 8; // 圆角
    self.coverImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.coverImageView.layer.shadowOpacity = 0.3;
    self.coverImageView.layer.shadowOffset = CGSizeMake(0, 4);
    self.coverImageView.layer.shadowRadius = 6;
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.coverImageView addGestureRecognizer:longPressRecognizer];
    self.coverImageView.userInteractionEnabled = YES;

    [self.view addSubview:self.coverImageView];

    // 专辑名称
    self.albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame) + 20, self.view.bounds.size.width - 40, 60)];
    self.albumNameLabel.textAlignment = NSTextAlignmentCenter;
    self.albumNameLabel.font = [UIFont boldSystemFontOfSize:25];
    self.albumNameLabel.textColor = [UIColor blackColor];
    self.albumNameLabel.numberOfLines = 2;
    self.albumNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:self.albumNameLabel];

    // 艺术家名称
    self.creatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.albumNameLabel.frame) + 10, self.view.bounds.size.width - 40, 25)];
    self.creatorLabel.textAlignment = NSTextAlignmentCenter;
    self.creatorLabel.font = [UIFont systemFontOfSize:16];
    self.creatorLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.creatorLabel];
    
    // 流派
    self.genreLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.creatorLabel.frame) + 10, self.view.bounds.size.width - 40, 18)];
    self.genreLabel.textAlignment = NSTextAlignmentCenter;
    self.genreLabel.font = [UIFont systemFontOfSize:14];
    self.genreLabel.textColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 1.00];
    [self.view addSubview:self.genreLabel];
    
    // 发布日期
    self.releaseDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.genreLabel.frame) + 10, self.view.bounds.size.width - 40, 18)];
    self.releaseDateLabel.textAlignment = NSTextAlignmentCenter;
    self.releaseDateLabel.font = [UIFont systemFontOfSize:14];
    self.releaseDateLabel.textColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 1.00];
    [self.view addSubview:self.releaseDateLabel];
    
    // 曲目数量
    self.trackCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.releaseDateLabel.frame) + 10, self.view.bounds.size.width - 40, 18)];
    self.trackCountLabel.textAlignment = NSTextAlignmentCenter;
    self.trackCountLabel.font = [UIFont systemFontOfSize:14];
    self.trackCountLabel.textColor = [UIColor colorWithRed: 0.54 green: 0.54 blue: 0.56 alpha: 1.00];
    [self.view addSubview:self.trackCountLabel];
    
    // 歌曲列表
    self.songsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.trackCountLabel.frame) + 20, self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetMaxY(self.releaseDateLabel.frame) - 100) style:UITableViewStylePlain];
    self.songsTableView.delegate = self;
    self.songsTableView.dataSource = self;
    self.songsTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.songsTableView];
    
    [self updateAlbumInfo];
}

#pragma mark - Update Album Info
- (void)updateAlbumInfo {
    if (self.albumData) {
        UIImage *coverImage = self.albumData[@"coverImage"];
        self.coverImageView.image = coverImage ? coverImage : [UIImage imageNamed:@"placeholder"];
        self.albumNameLabel.text = self.albumData[@"title"] ?: @"未知专辑";
        self.creatorLabel.text = self.albumData[@"artist"] ?: @"未知艺术家";
        
        NSNumber *trackCount = self.albumData[@"trackCount"];
        self.trackCountLabel.text = trackCount ? [NSString stringWithFormat:@"资料库中的曲目数量: %@", trackCount] : @"未知曲目数量";

        NSString *genre = self.albumData[@"genre"];
        self.genreLabel.text = genre ? [NSString stringWithFormat:@"流派: %@", genre] : @"未知流派";

        id releaseDate = self.albumData[@"releaseDate"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        if ([releaseDate isKindOfClass:[NSDate class]]) {
            NSString *date = [dateFormatter stringFromDate:releaseDate];
            self.releaseDateLabel.text = [NSString stringWithFormat:@"发布时间: %@", date ?: @"未知年份"];
        } else {
            self.releaseDateLabel.text = @"未知年份";
        }
    } else {
        NSLog(@"专辑信息为空");
    }
    
    [self.songsTableView reloadData];
}

#pragma mark - Update Song List Data

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *songs = self.albumData[@"items"];
    return songs ? songs.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SongCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }

    NSArray *songs = self.albumData[@"items"];
    MPMediaItem *item = songs[indexPath.row];

    NSString *trackTitle = [item valueForProperty:MPMediaItemPropertyTitle] ?: @"未知曲目";
    NSString *artist = [item valueForProperty:MPMediaItemPropertyArtist] ?: @"未知艺术家";
    NSNumber *duration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration] ?: @0;
    NSInteger minutes = [duration integerValue] / 60;
    NSInteger seconds = [duration integerValue] % 60;
    NSString *formattedDuration = [NSString stringWithFormat:@"%01ld:%02ld", (long)minutes, (long)seconds];

    cell.textLabel.text = trackTitle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", artist, formattedDuration];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}


#pragma mark - Save Album Image
- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:@"保存封面图片到相册？"
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            [self saveImageToPhotos:self.coverImageView.image];
        }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];

        [alertController addAction:saveAction];
        [alertController addAction:cancelAction];

        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)saveImageToPhotos:(UIImage *)image {
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = error ? @"保存失败" : @"保存成功";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

@end
