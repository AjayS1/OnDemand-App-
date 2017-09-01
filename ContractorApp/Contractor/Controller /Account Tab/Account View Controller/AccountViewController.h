//
//  AccountViewController.h
//  Customer
//
//  Created by Jamshed Ali on 02/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountViewController : UIViewController<UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UIImageView *profileImageView;
    IBOutlet UILabel *userNameLabel;
    IBOutlet UILabel *ratingLabel;
    
}
@property (strong, nonatomic) IBOutlet UITableView *accountTable;
@property (strong, nonatomic) NSMutableArray *userInfoArr;
@property (assign) BOOL isFromOrderProcess;
@property (assign) BOOL isFromCreditCardProcess;
@property (assign) BOOL isFromAddBankAccountProcess;
@property (assign) BOOL isFromUpdateMobileNumber;
@property (assign) BOOL isEmailVerifiedOrNotPage;
@end
