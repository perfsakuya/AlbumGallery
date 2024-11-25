//
//  AlbumListViewController.m
//  TestObjC
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import "AlbumListViewController.h"
#import "AlbumCellView.h"
#import "MusicLibraryManager.h"

//@interface AlbumListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchResultsUpdating>
@interface AlbumListViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSDictionary *> *albums;

// TODO: 添加搜索框
//@property (nonatomic, strong) UISearchController *searchController;
//@property (nonatomic, strong) NSArray<NSDictionary *> *filteredAlbums;

@end

@implementation AlbumListViewController

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
    
//#pragma mark - Search Bar
//
//
//    self.navigationController.navigationBar.hidden = NO;
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchResultsUpdater = self;
//    self.searchController.obscuresBackgroundDuringPresentation = NO;
//    self.searchController.searchBar.placeholder = @"搜索专辑";
//    self.navigationItem.searchController = self.searchController;
//    self.definesPresentationContext = YES;
//
//    UITextField *searchTextField = [self.searchController.searchBar valueForKey:@"searchField"];
//
//    searchTextField.layer.cornerRadius = 10.0;
//    searchTextField.layer.masksToBounds = YES;
//    searchTextField.layer.borderWidth = 1.0;
//    searchTextField.layer.borderColor = [UIColor grayColor].CGColor;
//
//    searchTextField.backgroundColor = [UIColor whiteColor];
//    [blurView.contentView addSubview:self.searchController.searchBar];
//
//
////    CGRect searchBarFrame = self.searchController.searchBar.frame;
////    UIEdgeInsets safeAreaInsets = self.view.safeAreaInsets;
////    searchBarFrame.origin.y = safeAreaInsets.top + 10; // 避免与刘海重叠
////    self.searchController.searchBar.frame = searchBarFrame;
//    CGRect searchBarFrame = self.searchController.searchBar.frame;
//    searchBarFrame.origin.y += 50; // 向下移动50点
//    self.searchController.searchBar.frame = searchBarFrame;
//
//
//    // 初始化 filteredAlbums
//    self.filteredAlbums = self.albums;
//
//    self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
//    [self.view addSubview:self.searchController.searchBar];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albums.count;
}
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.filteredAlbums.count;
//}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AlbumCell" forIndexPath:indexPath];
    
    NSDictionary *album = self.albums[indexPath.item];
//    NSDictionary *album = self.filteredAlbums[indexPath.item];

    // 专辑封面
    UIImage *coverImage = (album[@"coverImage"] && album[@"coverImage"] != [NSNull null]) ? album[@"coverImage"] : [UIImage imageNamed:@"NO_DATA"];
    cell.albumCoverImageView.image = coverImage;
    
    // 专辑标题
    NSString *title = (album[@"title"] && album[@"title"] != [NSNull null]) ? album[@"title"] : @"未知标题";
    cell.albumTitleLabel.text = title;
    
    // 艺术家名
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

#pragma mark - UISearchResultsUpdating

- (void)loadAlbums {
    [[MusicLibraryManager sharedManager] fetchAlbumsWithCompletion:^(NSArray<NSDictionary *> *albums, NSError *error) {
        if (error) {
            NSLog(@"Error loading albums: %@", error.localizedDescription);
            return;
        }
        self.albums = albums;
//        self.filteredAlbums = self.albums;
        [self.collectionView reloadData];
    }];
}

//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    NSString *searchText = searchController.searchBar.text.lowercaseString;
//
//    if (searchText.length == 0) {
//        // 显示全部数据
//        self.filteredAlbums = self.albums;
//    } else {
//        // 筛选专辑
//        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *album, NSDictionary<NSString *,id> * _Nullable bindings) {
//            NSString *title = album[@"title"];
//            NSString *artist = album[@"artist"];
//            return [title.lowercaseString containsString:searchText] || [artist.lowercaseString containsString:searchText];
//        }];
//        self.filteredAlbums = [self.albums filteredArrayUsingPredicate:predicate];
//    }
//    
//    [self.collectionView reloadData];
//}

@end
