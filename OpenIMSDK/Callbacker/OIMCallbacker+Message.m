//
//  OIMCallbacker+Message.m
//  OpenIMSDK
//
//  Created by x on 2022/2/14.
//

#import "OIMCallbacker+Message.h"

@implementation OIMCallbacker (Message)



- (void)setAdvancedMsgListenerWithOnRecvMessageRevoked:(OIMStringCallback)onRecvMessageRevoked
                                  onRecvC2CReadReceipt:(OIMReceiptCallback)onRecvC2CReadReceipt onRecvNewMessage:(OIMMessageInfoCallback)onRecvNewMessage {
    
    self.onRecvMessageRevoked = onRecvMessageRevoked;
    self.onRecvC2CReadReceipt = onRecvC2CReadReceipt;
    self.onRecvNewMessage = onRecvNewMessage;    
}

@end
