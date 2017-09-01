//
//  OrderProcessedViewController.h
//  Contractor
//
//  Created by Aditi on 23/12/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OrderProcessDelegate <NSObject>

-(void)callTabBarMethod;

@end
@interface OrderProcessedViewController : UIViewController
@property (nonatomic, weak) id <OrderProcessDelegate > delegate;

@end
