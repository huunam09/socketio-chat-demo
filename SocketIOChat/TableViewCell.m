//
//  TableViewCell.m
//  SocketIOChat
//
//  Created by Nguyen Huu Nam on 11/22/16.
//  Copyright © 2016 Nguyen Huu Nam. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

@synthesize userNameLabel = _userNameLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
