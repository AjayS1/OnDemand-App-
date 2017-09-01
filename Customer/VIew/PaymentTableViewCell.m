
//  PaymentTableViewCell.m
//  Contractor
//  Created by Jamshed Ali on 25/07/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
////////

#import "PaymentTableViewCell.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@implementation PaymentTableViewCell
@synthesize selectedImageView,accountNumberLabel,setPrimaryButton,deleteButton,verifyButton;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    if (WIN_WIDTH == 320) {

        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 35, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(98, 11, 75, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(160, 11, 56, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(221, 11, 70, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(264, 11, 120, 21)];
        [self.accountExpiryLabel setContentMode:UIViewContentModeLeft];

    }
    else if (WIN_WIDTH == 414){
        
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 45, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(115, 11, 75, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(200, 11, 60, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(270, 11, 45, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(290, 11, 76, 21)];
        [self.accountTypeLabel setNumberOfLines:2];
        [self.accountStatusLabel setBackgroundColor:[UIColor clearColor]];
        [self.accountStatusLabel setContentMode:UIViewContentModeLeft];

    }
    else
    {
        [self.accountTypeLabel  setFrame:CGRectMake(60, 11, 60, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(105, 11, 75, 21)];
//        [self.accountPrimaryLabel  setFrame:CGRectMake(200, 11, 60, 21)];
//        [self.accountExpiryLabel  setFrame:CGRectMake(270, 11, 45, 21)];
//        [self.accountStatusLabel  setFrame:CGRectMake(290, 11, 76, 21)];
//        [self.accountTypeLabel setNumberOfLines:2];
//        [self.accountStatusLabel setBackgroundColor:[UIColor clearColor]];
//        [self.accountStatusLabel setContentMode:UIViewContentModeLeft];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
