//
//  CreditCardDeclinedVC.h
//  Contractor
//
//  Created by Aditi on 09/02/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditCardDeclinedVC : UIViewController
@property (strong, nonatomic) NSString *creditCradDeclinedMsg;
@property (strong, nonatomic) NSString *bankDetailsWithUrl;
@property (assign) BOOL isFromLoginCreditView;
@property (strong, nonatomic) NSString *totalAmountToBePaid;
@property (strong, nonatomic) NSString *dateIDStr;
@property (assign) BOOL isFromCaneclDateByCustomer;


@property (strong, nonatomic) NSDictionary *dateDetailsDictionary;



@end
