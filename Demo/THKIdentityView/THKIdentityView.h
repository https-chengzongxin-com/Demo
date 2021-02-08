//
//  THKAuthenticationView.h
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import <UIKit/UIKit.h>
#import "THKView.h"
#import "THKIdentityViewModel.h"
NS_ASSUME_NONNULL_BEGIN


/*
 需求描述：
 1.后端增加一个V标识的配置表，随app初始化接口返回，数据结构包含：logo、文字、字体尺寸、字体颜色、背景颜色等；
 2.封装头像右下角的V标识和带文字的V标识，根据type从配置表中匹配对应的数据并展示，从8.15版本开始，都按此方案做；
 */


/// 标识View，支持 Masonry，Frame，Xib，懒加载等形式
/// Full样式，按照Label使用方式（内置Size）不需要设置size约束，可以直接当做Label使用（使用内置Size），如果设置宽度，可能文字会有裁剪（xyz...），高度取icon的图标上下扩大4个像素
/// Icon样式，按照View常规样式，可以使用THKAvatarView，内部已集成标识组件，因为每个业务的UI部分头像大小不一样，所以需要外部设置宽高Size，在右下角显示
@interface THKIdentityView : THKView

@property (nonatomic, strong, readonly) THKIdentityViewModel *viewModel;
/// 获取认证标识View尺寸大小
@property (nonatomic, assign, readonly) CGSize viewSize;

@end

NS_ASSUME_NONNULL_END
