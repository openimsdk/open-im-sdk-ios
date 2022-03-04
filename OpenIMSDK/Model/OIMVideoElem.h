//
//  OIMVideoElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMVideoElem : NSObject

/*
 * 视频本地资源地址
 */
@property (nonatomic, nullable, copy) NSString *videoPath;

/*
 * 视频唯一ID
 */
@property (nonatomic, nullable, copy) NSString *videoUUID;

/*
 * 视频oss地址
 */
@property (nonatomic, nullable, copy) NSString *videoUrl;

/*
 * 视频类型
 */
@property (nonatomic, nullable, copy) NSString *videoType;

/*
 * 视频大小
 */
@property (nonatomic, assign) NSInteger videoSize;

/*
 * 视频时长
 */
@property (nonatomic, assign) NSInteger duration;

/*
 * 视频快照本地地址
 */
@property (nonatomic, nullable, copy) NSString *snapshotPath;

/*
 * 视频快照唯一ID
 */
@property (nonatomic, nullable, copy) NSString *snapshotUUID;

/*
 * 视频快照大小
 */
@property (nonatomic, assign) NSInteger snapshotSize;

/*
 * 视频快照oss地址
 */
@property (nonatomic, nullable, copy) NSString *snapshotUrl;

/*
 * 视频快照宽度
 */
@property (nonatomic, assign) CGFloat snapshotWidth;

/*
 * 视频快照高度
 */
@property (nonatomic, assign) CGFloat snapshotHeight;

@end

NS_ASSUME_NONNULL_END
