//
//  Track+CoreDataProperties.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/22.
//
//

#import "Track+CoreDataProperties.h"

@implementation Track (CoreDataProperties)

+ (NSFetchRequest<Track *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Track"];
}

@dynamic id;
@dynamic title;
@dynamic duration;
@dynamic album;

@end
