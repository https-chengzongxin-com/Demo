//
//  THKViewController.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/14.
//

#import <UIKit/UIKit.h>
#import "THKViewModel.h"
#import "THKViewControllerProtocol.h"
#import "UIViewController+Godeye.h"
#import "GEWidgetEvent.h"
NS_ASSUME_NONNULL_BEGIN

@interface THKViewController : UIViewController <THKViewControllerProtocol>

@property (nonatomic, strong, readonly) THKViewModel *viewModel;

/// View绑定ViewModel
/// @param viewModel 视图模型
- (instancetype)initWithViewModel:(THKViewModel *)viewModel;


/// 绑定对应view的viewModel
- (void)bindViewModel;

- (void)bindViewModel:(THKViewModel *)viewModel;

- (void)thk_hideNavShadowImageView;

@end

NS_ASSUME_NONNULL_END
