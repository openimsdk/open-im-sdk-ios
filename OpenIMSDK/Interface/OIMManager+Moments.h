//
//  OIMManager+Moments.h
//  OpenIMSDK
//
//  Created by x on 2022/6/30.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Moments)

// 获取未读数
- (void)getWorkMomentsUnReadCountWithOnSuccess:(nullable OIMNumberCallback)onSuccess
                                     onFailure:(nullable OIMFailureCallback)onFailure;


// 获取朋友圈通知列表
- (void)getWorkMomentsNotificationWithOffset:(NSInteger)offset  // 开始下标
                                       count:(NSInteger)count   // 每页大小
                                   onSuccess:(nullable OIMMomentsInfoCallback)onSuccess
                                   onFailure:(nullable OIMFailureCallback)onFailure;

// 清除朋友圈通知列表
- (void)clearWorkMomentsNotificationWithOnSuccess:(nullable OIMSuccessCallback)onSuccess
                                        onFailure:(nullable OIMFailureCallback)onFailure;

@end

NS_ASSUME_NONNULL_END
