//
//  MusicLibraryManager.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MusicLibraryManager : NSObject

// 单例方法
+ (instancetype)sharedManager;

// 请求权限
- (void)requestAuthorizationWithCompletion:(void (^)(BOOL granted, NSError *error))completion;

// 获取用户 Apple Music 数据库中的专辑信息
- (void)fetchAlbumsWithCompletion:(void (^)(NSArray<NSDictionary *> *albums, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
