//
//  FavoritesViewController.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import "FavoritesViewController.h"
#import "CoverFlowViewController.h"
#import "MusicLibraryManager.h"

@interface FavoritesViewController ()

@property (nonatomic, strong) NSArray<NSDictionary *> *favoriteAlbums;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"triggered veiwWillAppear");
    NSMutableSet<NSNumber *> *favorites = [MusicLibraryManager sharedManager].favoriteIndices;
    
    // 遍历数据
    for (NSNumber *index in favorites) {
        NSLog(@"Favorite album index: %@", index);
    }
}



@end
