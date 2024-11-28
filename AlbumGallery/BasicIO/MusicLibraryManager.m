//
//  MusicLibraryManager.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/21.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicLibraryManager.h"
#import "AppDelegate.h"

@implementation MusicLibraryManager

+ (instancetype)sharedManager {
    static MusicLibraryManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
//        sharedManager.favoriteIndices = [NSMutableSet set]; // 初始化集合
        [sharedManager loadFavoriteIndicesFromCoreData]; // 加载收藏数据

    });
    return sharedManager;
}

- (void)requestAuthorizationWithCompletion:(void (^)(BOOL granted, NSError *error))completion {
    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                if (completion) completion(YES, nil);
            } else {
                NSError *error = [NSError errorWithDomain:@"MusicLibraryManagerError"
                                                     code:403
                                                 userInfo:@{NSLocalizedDescriptionKey: @"用户未授权访问 Apple Music"}];
                if (completion) completion(NO, error);
            }
        });
    }];
}

#pragma mark - Fetching Albums
- (void)fetchAlbumsWithCompletion:(void (^)(NSArray<NSDictionary *> *albums, NSError *error))completion {
    if ([MPMediaLibrary authorizationStatus] != MPMediaLibraryAuthorizationStatusAuthorized) {
        NSError *error = [NSError errorWithDomain:@"MusicLibraryManagerError"
                                             code:401
                                         userInfo:@{NSLocalizedDescriptionKey: @"未授权访问 Apple Music 数据库"}];
        if (completion) completion(nil, error);
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<NSDictionary *> *albumArray = [NSMutableArray array];
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        NSArray *albums = [albumsQuery collections];

        for (MPMediaItemCollection *albumCollection in albums) {

            NSArray *items = [albumCollection items]; // 专辑中的所有曲目
            MPMediaItem *representativeItem = [albumCollection representativeItem];
            if (!representativeItem) continue;

            NSString *albumTitle = [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle] ?: @"未知专辑";
            NSString *artistName = [representativeItem valueForProperty:MPMediaItemPropertyArtist] ?: @"未知艺术家";
            NSString *genre = [representativeItem valueForProperty:MPMediaItemPropertyGenre] ?: @"未知流派";
            NSDate *releaseDate = [representativeItem valueForProperty:MPMediaItemPropertyReleaseDate] ?: [NSNull null];
            MPMediaItemArtwork *artwork = [representativeItem valueForProperty:MPMediaItemPropertyArtwork];
            UIImage *albumCover = [artwork imageWithSize:CGSizeMake(100, 100)];

            // 构造专辑信息字典
            NSDictionary *albumInfo = @{
                @"title": albumTitle,
                @"artist": artistName,
                @"genre": genre,
                @"releaseDate": releaseDate,
                @"coverImage": albumCover ?: [NSNull null],
                @"items": items ?: @[], // 专辑集合信息：包含所有曲目
                @"trackCount": @(items.count) // 曲目数量
            };
            [albumArray addObject:albumInfo];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion([albumArray copy], nil);
        });
    });
}


// 和fetchAlbumsWithCompletion方法类似，只是在最后shuffle了一下
- (void)fetchAlbumsRandomlyWithCompletion:(void (^)(NSArray<NSDictionary *> *albums, NSError *error))completion {
    if ([MPMediaLibrary authorizationStatus] != MPMediaLibraryAuthorizationStatusAuthorized) {
        NSError *error = [NSError errorWithDomain:@"MusicLibraryManagerError"
                                             code:401
                                         userInfo:@{NSLocalizedDescriptionKey: @"未授权访问 Apple Music 数据库"}];
        if (completion) completion(nil, error);
        return;
    }

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<NSDictionary *> *albumArray = [NSMutableArray array];
        MPMediaQuery *albumsQuery = [MPMediaQuery albumsQuery];
        NSArray *albums = [albumsQuery collections];

        for (MPMediaItemCollection *albumCollection in albums) {

            NSArray *items = [albumCollection items]; // 专辑中的所有曲目
            MPMediaItem *representativeItem = [albumCollection representativeItem];
            if (!representativeItem) continue;

            NSString *albumTitle = [representativeItem valueForProperty:MPMediaItemPropertyAlbumTitle] ?: @"未知专辑";
            NSString *artistName = [representativeItem valueForProperty:MPMediaItemPropertyArtist] ?: @"未知艺术家";
            NSString *genre = [representativeItem valueForProperty:MPMediaItemPropertyGenre] ?: @"未知流派";
            NSDate *releaseDate = [representativeItem valueForProperty:MPMediaItemPropertyReleaseDate] ?: [NSNull null];
            MPMediaItemArtwork *artwork = [representativeItem valueForProperty:MPMediaItemPropertyArtwork];
            UIImage *albumCover = [artwork imageWithSize:CGSizeMake(100, 100)];

            // 构造专辑信息字典
            NSDictionary *albumInfo = @{
                @"title": albumTitle,
                @"artist": artistName,
                @"genre": genre,
                @"releaseDate": releaseDate,
                @"coverImage": albumCover ?: [NSNull null],
                @"items": items ?: @[], // 专辑集合信息：包含所有曲目
                @"trackCount": @(items.count) // 曲目数量
            };
            [albumArray addObject:albumInfo];
        }

        // shuffle
        for (NSUInteger i = albumArray.count - 1; i > 0; i--) {
            NSUInteger j = arc4random_uniform((uint32_t)(i + 1));
            [albumArray exchangeObjectAtIndex:i withObjectAtIndex:j];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion([albumArray copy], nil);
        });
    });
}

#pragma mark - Save Favorite Indices
- (void)saveFavoriteIndicesToCoreData {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    // 删除旧数据
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteData"];
    NSArray *existingEntries = [context executeFetchRequest:fetchRequest error:nil];
    for (NSManagedObject *entry in existingEntries) {
        [context deleteObject:entry];
    }

    // 保存新的数据
    NSManagedObject *favoriteData = [NSEntityDescription insertNewObjectForEntityForName:@"FavoriteData" inManagedObjectContext:context];
    [favoriteData setValue:self.favoriteIndices forKey:@"indices"]; // 自动序列化为 Transformable 类型

    // 保存上下文
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Failed to save favoriteIndices: %@", error.localizedDescription);
    } else {
        NSLog(@"Successfully saved favoriteIndices to Core Data");
    }
}

- (void)loadFavoriteIndicesFromCoreData {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;

    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FavoriteData"];
    NSArray *results = [context executeFetchRequest:fetchRequest error:nil];

    if (results.count > 0) {
        NSManagedObject *favoriteData = results.firstObject;
        NSSet *storedIndices = [favoriteData valueForKey:@"indices"];
        if (storedIndices) {
            self.favoriteIndices = [storedIndices mutableCopy]; // 转为可变集合
        } else {
            self.favoriteIndices = [NSMutableSet set];
        }
    } else {
        self.favoriteIndices = [NSMutableSet set];
    }

    NSLog(@"Loaded favoriteIndices from Core Data: %@", self.favoriteIndices);
}

@end
