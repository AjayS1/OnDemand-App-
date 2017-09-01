//
//  WallTableViewCell.m
//  Pipio
//
//  Created by Flexsinmac2 on 19/11/15.
//  Copyright (c) 2015 Jamshed Ali. All rights reserved.
//

#import "WallTableViewCell.h"

@implementation WallTableViewCell
@synthesize nameLbl,dateLbl,addressLbl,statusAcceptedLbl,userImageView,notificationCountLbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
