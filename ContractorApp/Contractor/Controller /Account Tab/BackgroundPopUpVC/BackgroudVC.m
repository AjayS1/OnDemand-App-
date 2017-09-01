//
//  BackgroudVC.m
//  Contractor
//
//  Created by Aditi on 08/03/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "BackgroudVC.h"
@interface BackgroudVC ()
@end

@implementation BackgroudVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tab];
    [self.userLocationLabel setText:[NSString stringWithFormat:@"Location: %@",[_notificationDictionary valueForKey:@"DateLocation"]]];
    [self.userLocationLabel setNumberOfLines:0];
    [self.userLocationLabel adjustsFontSizeToFitWidth];
    [self.userInfoLabel setText:[NSString stringWithFormat:@"From: %@",[_notificationDictionary valueForKey:@"UserInformation"]]];
    // Do any additional setup after loading the view.
}

-(void)dismissKeyboard{
  //  [self removeFromSuperview];
    [self.delegate dataFromController ];
}

- (IBAction)acceptButtonAction:(id)sender {
    [self presentNextViewCon];
}

- (IBAction)declineButtonAction:(id)sender {
    [self presentNextViewCon];
}

-(void)presentNextViewCon
{
    NSLog(@"Hello");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
