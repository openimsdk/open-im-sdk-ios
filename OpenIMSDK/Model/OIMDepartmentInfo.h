//
//  OIMDepartmentInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 部门信息
///
@interface OIMDepartmentInfo : NSObject

@property (nonatomic, copy)   NSString *departmentID;
@property (nonatomic, copy)   NSString *faceURL;
@property (nonatomic, copy)   NSString *name;
/// 上一级部门id
@property (nonatomic, copy)   NSString *parentID;
@property (nonatomic, assign) NSInteger order;
/// 部门类型
@property (nonatomic, assign) NSInteger departmentType;
@property (nonatomic, assign) NSTimeInterval createTime;
/// 子部门数量
@property (nonatomic, assign) NSInteger subDepartmentNum;
/// 成员数量
@property (nonatomic, assign) NSInteger memberNum;
@property (nonatomic, copy)   NSString *ex;
/// 附加信息
@property (nonatomic, copy)   NSString *attachedInfo;

@end

/// 部门成员信息
///
@interface OIMDepartmentMemberInfo : NSObject

@property (nonatomic, copy)   NSString *userID;
@property (nonatomic, copy)   NSString *nickname;
@property (nonatomic, copy)   NSString *englishName;
@property (nonatomic, copy)   NSString *faceURL;
@property (nonatomic, assign) NSInteger gender;
/// 手机号
@property (nonatomic, copy)   NSString *mobile;
/// 座机
@property (nonatomic, copy)   NSString *telephone;
@property (nonatomic, assign) NSInteger birth;
@property (nonatomic, copy)   NSString *email;
/// 所在部门的id
@property (nonatomic, copy)   NSString *departmentID;
/// 排序方式
@property (nonatomic, assign) NSInteger order;
/// 职位
@property (nonatomic, copy)   NSString *position;
/// 是否是领导
@property (nonatomic, assign) NSInteger leader;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, copy)   NSString *ex;
/// 附加信息
@property (nonatomic, copy) NSString *attachedInfo;
/// 搜索时使用
@property (nonatomic, copy) NSString *departmentName;
/// 所在部门的所有上级部门
@property (nonatomic, copy) NSArray<OIMDepartmentInfo *> *parentDepartmentList;

@end

/// 用户所在的部门
///
@interface OIMUserInDepartmentInfo : NSObject

@property (nonatomic, strong) OIMDepartmentMemberInfo *member;
@property (nonatomic, strong) OIMDepartmentInfo *department;

@end

/// 部门下的子部门跟员工
///
@interface OIMDepartmentMemberAndSubInfo : NSObject

/// 一级子部门
@property (nonatomic, copy) NSArray<OIMDepartmentInfo *> *departmentList;
/// 一级成员
@property (nonatomic, copy) NSArray<OIMDepartmentMemberInfo *> *departmentMemberList;

/// 当前部门的所有上一级部门
@property (nonatomic, copy) NSArray<OIMDepartmentInfo *> *parentDepartmentList;
@end

NS_ASSUME_NONNULL_END
