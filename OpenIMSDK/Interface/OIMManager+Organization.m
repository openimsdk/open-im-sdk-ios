//
//  OIMManager+Organization.m
//  OpenIMSDK
//
//  Created by x on 2022/5/13.
//

#import "OIMManager+Organization.h"
#import "CallbackProxy.h"

@implementation OIMManager (Department)

// 获取子部门列表
- (void)getSubDepartment:(NSString *)departmentID
                  offset:(NSInteger)offset
                   count:(NSInteger)count
               onSuccess:(nullable OIMDepartmentInfoCallback)onSuccess
               onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMDepartmentInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetSubDepartment(callback, [self operationId], departmentID, offset, count);
}

// 获取部门成员信息
- (void)getDepartmentMember:(NSString *)departmentID
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(nullable OIMDepartmentMembersInfoCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMDepartmentMemberInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetDepartmentMember(callback, [self operationId], departmentID, offset, count);
}


// 获取用户在所有部门信息
- (void)getUserInDepartment:(NSString *)userID
                  onSuccess:(nullable OIMUserInDepartmentInfoCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMUserInDepartmentInfo mj_objectArrayWithKeyValuesArray:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetUserInDepartment(callback, [self operationId], userID);
}

// 获取子部门信息和部门成员信息
- (void)getDepartmentMemberAndSubDepartment:(NSString *)departmentID
                           departmentOffset:(NSInteger)departmentOffset
                            departmentCount:(NSInteger)departmentCount
                               memberOffset:(NSInteger)memberOffset
                                memberCount:(NSInteger)memberCount
                                  onSuccess:(nullable OIMDepartmentMemberAndSubInfoCallback)onSuccess
                                  onFailure:(nullable OIMFailureCallback)onFailure {
    CallbackProxy *callback = [[CallbackProxy alloc]initWithOnSuccess:^(NSString * _Nullable data) {
        if (onSuccess) {
            onSuccess([OIMDepartmentMemberAndSubInfo mj_objectWithKeyValues:data]);
        }
    } onFailure:onFailure];
    
    Open_im_sdkGetDepartmentMemberAndSubDepartment(callback, [self operationId], departmentID, departmentOffset, departmentCount, memberOffset, memberCount);
}

@end
