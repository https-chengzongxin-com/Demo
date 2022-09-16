//
//  THKMyHomeDesignDemandsVM.m
//  Demo
//
//  Created by Joe.cheng on 2022/9/15.
//

#import "THKMyHomeDesignDemandsVM.h"
#import "THKHouseCardConfigRequest.h"
#import "THKHomeQueryCardRequest.h"
#import "THKHomeEditCardRequest.h"

@interface THKMyHomeDesignDemandsVM ()

@property (nonatomic, strong) THKRequestCommand *configCommand;

@property (nonatomic, strong) THKRequestCommand *queryCommand;

@property (nonatomic, strong) THKRequestCommand *editCommand;

@property (nonatomic, strong) RACCommand *editCellCommand;

@property (nonatomic, strong) NSArray <THKMyHomeDesignDemandsModel *> *cellModels;

//
//
#pragma mark - 接口
@property (nonatomic, strong) THKHomeEditCardRequest *dataRequest;

////房屋面积
//@property (nonatomic, assign) NSInteger area;
//
////装修预算全码
//@property (nonatomic, strong) NSString *budgetTag;
//
////小区名称
//@property (nonatomic, strong) NSString *communityName;
//
////装修方式
//@property (nonatomic, strong) NSString *decorateType;
//
////房屋户型全码
//@property (nonatomic, strong) NSString *houseTag;
//
////居住人口
//@property (nonatomic, assign) NSInteger populationType;
//
////特殊需求
//@property (nonatomic, strong) NSString *requirementDesc;
//
////装修风格全码
//@property (nonatomic, strong) NSString *styleTag;


@end


@implementation THKMyHomeDesignDemandsVM

- (void)initialize{
    [super initialize];
    
    @weakify(self);
    [[RACSignal combineLatest:@[self.configCommand.nextSignal,self.queryCommand.nextSignal] reduce:^id _Nullable(THKHouseCardConfigResponse *res1,THKHomeQueryCardResponse *res2){
        @strongify(self);
        return [self handResponse1:res1 response2:res2];
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.cellModels = x;
    }];
    
    [self.configCommand execute:nil];
    [self.queryCommand execute:nil];
}


#pragma mark - 处理接口回调
- (NSArray *)handResponse1:(THKHouseCardConfigResponse *)response1 response2:(THKHomeQueryCardResponse *)response2 {
    NSMutableArray *arr = [NSMutableArray array];
    
    if (response1.status != THKStatusSuccess) {
        return nil;
    }
    
    THKHouseCardConfigModel *data1 = response1.data;
    THKHomeQueryCardModel *data2 = response2.data;
    
    {
        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
        m.type = THKMyHomeDesignDemandsModelType_HouseType;
        m.title = @"房屋信息";
        m.content = data2.communityName;
        m.contentDesc = [NSString stringWithFormat:@"%@·%@",data2.houseTagName,data2.areaStr];
        self.dataRequest.communityName = data2.communityName;
        self.dataRequest.houseTag = data2.houseTag;
        self.dataRequest.area = data2.areaStr.integerValue;
        [arr addObject:m];
    }
    
//    {
//        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
//        m.type = THKMyHomeDesignDemandsModelType_HouseArea;
//        m.title = @"房屋面积";
//        m.content = data2.areaStr;
//        self.dataRequest.area = data2.areaStr.integerValue;
//        [arr addObject:m];
//    }
//
//    if (data1.houseList.count) {
//        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
//        m.type = THKMyHomeDesignDemandsModelType_HouseType;
//        m.title = @"房屋户型";
//        m.content = data2.houseTagName;
//        self.dataRequest.houseTag = data2.houseTag;
//        [arr addObject:m];
//    }
    
    
    if (data1.styleList.count) {
        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
        m.type = THKMyHomeDesignDemandsModelType_Style;
        m.title = @"装修风格";
        m.content = data2.styleTagName;
        self.dataRequest.styleTag = data2.styleTag;
        [arr addObject:m];
    }
    
    if (data1.budgetList.count) {
        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
        m.type = THKMyHomeDesignDemandsModelType_Budget;
        m.title = @"装修预算";
        m.content = data2.budgetTagName;
        self.dataRequest.budgetTag = data2.budgetTag;
        [arr addObject:m];
    }
    
    
    if (data1.decorateTypeList.count) {
        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
        m.type = THKMyHomeDesignDemandsModelType_Decorate;
        m.title = @"装修方式";
        m.content = data2.decorateTypeName;
        self.dataRequest.decorateType = data2.decorateType;
        [arr addObject:m];
    }
    
    
    if (data1.populationTypeList.count) {
        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
        m.type = THKMyHomeDesignDemandsModelType_Population;
        m.title = @"居住人口";
        m.content = data2.populationTypeName;
        self.dataRequest.populationType = data2.populationType;
        [arr addObject:m];
    }
    
    {
        THKMyHomeDesignDemandsModel *m = [THKMyHomeDesignDemandsModel new];
        m.type = THKMyHomeDesignDemandsModelType_SpecialDemand;
        m.title = @"特殊需求";
        m.content = data2.requirementDesc;
        self.dataRequest.requirementDesc = data2.requirementDesc;
        [arr addObject:m];
    }
    
    return arr;
}


- (THKRequestCommand *)configCommand{
    if (!_configCommand) {
        _configCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKHouseCardConfigRequest new];
        }];
    }
    return _configCommand;
}

- (THKRequestCommand *)queryCommand{
    if (!_queryCommand) {
        _queryCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            return [THKHomeQueryCardRequest new];
        }];
    }
    return _queryCommand;
}

- (THKRequestCommand *)editCommand{
    if (!_editCommand) {
        @weakify(self);
        _editCommand = [THKRequestCommand commandMakeWithRequest:^THKBaseRequest *(id  _Nonnull input) {
            @strongify(self);
            return self.dataRequest;
        }];
    }
    return _editCommand;
}

TMUI_PropertyLazyLoad(THKHomeEditCardRequest, dataRequest);


@end
