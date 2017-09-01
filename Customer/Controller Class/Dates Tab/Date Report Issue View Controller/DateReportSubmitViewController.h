
//  DateReportSubmitViewController.h
//  Customer
//  Created by Jamshed Ali on 30/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface DateReportSubmitViewController : UIViewController<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *messageTextView;

@property(strong,nonatomic)NSString *requestType;
@property(strong,nonatomic)NSString *contractorIdStr;
@property(strong,nonatomic)NSString *dateIdStr;
@property(strong,nonatomic)NSString *issueIdStr;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;

@end
