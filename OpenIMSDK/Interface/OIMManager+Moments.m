//
//  OIMManager+Moments.m
//  OpenIMSDK
//
//  Created by x on 2022/6/30.
//

#import "OIMManager+Moments.h"
#import "CallbackProxy.h"

@implementation OIMManager (Moments)

- (void)getWorkMomentsUnReadCountWithOnSuccess:(OIMNumberCallback)onSuccess
                                     onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess(data.integerValue);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetWorkMomentsUnReadCount(callback, [self operationId]);
}

- (void)getWorkMomentsNotificationWithOffset:(NSInteger)offset
                                       count:(NSInteger)count
                                   onSuccess:(OIMMomentsInfoCallback)onSuccess
                                   onFailure:(OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMMomentsInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetWorkMomentsNotification(callback, [self operationId], offset, count);
}

- (void)clearWorkMomentsNotificationWithOnSuccess:(OIMSuccessCallback)onSuccess
                                        onFailure:(OIMFailureCallback)onFailure {
    
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:onSuccess onFailure:onFailure];
    
    Open_im_sdkClearWorkMomentsNotification(callback, [self operationId]);
}
@end
