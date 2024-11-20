//
//  Song+CoreDataProperties.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/20.
//
//

#import "Song+CoreDataProperties.h"

@implementation Song (CoreDataProperties)

+ (NSFetchRequest<Song *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Song"];
}

@dynamic title;
@dynamic duration;
@dynamic album;

@end
