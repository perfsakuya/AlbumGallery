//
//  FavoritesViewController.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import "FavoritesViewController.h"
#import "CoverFlowViewController.h"
#import "AlbumCellView.h"
#import "MusicLibraryManager.h"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray<NSDictionary *> *favoriteAlbums;
@property (nonatomic, strong) NSArray<NSDictionary *> *albums;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *noFavoritesLabel;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[MusicLibraryManager sharedManager] loadFavoriteIndicesFromCoreData];

#pragma mark -  Collection View
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 50);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = -10; // magic number
    layout.minimumLineSpacing = -10;

    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[AlbumCellView class] forCellWithReuseIdentifier:@"AlbumCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];

    CGRect collectionViewFrame = self.collectionView.frame;
    collectionViewFrame.origin.y += 50;
    self.collectionView.frame = collectionViewFrame;

    [self.view addSubview:self.collectionView];
    
#pragma mark - No Album View
    
    UILabel *noFavoritesLabel = [[UILabel alloc] init];
    noFavoritesLabel.text = @"无收藏的专辑";
    noFavoritesLabel.textColor = [UIColor grayColor];
    noFavoritesLabel.font = [UIFont systemFontOfSize:26];
    noFavoritesLabel.textAlignment = NSTextAlignmentCenter;
    noFavoritesLabel.hidden = YES;
    noFavoritesLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:noFavoritesLabel];
    self.noFavoritesLabel = noFavoritesLabel;

    CGFloat verticalOffset = -20;
    [NSLayoutConstraint activateConstraints:@[
        [noFavoritesLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [noFavoritesLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:verticalOffset]
    ]];
    
    [self loadAlbums];
}

#pragma mark - Collection View Data Source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.favoriteAlbums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    NSDictionary *album = self.favoriteAlbums[indexPath.item];
    UIImage *coverImage = (album[@"coverImage"] && album[@"coverImage"] != [NSNull null]) ? album[@"coverImage"] : [UIImage imageNamed:@"NO_DATA"];
    cell.albumCoverImageView.image = coverImage;
    NSString *title = (album[@"title"] && album[@"title"] != [NSNull null]) ? album[@"title"] : @"未知标题";
    cell.albumTitleLabel.text = title;
    NSString *artist = (album[@"artist"] && album[@"artist"] != [NSNull null]) ? album[@"artist"] : @"未知艺术家";
    cell.artistNameLabel.text = artist;
    
    return cell;
}

#pragma mark - Initialize Album Data Source

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width / 2;
    CGFloat height = width + 40; // 封面+标签
    return CGSizeMake(width, height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 每次打开页面都重新加载专辑信息
    // TODO: 如何优化性能?
    [self loadAlbums];
}

- (void)loadAlbums {
    [[MusicLibraryManager sharedManager] loadFavoriteIndicesFromCoreData];
    NSMutableSet<NSNumber *> *favorites = [MusicLibraryManager sharedManager].favoriteIndices;

    [[MusicLibraryManager sharedManager] fetchAlbumsWithCompletion:^(NSArray<NSDictionary *> *albums, NSError *error) {
        if (error) {
            NSLog(@"Error loading albums: %@", error.localizedDescription);
            return;
        }

        self.albums = albums;
        NSLog(@"收藏的专辑索引: %@", favorites);

        self.favoriteAlbums = [NSMutableArray array];

        if (favorites.count > 0) {
            for (NSNumber *index in favorites) {
                NSInteger albumIndex = index.integerValue;

                if (albumIndex >= 0 && albumIndex < albums.count) {
                    [self.favoriteAlbums addObject:albums[albumIndex]];
                } else {
                    NSLog(@"无效的专辑索引: %@", index);
                }
            }
            self.noFavoritesLabel.hidden = YES;
            NSLog(@"收藏的专辑: %@", self.favoriteAlbums);
        } else {
            // TODO: 空白时显示提示信息
            NSLog(@"没有收藏的专辑");
            self.noFavoritesLabel.hidden = NO;
        }

        [self.collectionView reloadData];
    }];
}

#pragma mark - Collection View Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];

        // 添加标题标签
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
        titleLabel.text = @"收藏";
        titleLabel.textAlignment = NSTextAlignmentLeft;
        CGRect labelFrame = titleLabel.frame;
        labelFrame.origin.x += 13; // 空出部分像素
        titleLabel.frame = labelFrame;        titleLabel.font = [UIFont boldSystemFontOfSize:30];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [headerView addSubview:titleLabel];

        return headerView;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.bounds.size.width, 50);
}

@end
