//
//  OIMDepartmentInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMDepartmentMemberInfo : NSObject

@property (nonatomic, copy)   NSString *userID;
@property (nonatomic, copy)   NSString *nickname;
@property (nonatomic, copy)   NSString *englishName;
@property (nonatomic, copy)   NSString *faceURL;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, copy)   NSString *mobile;
@property (nonatomic, copy)   NSString *telephone;
@property (nonatomic, assign) NSInteger birth;
@property (nonatomic, copy)   NSString *email;
@property (nonatomic, copy)   NSString *departmentID;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, copy)   NSString *position;
@property (nonatomic, assign) NSInteger leader;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, copy)   NSString *ex;
@property (nonatomic, copy)   NSString *attachedInfo;

@end

@interface OIMDepartmentInfo : NSObject

@property (nonatomic, copy)   NSString *departmentID;
@property (nonatomic, copy)   NSString *faceURL;
@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *parentID;
@property (nonatomic, assign) NSInteger order;
@property (nonatomic, assign) NSInteger departmentType;
@property (nonatomic, assign) NSTimeInterval createTime;
@property (nonatomic, assign) NSInteger subDepartmentNum;
@property (nonatomic, assign) NSInteger memberNum;
@property (nonatomic, copy)   NSString *ex;
@property (nonatomic, copy)   NSString *attachedInfo;

@end

@interface OIMUserInDepartmentInfo : NSObject

@property (nonatomic, strong) OIMDepartmentMemberInfo *member;
@property (nonatomic, strong) OIMDepartmentInfo *department;

@end

@interface OIMDepartmentMemberAndSubInfo : NSObject

@property (nonatomic, strong) NSArray<OIMDepartmentInfo*> *departmentList;
@property (nonatomic, strong) NSArray<OIMDepartmentMemberInfo*> *departmentMemberList;

@end

NS_ASSUME_NONNULL_END
