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
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

#pragma mark -  Album List
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = -10; //magic number
    layout.minimumLineSpacing = -10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[AlbumCellView class] forCellWithReuseIdentifier:@"AlbumCell"];

    CGRect collectionViewFrame = self.collectionView.frame;
    collectionViewFrame.origin.y += 50;
    self.collectionView.frame = collectionViewFrame;
    
    [self.view addSubview:self.collectionView];
    
    [self loadAlbums];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    NSDictionary *album = self.albums[indexPath.item];

    UIImage *coverImage = (album[@"coverImage"] && album[@"coverImage"] != [NSNull null]) ? album[@"coverImage"] : [UIImage imageNamed:@"NO_DATA"];
    cell.albumCoverImageView.image = coverImage;
    
    NSString *title = (album[@"title"] && album[@"title"] != [NSNull null]) ? album[@"title"] : @"未知标题";
    cell.albumTitleLabel.text = title;
    
    NSString *artist = (album[@"artist"] && album[@"artist"] != [NSNull null]) ? album[@"artist"] : @"未知艺术家";
    cell.artistNameLabel.text = artist;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width / 2;
    CGFloat height = width + 40; // 封面+标签
    return CGSizeMake(width, height);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 每次打开页面都重新加载专辑信息
    // TODO: 如何优化性能
    [self loadAlbums];
    NSLog(@"triggered veiwWillAppear");

}

- (void)loadAlbums {
    NSMutableSet<NSNumber *> *favorites = [MusicLibraryManager sharedManager].favoriteIndices;
    
    [[MusicLibraryManager sharedManager] fetchAlbumsWithCompletion:^(NSArray<NSDictionary *> *albums, NSError *error) {
        if (error) {
            NSLog(@"Error loading albums: %@", error.localizedDescription);
            return;
        }
        //在这里，我们读取favorites索引集合中对应的专辑，存放到favoriteAlbums中
        self.albums = albums;
        NSLog(@"收藏的专辑索引: %@", favorites);
        
        if (favorites.count > 0) {
            // 从所有专辑中筛选出收藏的专辑
            self.favoriteAlbums = [NSMutableArray array];
            for (NSNumber *index in favorites) {
                if (index.integerValue < albums.count) {
                    [self.favoriteAlbums addObject:albums[index.integerValue]];
                }
            }
        } else {
            NSLog(@"没有收藏的专辑");
        }
        NSLog(@"收藏的专辑: %@", self.favoriteAlbums);
        [self.collectionView reloadData];
    }];
    
}


@end
