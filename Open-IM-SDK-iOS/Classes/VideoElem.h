//
//  VideoElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoElem : BaseModal

/**
 * 视频本地资源地址
 */
@property(nullable) NSString *videoPath;
/**
 * 视频唯一ID
 */
@property(nullable) NSString *videoUUID;
/**
 * 视频oss地址
 */
@property(nullable) NSString *videoUrl;
/**
 * 视频类型
 */
@property(nullable) NSString *videoType;
/**
 * 视频大小
 */
@property long videoSize;
/**
 * 视频时长
 */
@property long duration;
/**
 * 视频快照本地地址
 */
@property(nullable) NSString *snapshotPath;
/**
 * 视频快照唯一ID
 */
@property(nullable) NSString *snapshotUUID;
/**
 * 视频快照大小
 */
@property long snapshotSize;
/**
 * 视频快照oss地址
 */
@property(nullable) NSString *snapshotUrl;
/**
 * 视频快照宽度
 */
@property int snapshotWidth;
/**
 * 视频快照高度
 */
@property int snapshotHeight;

@end

NS_ASSUME_NONNULL_END
