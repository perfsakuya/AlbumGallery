//
//  MusicLibraryManager.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/21.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MusicLibraryManager : NSObject

// 单例方法
+ (instancetype)sharedManager;

// 请求权限
- (void)requestAuthorizationWithCompletion:(void (^)(BOOL granted, NSError *error))completion;

// 查询库中的所有专辑信息
- (void)fetchAlbumsWithCompletion:(void (^)(NSArray<NSDictionary *> *albums, NSError *error))completion;

@end

@implementation MusicLibraryManager

+ (instancetype)sharedManager {
    static MusicLibraryManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
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
            // 专辑集合信息
            NSArray *items = [albumCollection items]; // 专辑中的所有曲目
            MPMediaItem *representativeItem = [albumCollection representativeItem];
            if (!representativeItem) continue;

            // 专辑相关信息
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

@end
