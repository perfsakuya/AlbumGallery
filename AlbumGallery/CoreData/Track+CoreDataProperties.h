//
//  Track+CoreDataProperties.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/22.
//
//

#import "Track+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Track (CoreDataProperties)

+ (NSFetchRequest<Track *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (nullable, nonatomic, copy) NSUUID *id;
@property (nullable, nonatomic, copy) NSString *title;
@property (nonatomic) double duration;
@property (nullable, nonatomic, retain) Album *album;

@end

NS_ASSUME_NONNULL_END
