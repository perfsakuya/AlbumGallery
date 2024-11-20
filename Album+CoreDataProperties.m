//
//  Album+CoreDataProperties.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/20.
//
//

#import "Album+CoreDataProperties.h"

@implementation Album (CoreDataProperties)

+ (NSFetchRequest<Album *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Album"];
}

@dynamic name;
@dynamic composer;
@dynamic genre;
@dynamic coverImage;
@dynamic songs;

@end
