//
//  PaymentTypesViewController.h
//  Contractor
//
//  Created by Deepak on 9/2/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentTypesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    IBOutlet UITableView *paymentTypeTableView;
    NSMutableArray *paymentTypeTableDataArray;
    NSMutableArray *arrayCheckUnchek;
    NSMutableArray *selectedDataArray;
    NSMutableArray *checkedTypeDataArray;
    NSString *CashPament;
    NSString *VemnoPament;
    NSString *squareCashPament;
    NSString *payPalPament;
    NSString *creditCardPament;
     NSString *creditCardPamentValue;
     NSString *creditCardStr;
    
    NSString *isCash;
    NSString *isVemno;
    NSString *issquareCash;
    NSString *ispayPal;
    NSString *creditCard;
    NSString *creditCardValue;
    NSArray *itemArry;
    NSString *typeStr;
}
@property(nonatomic,strong)NSDictionary *paymentTypeDict;
- (IBAction)backButtonClicked:(id)sender;
- (IBAction)doneButtonClicked:(id)sender;


@end
