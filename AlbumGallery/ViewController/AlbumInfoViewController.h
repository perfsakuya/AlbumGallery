//
//  AlbumShareViewController.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/25.
//

#import <UIKit/UIKit.h>

@interface AlbumInfo : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *albumData;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *albumNameLabel;
@property (nonatomic, strong) UILabel *creatorLabel;
@property (nonatomic, strong) UILabel *genreLabel;
@property (nonatomic, strong) UILabel *releaseDateLabel;
@property (nonatomic, strong) UILabel *trackCountLabel;
@property (nonatomic, strong) UILabel *detailsLabel;
@property (nonatomic, strong) UITextView *trackListView;

@end
