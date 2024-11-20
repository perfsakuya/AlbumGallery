//
//  CoverFlowViewController.m
//  TestObjC
//
//  Created by 汤骏哲 on 2024/11/17.
//
#import "CoverFlowViewController.h"
#import "CFCoverFlowView.h"
#import "MusicLibraryManager.h"

@interface CoverFlowViewController () <CFCoverFlowViewDelegate>

@end

@implementation CoverFlowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cover Flow";

// TODO: cover flow下方加上模糊效果；下方加上专辑描述，以及相应的歌曲列表

    
#pragma mark - Cover Flow (1/3 area)
// 创建 Cover Flow 视图
    CFCoverFlowView *coverFlowView = [[CFCoverFlowView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height / 3)];
    
    coverFlowView.pageItemWidth = coverFlowView.bounds.size.height / 1.35;
    coverFlowView.pageItemHeight = coverFlowView.bounds.size.height / 1.35;
    coverFlowView.pageItemCoverWidth = 30.0;
//    coverFlowView.backgroundColor = [UIColor clearColor]; // 确保背景透明
    [self.view addSubview:coverFlowView];

    
#pragma mark - Read & Save Test
    
    // 从 MusicLibraryManager 获取专辑信息
    [[MusicLibraryManager sharedManager] fetchAlbumsWithCompletion:^(NSArray<NSDictionary *> *albums, NSError *error) {
        if (error) {
            NSLog(@"获取专辑信息失败：%@", error.localizedDescription);
            return;
        }

        NSMutableArray<UIImage *> *coverImages = [NSMutableArray array];
        for (NSDictionary *album in albums) {
            // 获取封面图片
            id coverImage = album[@"coverImage"];
            if (coverImage && ![coverImage isKindOfClass:[NSNull class]]) {
                [coverImages addObject:coverImage];
            } else {
                NSLog(@"专辑 %@ 没有封面图片", album[@"title"]);
            }
        }

        if (coverImages.count > 0) {
            // 更新 coverFlowView，传入封面图片数组
            [coverFlowView setPageItemsWithImageArray:coverImages];
        } else {
            NSLog(@"未找到有效的封面图片");
        }
    }];


    
#pragma mark - Album Description
    // TODO: 专辑名、作曲家等内容


#pragma mark - Control Area
    // TODO: 收藏、信息、前往专辑、分享

}

- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didScrollPageItemToIndex:(NSInteger)index {
    NSLog(@"didScrollPageItemToIndex >>> %@", @(index));

    self.pageControl.currentPage = index;
}

- (void)coverFlowView:(CFCoverFlowView *)coverFlowView didSelectPageItemAtIndex:(NSInteger)index {
    NSLog(@"didSelectPageItemAtIndex >>> %@", @(index));
}

- (IBAction)pageControlAction:(UIPageControl *)sender {
    // 可在此添加分页控件变化时的操作代码
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

