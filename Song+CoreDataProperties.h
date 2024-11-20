//
//  Song+CoreDataProperties.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/20.
//
//

#import "Song+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Song (CoreDataProperties)

+ (NSFetchRequest<Song *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) int16_t duration;
@property (nullable, nonatomic, retain) Album *album;

@end

NS_ASSUME_NONNULL_END
