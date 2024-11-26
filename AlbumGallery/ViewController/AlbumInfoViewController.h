//
//  AlbumShareViewController.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/25.
//

#import <UIKit/UIKit.h>

@interface AlbumInfo : UIViewController
@property (nonatomic, strong) NSDictionary *albumData;
@property (nonatomic, strong) UIImageView *coverImageView; // 封面图片
@property (nonatomic, strong) UILabel *albumNameLabel;     // 专辑名称
@property (nonatomic, strong) UILabel *creatorLabel;       // 制作者名称
@end
