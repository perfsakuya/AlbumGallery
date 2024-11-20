//
//  Album+CoreDataProperties.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/20.
//
//

#import "Album+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Album (CoreDataProperties)

+ (NSFetchRequest<Album *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *composer;
@property (nullable, nonatomic, copy) NSString *genre;
@property (nullable, nonatomic, retain) NSData *coverImage;
@property (nullable, nonatomic, retain) Song *songs;

@end

NS_ASSUME_NONNULL_END
