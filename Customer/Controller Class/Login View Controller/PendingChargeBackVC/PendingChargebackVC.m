//
//  PendingChargebackVC.m
//  Customer
//
//  Created by Aditi on 09/02/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "PendingChargebackVC.h"
#import "ContactUSVC.h"
#import "AppDelegate.h"

@interface PendingChargebackVC ()
@property (weak,nonatomic) IBOutlet UITextView *pendingLabelText;
@end

@implementation PendingChargebackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    [_pendingLabelText setText:self.pendingChargeBackString];
//    NSString *string = self.pendingChargeBackString;
//    if ([string rangeOfString:@"contact us"].location == NSNotFound) {
//        NSLog(@"string does not contain bla");
//    } else {
//        NSLog(@"string contains bla!");
//        
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)tryAgainButtonMethodeAction:(id)sender {
    
    ContactUSVC *notiView = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSVC"];
     [self.navigationController pushViewController:notiView animated:YES];
}

-(IBAction)signOffButtonActionMethode:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end

