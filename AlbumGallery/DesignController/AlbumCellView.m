//
//  AlbumCellView.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/25.
//

#import "AlbumCellView.h"

@implementation AlbumCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 专辑封面
        self.albumCoverImageView = [[UIImageView alloc] init];
        self.albumCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.albumCoverImageView.clipsToBounds = YES;
        self.albumCoverImageView.layer.cornerRadius = 8;
        self.albumCoverImageView.layer.masksToBounds = YES;
        // self.albumCoverImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        // self.albumCoverImageView.layer.borderWidth = 1.0;
        [self.contentView addSubview:self.albumCoverImageView];
        
        // 专辑名
        self.albumTitleLabel = [[UILabel alloc] init];
        self.albumTitleLabel.font = [UIFont boldSystemFontOfSize:14];
        self.albumTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.albumTitleLabel.numberOfLines = 1;
        [self.contentView addSubview:self.albumTitleLabel];
        
        // 作曲家
        self.artistNameLabel = [[UILabel alloc] init];
        self.artistNameLabel.font = [UIFont boldSystemFontOfSize:12];
        self.artistNameLabel.textAlignment = NSTextAlignmentLeft;
        self.artistNameLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.artistNameLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat padding = 12;
    CGFloat imageSize = self.contentView.bounds.size.width - padding * 2; // 图片的宽度和高度相等
    imageSize *= 1.5;
    CGFloat spacing = 3;
//    CGFloat labelHeight = (self.contentView.bounds.size.height - imageSize - spacing * 2) / 4;
    CGFloat labelHeight = 20;
    
    imageSize = MIN(imageSize, self.contentView.bounds.size.width - padding * 2);
    CGFloat imageX = padding;
    
    // 图片
    self.albumCoverImageView.frame = CGRectMake(imageX, 10, imageSize, imageSize);
    self.albumCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.albumCoverImageView.clipsToBounds = YES;
    
    // 专辑名
    self.albumTitleLabel.frame = CGRectMake(imageX, CGRectGetMaxY(self.albumCoverImageView.frame) + spacing,
                                            imageSize, labelHeight);
    
    // 作曲家
    self.artistNameLabel.frame = CGRectMake(imageX, CGRectGetMaxY(self.albumTitleLabel.frame) + spacing,
                                            imageSize, labelHeight);
}
@end
