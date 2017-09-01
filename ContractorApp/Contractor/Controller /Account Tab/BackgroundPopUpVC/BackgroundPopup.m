//
//  BackgroundPopup.m
//  Contractor
//
//  Created by Aditi on 31/01/17.
//  Copyright © 2017 Jamshed Ali. All rights reserved.
//

#import "BackgroundPopup.h"

@implementation BackgroundPopup

-(void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self addGestureRecognizer:tab];
    [self.userLocationLabel setText:[NSString stringWithFormat:@"Location: %@",[_notificationDictionary valueForKey:@"DateLocation"]]];
    [self.userLocationLabel setNumberOfLines:0];
    [self.userLocationLabel adjustsFontSizeToFitWidth];
    [self.userInfoLabel setText:[NSString stringWithFormat:@"From: %@",[_notificationDictionary valueForKey:@"UserInformation"]]];
}

-(void)dismissKeyboard
{
    [self removeFromSuperview];
    [self.delegate dataFromController ];
}

- (IBAction)acceptButtonAction:(id)sender {
}

- (IBAction)declineButtonAction:(id)sender {
    [self removeFromSuperview];
}
@end
