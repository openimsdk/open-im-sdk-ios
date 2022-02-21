//
//  OIMCallbacker+Message.h
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import "OIMCallbacker.h"

NS_ASSUME_NONNULL_BEGIN

@interface OIMCallbacker (Message) 

/*
 * 添加消息监听
 *
 * 当对方撤回条消息 onRecvMessageRevoked，通过回调将界面已显示的消息替换为"xx撤回了一套消息"
 * 当对方阅读了消息 onRecvC2CReadReceipt，通过回调将已读的消息更改状态。
 * 新增消息 onRecvNewMessage，向界面添加消息
 */
- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(OIMStringCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt
                                      onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage;

@end

NS_ASSUME_NONNULL_END
