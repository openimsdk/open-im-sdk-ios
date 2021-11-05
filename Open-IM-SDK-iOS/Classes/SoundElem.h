//
//  SoundElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SoundElem : BaseModal

/**
 * 唯一ID
 */
@property(nullable) NSString *uuID;
/**
 * 本地资源地址
 */
@property(nullable) NSString *soundPath;
/**
 * oss地址
 */
@property(nullable) NSString *sourceUrl;
/**
 * 音频大小
 */
@property long dataSize;
/**
 * 音频时长
 */
@property long duration;

@end

NS_ASSUME_NONNULL_END
