//
//  OIMPictureElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMPictureInfo : NSObject

/*
 * 唯一ID，可不设置
 */
@property (nonatomic, nullable, copy) NSString *uuID;

/*
 * 图片类型, 可不设置
 */
@property (nonatomic, nullable, copy) NSString *type;

/*
 * 图片大小
 */
@property (nonatomic, assign) NSInteger size;

/*
 * 图片宽度
 */
@property (nonatomic, assign) CGFloat width;

/*
 * 图片高度
 */
@property (nonatomic, assign) CGFloat height;

/*
 * 图片oss地址
 */
@property (nonatomic, copy) NSString *url;

@end

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
