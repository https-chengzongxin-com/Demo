//
//  THKExpandLabelViewController.m
//  Demo
//
//  Created by Joe.cheng on 2021/12/27.
//

#import "THKExpandLabelViewController.h"
#import "THKExpandLabel.h"
#import "TMUIExpandLabel.h"
//#import "UILabel+Expand.h"

@interface TMUIExpandCell : UITableViewCell

@property (nonatomic, strong) TMUIExpandLabel *label;
@end

@implementation TMUIExpandCell
- (NSString *)contentStr {
    NSString *str = @"\
Demo开发版base\n\
土巴兔项目独立工程，抽离了部分组件，可用于快速迭代开发使用，可配合Injection进行热部署进一步提高效率\n\
包含：\n\
THKBaseNetwork\n\
TRouter\n\
TMUIKit\n\
TMCardComponent\n\
THKDynamicTabsManager\n\
THKIdentityView\n\
包含TBTBaseNetwork库快速开发接口、\n\
TMUIKit库搭建页面\n\
THKDynamicTabsManager\n\
TMCardComponent瀑布流快速开\n\
";
    return str;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        TMUIExpandLabel *label = [[TMUIExpandLabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.mas_equalTo(20).priorityLow();
        }];
        label.maxLine = 3;
        label.maxPreferWidth = TMUI_SCREEN_WIDTH - 20 * 2;
        
        self.label = label;
    }
    return self;
}

@end

@interface THKExpandAdpater : NSObject

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSInteger maxLine;

@end

@implementation THKExpandAdpater

@end

@interface THKExpandLabelViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray <THKExpandAdpater *>* adapter;

@end

@implementation THKExpandLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    _adapter = [NSMutableArray array];
    for (int i = 0; i< 10; i++) {
        THKExpandAdpater *a = [THKExpandAdpater new];
        a.cellHeight = 144;
        a.maxLine = 3;
        [_adapter addObject:a];
    }
    
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.adapter.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMUIExpandCell *cell = (TMUIExpandCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass(TMUIExpandCell.class) forIndexPath:indexPath];
    
    THKExpandAdpater *a = _adapter[indexPath.row];
    cell.label.maxLine = a.maxLine;
    
    NSString *str = [self contentStr];
    NSMutableAttributedString *attr = [NSMutableAttributedString tmui_attributedStringWithString:str font:UIFont(18) color:UIColor.tmui_randomColor lineSpacing:20];
    cell.label.attributeString = attr;
    
    @weakify(cell);
    cell.label.clickActionBlock = ^(TMUIExpandLabelClickActionType clickType) {
        @strongify(cell);
        NSLog(@"%lu",(unsigned long)clickType);
        
        cell.label.sizeChangeBlock = ^(CGSize size) {
            NSLog(@"%@",NSStringFromCGSize(size));
            if (@available(iOS 11.0, *)) {
                [tableView performBatchUpdates:^{
                    a.cellHeight = size.height;
                } completion:^(BOOL finished) {
                    
                }];
            } else {
                // Fallback on earlier versions
            }
        };
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.adapter[indexPath.row].cellHeight;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionHeaderHeight = 0.0;
        _tableView.sectionFooterHeight = 0.0;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedRowHeight = UITableViewAutomaticDimension;
        [_tableView registerClass:TMUIExpandCell.class forCellReuseIdentifier:NSStringFromClass(TMUIExpandCell.class)];
    }
    return _tableView;
}

- (void)test3{
    TMUIExpandLabel *label = [[TMUIExpandLabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).insets(NavigationContentTop + 20);
        make.left.right.equalTo(self.view).insets(40);
    }];
    
    NSString *str = [self contentStr];// [NSString tmui_random:300];
    NSMutableAttributedString *attr = [NSMutableAttributedString tmui_attributedStringWithString:str font:UIFont(18) color:UIColor.tmui_randomColor lineSpacing:20];
    label.maxLine = 3;
    label.attributedText = attr;
    
    label.clickActionBlock = ^(TMUIExpandLabelClickActionType clickType) {
        NSLog(@"%lu",(unsigned long)clickType);
    };
    label.sizeChangeBlock = ^(CGSize size) {
        NSLog(@"%@",NSStringFromCGSize(size));
    };
}

- (void)test2{
    UILabel *label = [[UILabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).insets(NavigationContentTop + 20);
        make.left.right.equalTo(self.view).insets(20);
    }];
//    label.text = @"fdsjkfhdsjko fdhos fasjfksdflfdsa fdslk fjkdsf dsghf kdsj fksdfj sdfsdhkf dshf kdshjf kjhds fkhgs jfhds jfhg sdfsdfas";
    NSMutableAttributedString *attr = [NSMutableAttributedString tmui_attributedStringWithString:[self contentStr] font:UIFont(18) color:UIColor.tmui_randomColor lineSpacing:20];
//    label.expandString = attr;
    label.attributedText = attr;
    label.numberOfLines = 5;
    label.showsExpansionTextWhenTruncated = YES;
    
    @weakify(label);
    [label tmui_addSingerTapWithBlock:^{
        @strongify(label);
        NSMutableAttributedString *attr = [NSMutableAttributedString tmui_attributedStringWithString:[self contentStr] font:UIFont(16) color:UIColor.tmui_randomColor lineSpacing:20];
        label.attributedText = attr;
    }];
}



- (void)test1{
    
    THKExpandLabel *label = [[THKExpandLabel alloc] init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).insets(NavigationContentTop + 20);
        make.left.right.equalTo(self.view).insets(20);
    }];
    
    
    NSString *tag = @"#123入住新家#  ";
    NSString *str = [self contentStr];
    
//    THKExpandLabel *label = THKExpandLabel.new;
    
    label.numberOfLines = 8;
    label.lineGap = 6;
    label.maxWidth = TMUI_SCREEN_WIDTH - 100;
    label.preferFont = UIFont(16);
    
    @weakify(label);
    label.unfoldClick = ^{
        @strongify(label);
        NSLog(@"%@",label.text);
    };
    
    [label setTagStr:tag
         tagAttrDict:@{NSForegroundColorAttributeName:THKColor_999999,NSFontAttributeName:UIFontMedium(16)}
          contentStr:str
     contentAttrDict:@{NSForegroundColorAttributeName:UIColorHex(#1A1C1A),NSFontAttributeName:UIFont(16)}];
}

- (NSString *)contentStr {
    NSString *str = @"\
Demo开发版base\n\
土巴兔项目独立工程，抽离了部分组件，可用于快速迭代开发使用，可配合Injection进行热部署进一步提高效率\n\
包含：\n\
THKBaseNetwork\n\
TRouter\n\
TMUIKit\n\
TMCardComponent\n\
THKDynamicTabsManager\n\
THKIdentityView\n\
包含TBTBaseNetwork库快速开发接口、\n\
TMUIKit库搭建页面\n\
THKDynamicTabsManager\n\
TMCardComponent瀑布流快速开\n\
";
    return str;
}


@end
