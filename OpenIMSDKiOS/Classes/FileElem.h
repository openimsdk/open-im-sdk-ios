//
//  FileElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface FileElem : BaseModal

/**
 * 文件本地资源地址
 */
@property(nullable) NSString *filePath;
/**
 *
 */
@property(nullable) NSString *uuID;
/**
 * oss地址
 */
@property(nullable) NSString *sourceUrl;
/**
 * 文件名称
 */
@property(nullable) NSString *fileName;
/**
 * 文件大小
 */
@property long fileSize;

@end

NS_ASSUME_NONNULL_END
