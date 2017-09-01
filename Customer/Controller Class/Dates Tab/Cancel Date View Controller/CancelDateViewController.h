
//  CancelDateViewController.h
//  Customer
//  Created by Jamshed Ali on 27/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>

@interface CancelDateViewController : UIViewController {
    IBOutlet UITableView *cancelDateTableView;
}

@property(nonatomic,strong)NSString *dateIdStr;
@property(nonatomic,strong)NSString *dateTypeStr;
@property(nonatomic,strong)NSString *buttonStatus;
@property (nonatomic, strong) NSString *addressCancelValue;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)submitButtonClicked:(id)sender;

@property (assign) BOOL isFromRequestNow;
@end
