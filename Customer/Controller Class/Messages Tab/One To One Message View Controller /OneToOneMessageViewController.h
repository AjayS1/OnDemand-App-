
//  OneToOneMessageViewController.h
//  Customer
//  Created by Jamshed Ali on 22/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import <UIKit/UIKit.h>
#import "JSQMessages.h"
#import "DemoModelData.h"


@class OneToOneMessageViewController;
@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(OneToOneMessageViewController *)vc;

@end
@interface OneToOneMessageViewController : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate> {
    
    NSMutableArray *dataArray;

    NSTimer  *updateTimer;
    NSString *messageCountStr;
    NSString *newUpdateMessageStr;
    NSString *firstMessageStr;
    NSString *recipientIdStr;
    
    NSString *userIdStr;
}

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) DemoModelData *demoData;
@property (assign) BOOL isFromMessageList;

@property(strong,nonatomic)NSString *recipientIdStr;

@property(strong,nonatomic)NSString *userImageUrlStr;

@property(nonatomic,strong)NSMutableArray *messageDataArray;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
