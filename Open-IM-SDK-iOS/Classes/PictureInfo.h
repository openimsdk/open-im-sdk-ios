//
//  PictureInfo.h
//  Open-IM-SDK-iOS
//
//  Created by xpg on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"

NS_ASSUME_NONNULL_BEGIN

@interface PictureInfo : BaseModal

/**
     * 唯一ID
     */
@property(nullable) NSString *uuID;
    /**
     * 图片类型
     */
@property(nullable) NSString *type;
    /**
     * 图片大小
     */
@property long size;
    /**
     * 图片宽度
     */
@property int width;
    /**
     * 图片高度
     */
@property int height;
    /**
     * 图片oss地址
     */
@property(nullable) NSString *url;

@end

NS_ASSUME_NONNULL_END
