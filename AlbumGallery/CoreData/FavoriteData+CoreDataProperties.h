//
//  FavoriteData+CoreDataProperties.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/28.
//
//

#import "FavoriteData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface FavoriteData (CoreDataProperties)

+ (NSFetchRequest<FavoriteData *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, retain) NSObject *indices;

@end

NS_ASSUME_NONNULL_END
