//
//  OIMFileElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMFileElem : NSObject

/**
 * Local resource address of the file
 */
@property (nonatomic, nullable, copy) NSString *filePath;

/**
 * UUID
 */
@property (nonatomic, nullable, copy) NSString *uuID;

/**
 * OSS address
 */
@property (nonatomic, nullable, copy) NSString *sourceUrl;

/**
 * File name
 */
@property (nonatomic, nullable, copy) NSString *fileName;

/**
 * File size
 */
@property (nonatomic, assign) NSInteger fileSize;

@end

NS_ASSUME_NONNULL_END
