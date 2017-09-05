//
//  NotificationTableViewCell.h
//  Customer
//
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *messageLbl;
    IBOutlet UISwitch *mySwitch;
    IBOutlet UIButton *checkncheckdBtn;
    IBOutlet UIImageView *emailVerifiedImageView;
}

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UIImageView *emailVerifiedImageView;

@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;
@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;
@property (strong, nonatomic) IBOutlet UIButton *checkncheckdBtn;
@property (strong, nonatomic) IBOutlet UILabel *seperatorLabelValue;

@end
