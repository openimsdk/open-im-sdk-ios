//
//  OIMSoundElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMSoundElem : NSObject
/**
 * Unique ID
 */
@property (nonatomic, nullable, copy) NSString *uuID;
/**
 * Local resource path
 */
@property (nonatomic, nullable, copy) NSString *soundPath;
/**
 * OSS (Object Storage Service) address
 */
@property (nonatomic, nullable, copy) NSString *sourceUrl;
/**
 * Audio size
 */
@property (nonatomic, assign) NSInteger dataSize;
/**
 * Audio duration
 */
@property (nonatomic, assign) NSInteger duration;

@end

NS_ASSUME_NONNULL_END
