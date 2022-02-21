//
//  OPENIMSDKTableViewCell.m
//  OpenIMSDKiOS_Example
//
//  Created by x on 2022/2/16.
//  Copyright © 2022 xpg. All rights reserved.
//

#import "OPENIMSDKTableViewCell.h"


@implementation OPENIMSDKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonAction:(id)sender {
    if (_funcButtonAction) {
        _funcButtonAction();
    }
}

- (void)funcButtonAction:(FuncButtonActionCallback)callback {
    _funcButtonAction = callback;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
