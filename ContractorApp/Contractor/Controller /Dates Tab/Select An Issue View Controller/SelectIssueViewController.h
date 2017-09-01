
//  SelectIssueViewController.h
//  Customer
//  Created by Jamshed Ali on 30/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface SelectIssueViewController : UIViewController {
    
    IBOutlet UILabel *contractorNamelabel;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *dateLabel;
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *statusLabel;

    
}
@property(strong,nonatomic)NSString *statusValueStr;

@property(strong,nonatomic)NSDictionary *dataDictionary;
@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property(strong,nonatomic)NSString *dateIdStr;
@property (strong, nonatomic)  NSString *userImagePicUrl;
@property (strong, nonatomic)  NSString *userNameStr;
@property(strong,nonatomic)NSString *dateCompletedTimeStr;
@property(strong,nonatomic)NSString *priceValueStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)dateIssueButtonClicked:(id)sender;
- (IBAction)chargeIssueButtonClicked:(id)sender;
- (IBAction)diffrentIssueButtonClicked:(id)sender;




@end