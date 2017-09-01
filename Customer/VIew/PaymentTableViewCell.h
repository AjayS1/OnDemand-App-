
//  PaymentTableViewCell.h
//  Contractor
//  Created by Jamshed Ali on 25/07/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface PaymentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (strong, nonatomic) IBOutlet UILabel *accountNumberLabel;

@property (strong, nonatomic) IBOutlet UILabel *accountTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountStatusLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountExpiryLabel;
@property (strong, nonatomic) IBOutlet UILabel *accountPrimaryLabel;

@property (strong, nonatomic) IBOutlet UIButton *setPrimaryButton;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton *verifyButton;
@end
