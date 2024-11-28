//
//  CoverFlowViewController.h
//  AlbumGallery
//
//  Created by 汤骏哲 on 2024/11/17.
//

#import <UIKit/UIKit.h>

@class CFCoverFlowView;
@interface CoverFlowViewController : UIViewController

@property (weak, nonatomic) IBOutlet CFCoverFlowView *coverFlowView1;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)pageControlAction:(id)sender;

@end

@protocol CoverFlowViewControllerDelegate <NSObject>

- (void)coverFlowViewController:(CoverFlowViewController *)controller didUpdateFavoriteIndices:(NSMutableSet<NSNumber *> *)favoriteIndices;

@end
