
//  PaymentTableViewCell.m
//  Contractor
//  Created by Jamshed Ali on 25/07/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "PaymentTableViewCell.h"
#define WIN_WIDTH              [[UIScreen mainScreen]bounds].size.width

@implementation PaymentTableViewCell
@synthesize selectedImageView,accountNumberLabel,setPrimaryButton,deleteButton;
- (void)awakeFromNib {
    [super awakeFromNib];

    if (WIN_WIDTH == 320) {
        [self.accountTypeLabel  setFrame:CGRectMake(40, 11, 45, 21)];
        [self.accountTypeLabel setBackgroundColor:[UIColor clearColor]];
        [self.accountNumberLabel  setFrame:CGRectMake(90, 11, 85, 21)];
        [self.accountNumberLabel setBackgroundColor:[UIColor clearColor]];

        [self.accountPrimaryLabel  setFrame:CGRectMake(175, 11,66, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(230, 11, 0, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(230, 11, 76, 21)];
        [self.accountTypeLabel setContentMode:UIViewContentModeLeft];
        [self.accountNumberLabel   setContentMode:UIViewContentModeLeft];
        [self.accountExpiryLabel setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel  setContentMode:UIViewContentModeLeft];
        [self.accountStatusLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    else if (WIN_WIDTH == 414){
        
        [self.accountTypeLabel  setFrame:CGRectMake(45, 11, 70, 21)];
        [self.accountNumberLabel  setFrame:CGRectMake(130, 11, 85, 21)];
        [self.accountPrimaryLabel  setFrame:CGRectMake(220, 11, 60, 21)];
        [self.accountExpiryLabel  setFrame:CGRectMake(275, 11, 0, 21)];
        [self.accountStatusLabel  setFrame:CGRectMake(275, 11, 76, 21)];
        [self.accountStatusLabel setBackgroundColor:[UIColor whiteColor]];
        
    }
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
