//
//  ChatUserTableViewCell.h
//  Customer
//
//  Created by Jamshed Ali on 08/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatUserTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *messageLbl;
    IBOutlet UILabel *notificationLbl;
}
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;
@property (strong, nonatomic) IBOutlet UILabel *notificationLbl;

@end
