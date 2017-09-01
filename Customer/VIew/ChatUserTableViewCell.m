//
//  ChatUserTableViewCell.m
//  Customer
//
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import "ChatUserTableViewCell.h"

@implementation ChatUserTableViewCell

@synthesize nameLbl,dateLbl,messageLbl,userImageView,notificationLbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
