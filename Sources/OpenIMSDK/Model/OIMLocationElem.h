//
//  OIMLocationElem.h
//  OpenIMSDK
//
//  Created by x on 2022/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMLocationElem : NSObject

@property (nonatomic, nullable, copy) NSString *desc;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;

@end

NS_ASSUME_NONNULL_END
