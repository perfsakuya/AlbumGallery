//
//  MusicLibraryManager.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicLibraryManager : NSObject

+ (instancetype)sharedManager;

// 请求权限
- (void)requestAuthorizationWithCompletion:(void (^)(BOOL granted, NSError *error))completion;

// 获取专辑信息（顺序&shuffle）
- (void)fetchAlbumsWithCompletion:(void (^)(NSArray<NSDictionary *> *albums, NSError *error))completion;
- (void)fetchAlbumsRandomlyWithCompletion:(void (^)(NSArray<NSDictionary *> *albums, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
