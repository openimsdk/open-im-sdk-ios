//
//  PictureElem.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
#import "PictureInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureElem : BaseModal

/**
 * 本地资源地址
 */
@property(nullable) NSString *sourcePath;
/**
 * 本地图片详情
 */
@property(nullable) PictureInfo *sourcePicture;
/**
 * 大图详情
 */
@property(nullable) PictureInfo *bigPicture;
/**
 * 缩略图详情
 */
@property(nullable) PictureInfo *snapshotPicture;

@end

NS_ASSUME_NONNULL_END
