//
//  Album+CoreDataProperties.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/22.
//
//

#import "Album+CoreDataProperties.h"

@implementation Album (CoreDataProperties)

+ (NSFetchRequest<Album *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Album"];
}

@dynamic artist;
@dynamic coverImage;
@dynamic genre;
@dynamic id;
@dynamic releaseDate;
@dynamic title;
@dynamic trackCount;

@end
