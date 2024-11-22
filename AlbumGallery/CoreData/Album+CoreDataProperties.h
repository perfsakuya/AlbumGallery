//
//  Album+CoreDataProperties.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/22.
//
//

#import "Album+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Album (CoreDataProperties)

+ (NSFetchRequest<Album *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *artist;
@property (nullable, nonatomic, retain) NSData *coverImage;
@property (nullable, nonatomic, copy) NSString *genre;
@property (nullable, nonatomic, copy) NSUUID *id;
@property (nullable, nonatomic, copy) NSDate *releaseDate;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int64_t trackCount;

@end

NS_ASSUME_NONNULL_END
