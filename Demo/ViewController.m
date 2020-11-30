//
//  ViewController.m
//  Demo
//
//  Created by Joe.cheng on 2020/11/27.
//

#import "ViewController.h"
#import "Table1ViewController.h"
#import "Table2ViewController.h"
#import "Table3ViewController.h"
#import "NormalViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray<__kindof UIViewController *> *)childViewControllers{
    NSArray *vcClass = @[Table1ViewController.class,
                         Table2ViewController.class,
                         Table3ViewController.class,
                         NormalViewController.class];
    
    NSArray *vcArray = [[vcClass.rac_sequence map:^id _Nullable(Class cls) {
        UIViewController *vc = [[cls alloc] init];
//        vc.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        return vc;
    }] array];
    
    return vcArray;
}

- (NSArray<NSString *> *)titlesForChildViewControllers{
    return @[@"热门",@"最新",@"涉及",@"案例"];
}

- (CGFloat)heightForHeader{
    return 100;
}

- (UIView *)viewForHeader{
    UIView *view = UIView.new;
    view.backgroundColor = UIColor.orangeColor;
    return view;
}

@end
