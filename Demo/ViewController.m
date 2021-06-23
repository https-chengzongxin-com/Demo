//
//  ViewController.m
//  THKAuthenticationViewDemo
//
//  Created by Joe.cheng on 2021/1/19.
//

#import "ViewController.h"
#import "THKMaterialClassificationVC.h"
#import "THKMaterialHotRankVC.h"
#import "THKMaterialHotListRequest.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Button.str(@"如何选材").bgColor(@"random").xywh(100,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        [self.navigationController pushViewController:THKMaterialClassificationVC.new animated:YES];
    });
    
    Button.str(@"热门排行榜").bgColor(@"random").xywh(250,100,100,100).addTo(self.view).onClick(^{
        Log(@"123123");
        [self.navigationController pushViewController:THKMaterialHotRankVC.new animated:YES];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    THKMaterialHotListRequest *request = [[THKMaterialHotListRequest alloc] init];
    [request.rac_requestSignal subscribeNext:^(id  _Nullable x) {
        Log(x);
    } error:^(NSError * _Nullable error) {
        Log(error);
    } completed:^{
        Log(@"complete");
    }];
}

@end
