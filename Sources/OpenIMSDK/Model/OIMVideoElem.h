//
//  OIMVideoElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMVideoElem : NSObject
/**
 * Local video resource path
 */
@property (nonatomic, nullable, copy) NSString *videoPath;
/**
 * Unique ID of the video
 */
@property (nonatomic, nullable, copy) NSString *videoUUID;
/**
 * Video OSS (Object Storage Service) address
 */
@property (nonatomic, nullable, copy) NSString *videoUrl;
/**
 * Video type
 */
@property (nonatomic, nullable, copy) NSString *videoType;
/**
 * Video size
 */
@property (nonatomic, assign) NSInteger videoSize;
/**
 * Video duration
 */
@property (nonatomic, assign) NSInteger duration;
/**
 * Local snapshot (thumbnail) path of the video
 */
@property (nonatomic, nullable, copy) NSString *snapshotPath;
/**
 * Unique ID of the video snapshot
 */
@property (nonatomic, nullable, copy) NSString *snapshotUUID;
/**
 * Snapshot size
 */
@property (nonatomic, assign) NSInteger snapshotSize;
/**
 * Snapshot OSS address
 */
@property (nonatomic, nullable, copy) NSString *snapshotUrl;
/**
 * Snapshot width
 */
@property (nonatomic, assign) CGFloat snapshotWidth;
/**
 * Snapshot height
 */
@property (nonatomic, assign) CGFloat snapshotHeight;

@end

NS_ASSUME_NONNULL_END
