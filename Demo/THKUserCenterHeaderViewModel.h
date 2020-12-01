//
//  THKUserCenterHeaderViewModel.h
//  Demo
//
//  Created by Joe.cheng on 2020/12/1.
//

#import "THKViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface THKUserCenterHeaderViewModel : THKViewModel

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *tagName;
@property (nonatomic, strong, readonly) NSString *signature;
@property (nonatomic, strong, readonly) NSAttributedString *followAttrText;
@property (nonatomic, strong, readonly) NSAttributedString *fansAttrText;
@property (nonatomic, strong, readonly) NSAttributedString *befollowAttrText;

// layout
@property (nonatomic, assign) CGFloat bgImageH;
@property (nonatomic, assign) CGFloat avatarTop;
@property (nonatomic, assign) CGFloat avatarH;
@property (nonatomic, assign) CGFloat nameTop;
@property (nonatomic, assign) CGFloat nameH;
@property (nonatomic, assign) CGFloat tagTop;
@property (nonatomic, assign) CGFloat tagH;
@property (nonatomic, assign) CGFloat signatureTop;
@property (nonatomic, assign) CGFloat signatureH;
@property (nonatomic, assign) CGFloat followCountTop;
@property (nonatomic, assign) CGFloat followCountH;
@property (nonatomic, assign) CGFloat storeTop;
@property (nonatomic, assign) CGFloat storeH;
@property (nonatomic, assign) CGFloat ecologicalTop;
@property (nonatomic, assign) CGFloat ecologicalH;
@property (nonatomic, assign) CGFloat serviceTop;
@property (nonatomic, assign) CGFloat serviceH;

// calculate
@property (nonatomic, assign) CGFloat followCountW;
@property (nonatomic, assign) CGFloat fansCountW;
@property (nonatomic, assign) CGFloat beFollowCountW;

- (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
