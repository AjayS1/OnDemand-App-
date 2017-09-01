
//  PEARMainSlideView.m
//  ImageSlideViewer
//  Created by hirokiumatani on 2015/12/01.
//  Copyright © 2015年 hirokiumatani. All rights reserved.


#import "PEARSlideView.h"
#import "SingletonClass.h"


@implementation PEARSlideView {
    
    SingletonClass *sharedInstance;
    
}

- (id)init
{
    if (self=[super init])
    {
        
        NSString *nibName = NSStringFromClass([self class]);
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        self = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
        self.frame = [[UIScreen mainScreen] bounds];
        self.alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
        return self;
    }
    return self;
}

- (IBAction)tapCloseButton:(UIButton *)sender
{
  //  [UIApplication sharedApplication].statusBarStyle = UIBarStyleBlackTranslucent;
    
 //   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
 //   [self setNeedsStatusBarAppearanceUpdate];

  //  [self preferredStatusBarStyle];
    
    
    sharedInstance = [SingletonClass sharedInstance];
    sharedInstance.imagePopupCondition = @"no";
    if ([self.delegate respondsToSelector:@selector(tapCloseButton)]){
        
     //    [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        [self.delegate tapCloseButton];
    }
}


//- (UIStatusBarStyle) preferredStatusBarStyle {
//    
//  //  [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    
//    return UIStatusBarStyleLightContent;
//    
//    
//}


@end
