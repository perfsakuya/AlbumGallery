//
//  FavoriteData+CoreDataProperties.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/28.
//
//

#import "FavoriteData+CoreDataProperties.h"

@implementation FavoriteData (CoreDataProperties)

+ (NSFetchRequest<FavoriteData *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"FavoriteData"];
}

@dynamic indices;

@end
