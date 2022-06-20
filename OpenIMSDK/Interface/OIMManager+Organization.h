//
//  OIMManager+Organization.h
//  OpenIMSDK
//
//  Created by x on 2022/5/13.
//

#import "OIMManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMManager (Organization)


// 获取子部门列表
- (void)getSubDepartment:(NSString *)departmentID
                  offset:(NSInteger)offset
                   count:(NSInteger)count
               onSuccess:(nullable OIMDepartmentInfoCallback)onSuccess
               onFailure:(nullable OIMFailureCallback)onFailure;
    
// 获取父部门列表
- (void)getParentDepartment:(NSString *)departmentID
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(nullable OIMDepartmentInfoCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;

// 获取部门成员信息
- (void)getDepartmentMember:(NSString *)departmentID
                     offset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(nullable OIMDepartmentMembersInfoCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;


// 获取用户在所有部门信息
- (void)getUserInDepartment:(NSString *)userID
                  onSuccess:(nullable OIMUserInDepartmentInfoCallback)onSuccess
                  onFailure:(nullable OIMFailureCallback)onFailure;

// 获取子部门信息和部门成员信息
- (void)getDepartmentMemberAndSubDepartment:(NSString *)departmentID
                                  onSuccess:(nullable OIMDepartmentMemberAndSubInfoCallback)onSuccess
                                  onFailure:(nullable OIMFailureCallback)onFailure;
// 获取部门信息
- (void)getDepartmentInfo:(NSString *)departmentID
                onSuccess:(nullable OIMDepartmentInfoCallback)onSuccess
                onFailure:(nullable OIMFailureCallback)onFailure;

// 搜索
- (void)searchOrganization:(OIMSearchOrganizationParam *)param
                    offset:(NSInteger)offset
                     count:(NSInteger)count
                 onSuccess:(nullable OIMDepartmentMemberAndSubInfoCallback)onSuccess
                 onFailure:(nullable OIMFailureCallback)onFailure;
@end

NS_ASSUME_NONNULL_END
