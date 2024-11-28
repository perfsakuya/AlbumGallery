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
//@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

#pragma mark -  Album List
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 50);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = -10; //magic number
    layout.minimumLineSpacing = -10;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[AlbumCellView class] forCellWithReuseIdentifier:@"AlbumCell"];

    
    [self.collectionView registerClass:[AlbumCellView class] forCellWithReuseIdentifier:@"AlbumCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    
    CGRect collectionViewFrame = self.collectionView.frame;
    collectionViewFrame.origin.y += 50;
    self.collectionView.frame = collectionViewFrame;
    
    [self.view addSubview:self.collectionView];
    
    [self loadAlbums];
    
}

#pragma mark - Collection View Data Source

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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.view.bounds.size.width / 2;
    CGFloat height = width + 40; // 封面+标签
    return CGSizeMake(width, height);
}

#pragma mark - Initialize Album Data Source

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

#pragma mark - Collection View Header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor whiteColor];

        // 添加标题标签
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
        titleLabel.text = @"专辑列表";
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
