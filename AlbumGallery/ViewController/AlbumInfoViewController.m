//
//  AlbumInfoViewController.m
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/25.
//

#import "AlbumInfoViewController.h"

@interface AlbumInfo ()

@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIButton *closeButton;

@end

// TODO: 本来是在这里显示专辑封面和标题（模仿am），并且设置保存按钮，或者长按保存，现在临时起意改成显示当前专辑信息
@implementation AlbumInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 封面图片
    // 创建容器视图
    UIView *shadowContainerView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, self.view.bounds.size.width - 100, self.view.bounds.size.width - 100)];

    // 配置阴影
    shadowContainerView.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
    shadowContainerView.layer.shadowOffset = CGSizeMake(0, 4);            // 阴影偏移量
    shadowContainerView.layer.shadowOpacity = 0.3;                       // 阴影透明度
    shadowContainerView.layer.shadowRadius = 10;                         // 阴影模糊半径
    shadowContainerView.layer.masksToBounds = NO;                        // 确保阴影显示

    // 添加到主视图
    [self.view addSubview:shadowContainerView];

    // 创建图片视图
    self.coverImageView = [[UIImageView alloc] initWithFrame:shadowContainerView.bounds];
    self.coverImageView.contentMode = UIViewContentModeScaleAspectFill;   // 设置图片模式
    self.coverImageView.clipsToBounds = YES;                             // 确保圆角生效
    self.coverImageView.layer.cornerRadius = 20;                         // 设置圆角

    // 将图片视图添加到容器视图
    [shadowContainerView addSubview:self.coverImageView];

    // 专辑名称
    [self.view addSubview:self.coverImageView];
    self.albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.coverImageView.frame) + 20, self.view.bounds.size.width - 40, 25)];
    self.albumNameLabel.font = [UIFont boldSystemFontOfSize:24];
    self.albumNameLabel.textAlignment = NSTextAlignmentCenter;
    self.albumNameLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.albumNameLabel];

    // 作曲家
    self.creatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.albumNameLabel.frame) + 10, self.view.bounds.size.width - 40, 25)];
    self.creatorLabel.font = [UIFont systemFontOfSize:24];
    self.creatorLabel.textAlignment = NSTextAlignmentCenter;
    self.creatorLabel.textColor = [UIColor colorWithRed: 0.98 green: 0.14 blue: 0.23 alpha: 1.00];
    [self.view addSubview:self.creatorLabel];


    // 更新内容
    [self updateAlbumInfo];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // 放大封面并展示保存按钮
        [UIView animateWithDuration:0.3 animations:^{
            self.coverImageView.transform = CGAffineTransformMakeScale(1.5, 1.5); // 放大封面
        }];
        
        // 弹出保存按钮
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选项"
                                                                       message:@"你想要保存封面吗？"
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        // 保存封面图片
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"保存图片"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
            [self saveImageToPhotos];
        }];
        
        // 取消
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [alert addAction:saveAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        // 还原封面大小
        [UIView animateWithDuration:0.3 animations:^{
            self.coverImageView.transform = CGAffineTransformIdentity; // 恢复原始大小
        }];
    }
}

- (void)saveImageToPhotos {
    if (self.coverImageView.image) {
        UIImageWriteToSavedPhotosAlbum(self.coverImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    } else {
        NSLog(@"封面图片为空，无法保存");
    }
}

// 保存完成后的回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *message = error ? @"保存失败" : @"图片已保存到相册";
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//- (void)shareImage {
//    if (self.coverImageView.image) {
//        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[self.coverImageView.image] applicationActivities:nil];
//        activityVC.popoverPresentationController.sourceView = self.view; // iPad 适配
//        [self presentViewController:activityVC animated:YES completion:nil];
//    } else {
//        NSLog(@"封面图片为空，无法分享");
//    }
//}

- (void)updateAlbumInfo {
    if (self.albumData) {
        // 设置封面图片
        UIImage *coverImage = self.albumData[@"coverImage"]; // 假设是 UIImage 类型
        if (coverImage) {
            self.coverImageView.image = coverImage;
        } else {
            self.coverImageView.image = [UIImage imageNamed:@"placeholder"]; // 设置默认图片
        }

        // 设置专辑名称
        self.albumNameLabel.text = self.albumData[@"title"] ?: @"未知专辑";

        // 设置制作者名称
        self.creatorLabel.text = self.albumData[@"artist"] ?: @"未知艺术家";
    } else {
        self.albumNameLabel.text = @"未选择专辑";
        self.creatorLabel.text = @"";
        self.coverImageView.image = [UIImage imageNamed:@"placeholder"];
    }
}

//- (void)closeButtonTapped {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

@end
