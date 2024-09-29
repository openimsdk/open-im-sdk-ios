
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OIMUpdateFriendsReq : NSObject

@property (nonatomic, nullable, copy) NSString *ownerUserID;

@property (nonatomic, nullable, copy) NSArray<NSString *> *friendUserIDs;

@property (nonatomic, nullable, copy) NSString *ex;

@property (nonatomic, nullable, copy) NSString *remark;

@property (nonatomic, assign) BOOL isPinned;
@end

NS_ASSUME_NONNULL_END
