//
//  THKDecorationToDoHeaderView.h
//  Demo
//
//  Created by Joe.cheng on 2022/7/19.
//

#import "THKView.h"
#import "THKDecorationToDoHeaderViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKDecorationToDoHeaderView : THKView

@property (nonatomic, strong, readonly) THKDecorationToDoHeaderViewModel *viewModel;

@property (nonatomic, copy) void (^tapItem)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
