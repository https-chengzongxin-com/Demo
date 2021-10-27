//
//  THKDiaryProducer.m
//  HouseKeeper
//
//  Created by Joe.cheng on 2021/10/26.
//  Copyright © 2021 binxun. All rights reserved.
//

#import "THKDiaryProducer.h"
#import "THKDirDetailDiaryPageRequest.h"
@interface THKDiaryProducer ()

@property (nonatomic, strong) NSString *snapshotId;

@property (nonatomic, assign, readwrite) NSInteger totalCount;

@property (nonatomic, strong) NSArray *loadedArray;

@property (nonatomic, weak) THKBaseRequest *lastRequest;

@end

@implementation THKDiaryProducer


#pragma mark - Lifecycle (dealloc init viewDidLoad memoryWarning...)

#pragma mark - Public

- (void)loadDataWithComplete:(THKDiaryProductComplete)complete failure:(THKDiaryProductFailure)failure{
    THKMapRange range = {0, 10};
    [self datasFromRemote:range idType:THKDiaryProductIdType_offsetId offsetId:1 diaryId:0 stageId:0 complete:complete failure:failure];
}

- (void)loadDataWithDiaryId:(NSInteger)diaryId complete:(THKDiaryProductComplete)complete failure:(THKDiaryProductFailure)failure{
    THKMapRange range = {-10, 10};
    [self datasFromRemote:range idType:THKDiaryProductIdType_diaryId offsetId:0 diaryId:diaryId stageId:0 complete:complete failure:failure];
}

- (void)loadDataWithStageId:(NSInteger)stageId complete:(THKDiaryProductComplete)complete failure:(THKDiaryProductFailure)failure{
    THKMapRange range = {-10, 10};
    [self datasFromRemote:range idType:THKDiaryProductIdType_stageId offsetId:0 diaryId:0 stageId:stageId complete:complete failure:failure];
}

- (void)datasForRange:(THKMapRange)range
               idType:(THKDiaryProductIdType)idType
             offsetId:(NSInteger)offsetId
              diaryId:(NSInteger)diaryId
              stageId:(NSInteger)stageId
             complete:(THKDiaryProductComplete)complete
              failure:(THKDiaryProductFailure)failure{
    
    __block NSInteger desIdx = NSNotFound;
    __block THKDiaryInfoModel *desDiary = nil;
    [self.map enumerateObjectsUsingBlock:^(THKDiaryInfoModel * _Nonnull diary, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idType == THKDiaryProductIdType_offsetId) {
            if (diary.offset == offsetId) {
                desIdx = idx;
                desDiary = diary;
                *stop = YES;
            }
        }else if (idType == THKDiaryProductIdType_diaryId) {
            if (diary.diaryId == diaryId) {
                desIdx = idx;
                desDiary = diary;
                *stop = YES;
            }
        }else if (idType == THKDiaryProductIdType_stageId) {
            if (diary.stageBigId == stageId && diary.showFirstStageName) {
                desIdx = idx;
                desDiary = diary;
                *stop = YES;
            }
        }
    }];
    
    // 找到下标，已在内存中存在
    if (desIdx != NSNotFound) {
        NSInteger from = MAX(0, desIdx - range.left);   // 上标不超出0
        NSInteger to = MIN(self.map.count - from,range.right - range.left); // 下标不超过最大长度
        
        BOOL isExistAllData = YES;
        for (NSInteger i = from + 1; i <= to; i++) {
            if (![self.map[i] isKindOfClass:THKDiaryInfoModel.class]) {
                isExistAllData = NO;
                break;
            }
        }
        
        if (isExistAllData) {
            complete(self.map,THKDiaryProductFromType_Memory);
        }else{
            [self datasFromRemote:range idType:idType offsetId:offsetId diaryId:diaryId stageId:stageId complete:complete failure:failure];
        }
        
    }else{
        // 未找到下标，从网络获取
        [self datasFromRemote:range idType:idType offsetId:offsetId diaryId:diaryId stageId:stageId complete:complete failure:failure];
    }
}

- (THKBaseRequest *)datasFromRemote:(THKMapRange)range
                             idType:(THKDiaryProductIdType)idType
                           offsetId:(NSInteger)offsetId
                            diaryId:(NSInteger)diaryId
                            stageId:(NSInteger)stageId
                           complete:(THKDiaryProductComplete)complete
                            failure:(THKDiaryProductFailure)failure{
    // 发起网络请求
    THKDirDetailDiaryPageRequest *request = [[THKDirDetailDiaryPageRequest alloc] init];
    request.diaryBookId = self.diaryBookId;
    request.snapshotId = self.snapshotId;
    if (idType == THKDiaryProductIdType_offsetId) {
        request.offset = @(offsetId).stringValue;
    }else if (idType == THKDiaryProductIdType_diaryId) {
        request.diaryId = @(diaryId).stringValue;
    }else if (idType == THKDiaryProductIdType_stageId) {
        request.firstStageId = @(stageId).stringValue;
    }
    request.range = @[@(range.left),@(range.right)];
    
    @weakify(self);
    [request.rac_requestSignal subscribeNext:^(THKDirDetailDiaryPageResponse *response) {
        @strongify(self);
        if (response.status == THKStatusSuccess) {
            self.totalCount = response.data.total;
            self.snapshotId = response.data.snapshotId;
            NSArray *diaryList = response.data.diaryInfos;
            [self saveMapWithDatas:diaryList];
            !complete?:complete(self.map,THKDiaryProductFromType_Remote);
        }else{
            !failure?:failure([NSError errorWithDomain:@"" code:0 userInfo:nil]);
        }
    } error:^(NSError * _Nullable error) {
        !failure?:failure(error);
    }];
    
    return request;
}

- (void)saveMapWithDatas:(NSArray <THKDiaryInfoModel *>*)datas{
    NSMutableArray *array =  [self.map mutableCopy];
    [datas enumerateObjectsUsingBlock:^(THKDiaryInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        array[obj.offset] = obj;
    }];
    self.map = [array copy];
}


// 上下滑动
- (void)preLoadData:(NSInteger)idx isDown:(BOOL)isDown{
    if (self.totalCount == 0 || self.map.count == 0) {
        return;
    }
    if (self.lastRequest.isExecuting) {
        return;
    }
    
    if (isDown) {
        if (idx + 1 < self.totalCount) {
            if (self.map[idx+1].diaryId) {
                return;
            }
        }
    }else{
        if (idx - 1 >= 0) {
            if (self.map[idx-1].diaryId) {
                return;
            }
        }
    }
    
    THKMapRange range = {0,0};
    if (isDown) {
        range.left = 0;
        range.right = 10;
    }else{
        range.left = -10;
        range.right = 0;
    }
    
    NSInteger offsetId = self.map[idx].offset;
    
    self.lastRequest = [self datasFromRemote:range
                                      idType:THKDiaryProductIdType_offsetId
                                    offsetId:offsetId
                                     diaryId:0
                                     stageId:0
                                    complete:nil
                                     failure:nil];
}


#pragma mark - Event Respone

#pragma mark - Delegate

#pragma mark - Private

#pragma mark - Getters and Setters
- (void)setTotalCount:(NSInteger)totalCount{
    _totalCount = totalCount;
    
    if (self.map) {
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < totalCount; i++) {
        [array addObject:THKDiaryInfoModel.new];
    }
    self.map = [array copy];
}

- (void)setSnapshotId:(NSString *)snapshotId{
    if (_snapshotId == nil) {
        _snapshotId = snapshotId;
    }
}


#pragma mark - Supperclass

#pragma mark - NSObject



@end
