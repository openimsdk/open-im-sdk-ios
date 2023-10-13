//
//  OIMPictureElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface OIMPictureInfo : NSObject

/**
 * Unique ID, can be left unset
 */
@property (nonatomic, nullable, copy) NSString *uuID;

/**
 * Image type, can be left unset
 */
@property (nonatomic, nullable, copy) NSString *type;

/**
 * Image size
 */
@property (nonatomic, assign) NSInteger size;

/**
 * Image width
 */
@property (nonatomic, assign) CGFloat width;

/**
 * Image height
 */
@property (nonatomic, assign) CGFloat height;

/**
 * Image OSS address
 */
@property (nonatomic, copy) NSString *url;

@end

@interface OIMPictureElem : NSObject

/**
 * Local resource path
 */
@property (nonatomic, nullable, copy) NSString *sourcePath;

/**
 * Local image details
 */
@property (nonatomic, nullable, strong) OIMPictureInfo *sourcePicture;

/**
 * Big image details
 */
@property (nonatomic, nullable, strong) OIMPictureInfo *bigPicture;

/**
 * Thumbnail image details
 */
@property (nonatomic, nullable, strong) OIMPictureInfo *snapshotPicture;

@end

NS_ASSUME_NONNULL_END
