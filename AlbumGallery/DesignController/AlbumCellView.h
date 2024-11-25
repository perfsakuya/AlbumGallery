//
//  AlbumCellView.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/25.
//

#import <UIKit/UIKit.h>

@interface AlbumCellView: UICollectionViewCell

@property (nonatomic, strong) UIImageView *albumCoverImageView;
@property (nonatomic, strong) UILabel *albumTitleLabel;
@property (nonatomic, strong) UILabel *artistNameLabel;

@end
