//
//  MusicLibraryManager.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/21.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicLibraryManager.h"

@implementation MusicLibraryManager

+ (instancetype)sharedManager {
    static MusicLibraryManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
        sharedManager.favoriteIndices = [NSMutableSet set]; // 初始化集合
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

@end
