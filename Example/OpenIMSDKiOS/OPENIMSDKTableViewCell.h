//
//  OPENIMSDKTableViewCell.h
//  OpenIMSDKiOS_Example
//
//  Created by x on 2022/2/16.
//  Copyright © 2022 xpg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^FuncButtonActionCallback)();

@interface OPENIMSDKTableViewCell : UITableViewCell
{
    FuncButtonActionCallback _funcButtonAction;
}

@property (weak, nonatomic) IBOutlet UIButton *funcButton;
@property (weak, nonatomic) IBOutlet UITextField *funcTextField;


- (void)funcButtonAction:(FuncButtonActionCallback)callback;
@end

NS_ASSUME_NONNULL_END
