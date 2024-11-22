//
//  AlbumIO.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/21.
//

//#import "AlbumIO.h"
//#import <CoreData/CoreData.h>
//#import "AppDelegate.h"
//#import "Album+CoreDataClass.h"
//#import "Song+CoreDataClass.h"
//
//@implementation AlbumIO
//
//+ (NSManagedObjectContext *)managedObjectContext {
//    NSPersistentContainer *container = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer;
//    return container.viewContext;
//}
//
//// 写入数据
//+ (void)saveAlbumWithName:(NSString *)name
//                  composer:(NSString *)composer
//                     genre:(NSString *)genre
//               coverImage:(UIImage *)coverImage
//                    songs:(NSArray<NSDictionary *> *)songs {
//    NSManagedObjectContext *context = [self managedObjectContext];
//
//    // 创建新专辑实体
//    Album *album = [[Album alloc] initWithContext:context];
//    album.name = name;
//    album.composer = composer;
//    album.genre = genre;
//
//    if (coverImage) {
//        album.coverImage = UIImagePNGRepresentation(coverImage);
//    }
//
//    // 创建并关联歌曲
//    for (NSDictionary *songData in songs) {
//        Song *song = [[Song alloc] initWithContext:context];
//        song.title = songData[@"title"];
//        song.duration = [songData[@"duration"] intValue];
//        song.album = album;
//    }
//
//    // 保存上下文
//    NSError *error = nil;
//    if (![context save:&error]) {
//        NSLog(@"Failed to save album: %@", error.localizedDescription);
//    } else {
//        NSLog(@"Album saved successfully.");
//    }
//}
//
//// 读取所有专辑
//+ (NSArray *)fetchAllAlbums {
//    NSManagedObjectContext *context = [self managedObjectContext];
//    NSFetchRequest *fetchRequest = [Album fetchRequest];
//
//    NSError *error = nil;
//    NSArray *albums = [context executeFetchRequest:fetchRequest error:&error];
//
//    if (error) {
//        NSLog(@"Failed to fetch albums: %@", error.localizedDescription);
//        return @[];
//    }
//
//    return albums;
//}
//
//+ (void)saveAlbumFromImagesDirectory {
//    NSString *directoryPath = [[NSBundle mainBundle] pathForResource:@"Images" ofType:nil];
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSError *error = nil;
//
//    // 获取目录中的所有文件
//    NSArray<NSString *> *imagePaths = [fileManager contentsOfDirectoryAtPath:directoryPath error:&error];
//    if (error) {
//        NSLog(@"Failed to read Images directory: %@", error.localizedDescription);
//        return;
//    }
//
//    NSMutableArray<NSDictionary *> *songs = [NSMutableArray array];
//    UIImage *coverImage = nil;
//
//    for (NSString *fileName in imagePaths) {
//        NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
//
//        // 确保是图片文件
//        if (![fileName.pathExtension.lowercaseString isEqualToString:@"png"] &&
//            ![fileName.pathExtension.lowercaseString isEqualToString:@"jpg"]) {
//            continue;
//        }
//
//        // 提取歌曲信息（假设文件名为 title_duration.png）
//        NSArray<NSString *> *components = [fileName.stringByDeletingPathExtension componentsSeparatedByString:@"_"];
//        if (components.count < 2) {
//            NSLog(@"Skipping file with invalid format: %@", fileName);
//            continue;
//        }
//
//        NSString *title = components[0];
//        NSInteger duration = [components[1] integerValue];
//
//        // 第一张图片作为专辑封面
//        if (!coverImage) {
//            coverImage = [UIImage imageWithContentsOfFile:filePath];
//        }
//
//        // 添加歌曲信息
//        [songs addObject:@{
//            @"title": title,
//            @"duration": @(duration)
//        }];
//    }
//
//    if (!coverImage) {
//        NSLog(@"No valid cover image found in directory.");
//        return;
//    }
//
//    // 写入数据库
//    [AlbumIO saveAlbumWithName:@"My Album"
//                      composer:@"John Doe"
//                         genre:@"Classical"
//                   coverImage:coverImage
//                        songs:songs];
//}
//
//@end
