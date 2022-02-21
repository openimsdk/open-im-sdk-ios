//
//  IMDefine.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#ifndef IMDefine_h
#define IMDefine_h

#import "OIMModelDefine.h"

typedef NS_ENUM(NSInteger, OIMPlatform) {
    iOS = 1,    /// iOS
    android,    /// Android
    windows,    /// Windows
    xOS,        /// Mac
    web,        /// Web
    miniWeb     /// miniWeb
};

typedef void (^OIMVoidCallback)(void);
typedef void (^OIMSuccessCallback)(NSString * _Nullable data);
typedef void (^OIMFailureCallback)(NSInteger code, NSString * _Nullable msg);
typedef void (^OIMNumberCallback)(NSInteger number);
typedef void (^OIMStringCallback)(NSString * _Nullable item);



#endif /* IMDefine_h */
