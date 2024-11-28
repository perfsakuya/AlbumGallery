//
//  AlbumListViewController.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import "AlbumListViewController.h"
#import "AlbumCellView.h"
#import "MusicLibraryManager.h"

@interface AlbumListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *albums;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

#pragma mark -  Album List
    
    // 在collectionview上方添加一个标题label
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 30)];
    self.titleLabel.text = @"收藏";
    self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.view addSubview:self.titleLabel];
    
    
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

#pragma mark - Load & Update

- (void)loadAlbums {
    [[MusicLibraryManager sharedManager] fetchAlbumsWithCompletion:^(NSArray<NSDictionary *> *albums, NSError *error) {
        if (error) {
            NSLog(@"Error loading albums: %@", error.localizedDescription);
            return;
        }
        self.albums = albums;
        [self.collectionView reloadData];
    }];
}



@end
