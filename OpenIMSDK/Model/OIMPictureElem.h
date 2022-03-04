//
//  OIMPictureElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import <Foundation/Foundation.h>
#import "OIMPictureInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMPictureElem : NSObject

/*
 * 本地资源地址
 */
@property (nonatomic, nullable, copy) NSString *sourcePath;

/*
 * 本地图片详情
 */
@property (nonatomic, nullable, strong) OIMPictureInfo *sourcePicture;

/*
 * 大图详情
 */
@property (nonatomic, nullable, strong) OIMPictureInfo *bigPicture;

/*
 * 缩略图详情
 */
@property (nonatomic, nullable, strong) OIMPictureInfo *snapshotPicture;

@end

NS_ASSUME_NONNULL_END
