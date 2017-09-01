
//  NotificationTableViewCell.h
//  Customer
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
{
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *messageLbl;
}

@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;
@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;


//ChooseLocationViewController
@property (strong, nonatomic) IBOutlet UIImageView *emailVerifiedImageView;

@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *seperatorLabelValue;
@property (strong, nonatomic) IBOutlet UILabel *labelAddress;
@property (strong, nonatomic) IBOutlet UILabel *labelSeperator;

@end
