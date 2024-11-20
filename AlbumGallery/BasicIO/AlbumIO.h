//
//  AlbumIO.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AlbumIO : NSObject

+ (void)saveAlbumWithName:(NSString *)name
                  composer:(NSString *)composer
                     genre:(NSString *)genre
               coverImage:(UIImage *)coverImage
                    songs:(NSArray<NSDictionary *> *)songs;

+ (NSArray *)fetchAllAlbums;

+ (void)saveAlbumFromImagesDirectory;

@end
