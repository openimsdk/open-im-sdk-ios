//
//  OIMPictureInfo.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMPictureInfo : NSObject

/*
 * 唯一ID
 */
@property(nonatomic, nullable, copy) NSString *uuID;

/*
 * 图片类型
 */
@property(nonatomic, nullable, copy) NSString *type;

/*
 * 图片大小
 */
@property(nonatomic, assign) NSInteger size;

/*
 * 图片宽度
 */
@property(nonatomic, assign) CGFloat width;

/*
 * 图片高度
 */
@property(nonatomic, assign) CGFloat height;

/*
 * 图片oss地址
 */
@property(nonatomic, nullable, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END
