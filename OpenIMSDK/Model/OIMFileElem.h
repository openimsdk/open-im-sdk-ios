//
//  OIMFileElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMFileElem : NSObject

/*
 * 文件本地资源地址
 */
@property (nonatomic, nullable, copy) NSString *filePath;

/*
 *
 */
@property (nonatomic, nullable, copy) NSString *uuID;

/*
 * oss地址
 */
@property (nonatomic, nullable, copy) NSString *sourceUrl;

/*
 * 文件名称
 */
@property (nonatomic, nullable, copy) NSString *fileName;

/*
 * 文件大小
 */
@property (nonatomic, assign) NSInteger fileSize;

@end

NS_ASSUME_NONNULL_END
