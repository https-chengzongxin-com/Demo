//
//  THKNavigationBarViewController.m
//  Demo
//
//  Created by Joe.cheng on 2022/5/12.
//

#import "THKNavigationBarViewController.h"
#import "THKNavigationBar.h"
#import "THKDynamicTabsManager.h"
#import "THKNavigationBarAvatarViewModel.h"
#import "THKNavigationBarSearchViewModel.h"

#define invoke(method) \
SEL selector = NSSelectorFromString(method); \
IMP imp = [self methodForSelector:selector]; \
void (*func)(id, SEL) = (void *)imp; \
func(self, selector);

@interface THKNavigationBarViewController ()

@property (nonatomic, strong) THKNavigationBar *navBar;

@property (nonatomic, strong) THKDynamicTabsManager *manager;

@end

@implementation THKNavigationBarViewController

- (void)demoaction{
    UIEdgeInsets paddings = UIEdgeInsetsMake(24 + NavigationContentTop, 24 + self.view.tmui_safeAreaInsets.left, 24 +  self.view.tmui_safeAreaInsets.bottom, 24 + self.view.tmui_safeAreaInsets.right);
    
    TMUIFloatLayoutView *layoutView = [[TMUIFloatLayoutView alloc] tmui_initWithSize:TMUIFloatLayoutViewAutomaticalMaximumItemSize];
    layoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
    
    NSArray *btns = @[@"显示/隐藏左边",@"显示/隐藏右边"];
    
    [btns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TMUIButton *btn = [TMUIButton tmui_button];
        btn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        btn.cornerRadius = 8;
        btn.tmui_text = obj;
        btn.tmui_titleColor = UIColorWhite;
        btn.backgroundColor = UIColor.tmui_randomColor;
        btn.tag = idx;
        [btn tmui_addTarget:self action:@selector(btnClick:)];
        [layoutView addSubview:btn];
    }];
    
    layoutView.frame = CGRectMake(paddings.left, paddings.top, CGRectGetWidth(self.view.bounds) - UIEdgeInsetsGetHorizontalValue(paddings), TMUIViewSelfSizingHeight);
    
    [self.view addSubview:layoutView];
}

- (void)btnClick:(UIButton *)btn{
    if (btn.tag == 0) {
//        _navBar.isBackButtonHidden = !_navBar.isBackButtonHidden;
        [_navBar setIsBackButtonHidden:!_navBar.isBackButtonHidden animate:YES];
    }else if (btn.tag == 1) {
//        _navBar.isRightButtonHidden = !_navBar.isRightButtonHidden;
        [_navBar setIsRightButtonHidden:!_navBar.isRightButtonHidden animate:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self demoaction];
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.navBarHidden = YES;
    self.navBar = [[THKNavigationBar alloc] init];
    [self.view addSubview:self.navBar];
//    [self.navBar mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(88);
//    }];
    NSString *method = [NSString stringWithFormat:@"customNavbar%zd",_type];
    invoke(method)
    
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 20)];
    [self.view addSubview:lbl];
    
    NSLog(@"avatarTitleView = %@",self.navBar.avatarTitleView);
    NSLog(@"searchBar = %@",self.navBar.searchBar);
}


- (void)customNavbar1{
    self.navBar.title = @"标题😆";
}

- (void)customNavbar2{
    self.navBar.title = @"标题😆";
    self.navBar.barStyle = THKNavigationBarStyle_Dark;
}

- (void)customNavbar3{
    self.navBar.titleView = [self tabsSliderBar];
}

- (void)customNavbar4{
    THKNavigationBarAvatarViewModel *avatarVM = [[THKNavigationBarAvatarViewModel alloc] init];
    avatarVM.avatarUrl = @"https://pic.to8to.com/user/45/headphoto_172172845.jpg!330.jpg?1646703299";
    avatarVM.nickname = @"43432";
    avatarVM.identificationType = 12;
    avatarVM.subCategory = 0;
    avatarVM.uid = 172172845;
    [self.navBar bindViewModel:avatarVM];
}

- (void)customNavbar5{
    THKNavigationBarSearchViewModel *searchVM = [[THKNavigationBarSearchViewModel alloc] init];
    [self.navBar bindViewModel:searchVM];
}

- (void)customNavbar6{
    THKNavigationBarSearchViewModel *searchVM = [[THKNavigationBarSearchViewModel alloc] init];
    searchVM.barStyle = TMUISearchBarStyle_City;
    [self.navBar bindViewModel:searchVM];
}



/// Tab 组件
- (UIView *)tabsSliderBar{
    UIViewController *vc1 = UIViewController.new;
    vc1.view.backgroundColor = UIColor.tmui_randomColor;
    UIViewController *vc2 = UIViewController.new;
    vc2.view.backgroundColor = UIColor.tmui_randomColor;
    
    THKDynamicTabsViewModel *viewModel = [[THKDynamicTabsViewModel alloc] initWithVCs:@[vc1,vc2] titles:@[@"推荐",@"关注"]];
    viewModel.layout = THKDynamicTabsLayoutType_Custom;
    viewModel.parentVC = self;
    THKDynamicTabsManager *manager = [[THKDynamicTabsManager alloc] initWithViewModel:viewModel];
    [self.view addSubview:manager.view];
    [manager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(tmui_navigationBarHeight(), 0, 0, 0));
    }];
    [manager loadTabs];
    manager.sliderBar.minItemWidth = (TMUI_SCREEN_WIDTH - 54 * 2)/2;
    _manager = manager;
    return manager.sliderBar;
}

@end
