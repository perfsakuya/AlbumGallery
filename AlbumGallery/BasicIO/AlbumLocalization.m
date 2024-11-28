////
////  AlbumLocalization.m
////  AlbumGallery
////
////  Created by 汤骏哲 on 2024/11/22.
////
//
//#import "AlbumLocalization.h"
//#import "AppDelegate.h"
//#import "Album+CoreDataClass.h"
//#import "Track+CoreDataClass.h"
//#import <MediaPlayer/MediaPlayer.h>
//
//@implementation AlbumLocalization
//
//+ (void)saveAlbumsToCoreData:(NSArray<NSDictionary *> *)albums {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
//
//    for (NSDictionary *albumInfo in albums) {
//        Album *album = [[Album alloc] initWithContext:context];
//        album.id = [NSUUID UUID];
//        album.title = albumInfo[@"title"];
//        album.artist = albumInfo[@"artist"];
//        album.genre = albumInfo[@"genre"];
//        album.releaseDate = albumInfo[@"releaseDate"] ?: nil;
//        album.trackCount = [albumInfo[@"trackCount"] intValue];
//
//        UIImage *coverImage = albumInfo[@"coverImage"];
//        if (coverImage) {
//            album.coverImage = UIImagePNGRepresentation(coverImage);
//        }
//
//        NSArray<MPMediaItem *> *tracks = albumInfo[@"items"];
//        for (MPMediaItem *item in tracks) {
//            Track *track = [[Track alloc] initWithContext:context];
//            track.id = [NSUUID UUID];
//            track.title = [item valueForProperty:MPMediaItemPropertyTitle] ?: @"Unknown Track";
//            track.duration = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration] doubleValue];
//            track.album = album;
//        }
//    }
//
//    NSError *error = nil;
//    if (![context save:&error]) {
//        NSLog(@"Failed to save albums: %@", error.localizedDescription);
//    } else {
//        NSLog(@"Albums saved to Core Data.");
//    }
//}
//
//+ (NSArray<NSDictionary *> *)fetchAlbumsFromCoreData {
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
//
//    NSFetchRequest *request = [Album fetchRequest];
//    NSError *error = nil;
//    NSArray<Album *> *albums = [context executeFetchRequest:request error:&error];
//
//    if (error) {
//        NSLog(@"Failed to fetch albums: %@", error.localizedDescription);
//        return @[];
//    }
//
//    NSMutableArray *result = [NSMutableArray array];
//    for (Album *album in albums) {
//        NSMutableDictionary *albumInfo = [NSMutableDictionary dictionary];
//        albumInfo[@"title"] = album.title;
//        albumInfo[@"artist"] = album.artist;
//        albumInfo[@"genre"] = album.genre;
//        albumInfo[@"releaseDate"] = album.releaseDate;
//        albumInfo[@"trackCount"] = @(album.trackCount);
//        albumInfo[@"coverImage"] = [UIImage imageWithData:album.coverImage];
//        [result addObject:albumInfo];
//    }
//    return [result copy];
//}
//
//@end
