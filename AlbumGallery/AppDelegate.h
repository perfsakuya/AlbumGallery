//
//  AppDelegate.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/20.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

