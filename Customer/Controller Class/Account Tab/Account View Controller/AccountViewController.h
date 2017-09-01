
//  AccountViewController.h
//  Customer
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate> {
    
    IBOutlet UITableView *accountTable;
    IBOutlet UIImageView *profileImageView;
  //  IBOutlet UILabel *userName;
    IBOutlet UILabel *ratingLabel;
    IBOutlet UILabel *nameLabel;
    UITextField *nameTextField;
    
}

@property (strong, nonatomic) NSMutableArray *userInfoArr;
@property (assign) BOOL isFromOrderProcess;
@property (assign) BOOL isFromCreditCardProcess;
@property (assign) BOOL isFromUpdateMobileNumber;
@property (assign) BOOL isEmailVerifiedOrNotPage;

@end
