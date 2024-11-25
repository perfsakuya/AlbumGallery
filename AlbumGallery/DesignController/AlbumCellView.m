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
        self.albumCoverImageView.layer.cornerRadius = 8; // 设置圆角半径
        self.albumCoverImageView.layer.masksToBounds = YES; // 裁剪超出圆角的部分
        // self.albumCoverImageView.layer.borderColor = [UIColor lightGrayColor].CGColor; // 添加边框颜色
        // self.albumCoverImageView.layer.borderWidth = 1.0; // 设置边框宽度
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
    
    CGFloat padding = 12; // 调整图片左右的内边距，缩小空白区域
    CGFloat imageSize = self.contentView.bounds.size.width - padding * 2; // 图片的宽度和高度相等
    imageSize *= 1.5; // 让图片略微放大 10%
    CGFloat spacing = 3; // 图片与文字之间的间距
//    CGFloat labelHeight = (self.contentView.bounds.size.height - imageSize - spacing * 2) / 4;
    CGFloat labelHeight = 20;
    
    // 限制图片宽度以保持居中
    imageSize = MIN(imageSize, self.contentView.bounds.size.width - padding * 2);
    CGFloat imageX = padding; // 确保图片与文字左对齐
    
    // 图片
    self.albumCoverImageView.frame = CGRectMake(imageX, 10, imageSize, imageSize);
    self.albumCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.albumCoverImageView.clipsToBounds = YES; // 裁剪超出边界的部分
    
    // 专辑名
    self.albumTitleLabel.frame = CGRectMake(imageX, CGRectGetMaxY(self.albumCoverImageView.frame) + spacing,
                                            imageSize, labelHeight);
    
    // 作曲家
    self.artistNameLabel.frame = CGRectMake(imageX, CGRectGetMaxY(self.albumTitleLabel.frame) + spacing,
                                            imageSize, labelHeight);
}
@end
