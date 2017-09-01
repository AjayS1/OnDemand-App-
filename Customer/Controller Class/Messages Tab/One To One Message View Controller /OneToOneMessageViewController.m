
//  OneToOneMessageViewController.m
//  Customer
//  Created by Jamshed Ali on 22/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.


#import "OneToOneMessageViewController.h"

@interface OneToOneMessageViewController () {
    
    SingletonClass *sharedInstance;
    NSDateFormatter *dateFormatter;
    NSString *dateCountStr;
    NSString *messageCountString;
    NSString *notificationsCountStr;
    
}

@end

@implementation OneToOneMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  }


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    firstMessageStr = @"firstmessageCallStr";
    sharedInstance = [SingletonClass sharedInstance];
    userIdStr = sharedInstance.userId;
    NSLog(@"recipientIdStr === %@",self.recipientIdStr);
    dateFormatter = [[NSDateFormatter alloc]init];
    CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
    if(iOSDeviceScreenSize.height == 480){
        
    } else if(iOSDeviceScreenSize.height == 568){
        
    } else if(iOSDeviceScreenSize.height == 667){
        
    } else if(iOSDeviceScreenSize.height == 736){
        
    } else {
        
    }
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, iOSDeviceScreenSize.width, 64)];
    headerView.backgroundColor = [UIColor colorWithRed:177/255.0 green:128/255.0 blue:186/255.0 alpha:1.0];
    [self.view addSubview:headerView];
    UIButton *backButton = [CommonUtils createButtonWithRect:CGRectMake(0, 20, 50, 42) andText:@"" andTextColor:[UIColor whiteColor] andFontSize:@"14" andImgName:@""];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    UILabel *titleLabel = [CommonUtils createLabelWithRect:CGRectMake(0, 25, iOSDeviceScreenSize.width, 30) andTitle:[sharedInstance.recipientNameStr capitalizedString] andTextColor:[UIColor whiteColor]];
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
    self.navigationController.navigationBar.backgroundColor = [UIColor purpleColor];
    self.inputToolbar.contentView.textView.pasteDelegate = self;
    self.demoData = [[DemoModelData alloc] init];
    
    if (![NSUserDefaults incomingAvatarSetting]) {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    }
    
    if (![NSUserDefaults outgoingAvatarSetting]) {
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    }
    
    self.showLoadEarlierMessagesHeader = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage jsq_defaultTypingIndicatorImage]
                                                                              style:UIBarButtonItemStyleBordered
                                                                             target:self
                                                                             action:@selector(receiveMessagePressed:)];
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(delete:)];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dateEndThenPaymentScreen:)
                                                 name:@"dateEndThenPaymentScreen"
                                               object:nil];
    if (APPDELEGATE.hubConnection) {
        [APPDELEGATE.hubConnection  reconnecting];
    }
    self.navigationController.navigationBar.hidden=YES;
    [self.tabBarController.tabBar setHidden:YES];
    self.title = @"MESSAGES";

    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(closePressed:)];
    }
    updateTimer = [NSTimer scheduledTimerWithTimeInterval: 5.0 target: self
                                                 selector: @selector(updateMessages) userInfo: nil repeats: YES];
    [updateTimer fire];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    // updateTimer = nil;
    [updateTimer invalidate];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"dateEndThenPaymentScreen"
                                                  object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.collectionView.collectionViewLayout.springinessEnabled = [NSUserDefaults springinessSetting];
}

-(void)backButtonClicked {
    
    if (sharedInstance.isFromCancelDateRequest)
    {
        [self tabBarControllerClass];
        sharedInstance.isFromCancelDateRequest = NO;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)tabBarCountApiCall {
    
    NSString *userIdStr = sharedInstance.userId;
    NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithObjectsAndKeys:userIdStr,@"UserID",@"1" ,@"userType",nil];
    [ProgressHUD show:@"Please wait..." Interaction:NO];
    [ServerRequest requestWithUrl:APITabBarMessageCountApiCall withParams:params CallBack:^(id responseObject, NSError *error) {
        NSLog(@"response object Get Comments List %@",responseObject);
        [ProgressHUD dismiss];
        if(!error){
            NSLog(@"Response is --%@",responseObject);
            if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Dates"] isEqualToString:@"0"])
                {
                    dateCountStr  = nil;
                }
                else
                {
                    dateCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Dates"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Mesages"] isEqualToString:@"0"])
                {
                    messageCountString = nil;
                }
                else
                {
                    messageCountString = [[responseObject objectForKey:@"result"] objectForKey:@"Mesages"];
                }
                
                if ([[[responseObject objectForKey:@"result"] objectForKey:@"Notifications"] isEqualToString:@"0"])
                {
                    notificationsCountStr   = nil;
                }
                else
                {
                    notificationsCountStr = [[responseObject objectForKey:@"result"] objectForKey:@"Notifications"];
                }
            }
        }
        [self tabBarControllerClass];
    }];
}

- (void)tabBarControllerClass {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *searchScreenView = [storyboard instantiateViewControllerWithIdentifier:@"search"];
    //searchScreenView.view.backgroundColor = [UIColor whiteColor];
    searchScreenView.title = @"Search";
    searchScreenView.tabBarItem.image = [UIImage imageNamed:@"search"];
    searchScreenView.tabBarItem.selectedImage = [UIImage imageNamed:@"search_hover"];
    
    DatesViewController *datesView = [storyboard instantiateViewControllerWithIdentifier:@"dates"];
    //datesView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    datesView.tabBarItem.badgeValue = dateCountStr;
    datesView.title = @"Dates";
    datesView.isFromDateDetails = NO;
    datesView.tabBarItem.image = [UIImage imageNamed:@"dates"];
    datesView.tabBarItem.selectedImage = [UIImage imageNamed:@"dates_hover"];
    
    MessagesViewController *messageView = [storyboard instantiateViewControllerWithIdentifier:@"messages"];
    messageView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    messageView.tabBarItem.badgeValue = messageCountString;
    messageView.title = @"Messages";
    messageView.tabBarItem.image = [UIImage imageNamed:@"message"];
    messageView.tabBarItem.selectedImage = [UIImage imageNamed:@"message_hover"];
    
    NotificationsViewController *notiView = [storyboard instantiateViewControllerWithIdentifier:@"notifications"];
    notiView.view.backgroundColor = [UIColor colorWithRed:241.0/255 green:241.0/255 blue:241.0/255 alpha:1.0];
    notiView.tabBarItem.badgeValue = notificationsCountStr;
    notiView.title = @"Notifications";
    notiView.tabBarItem.image = [UIImage imageNamed:@"notification"];
    notiView.tabBarItem.selectedImage = [UIImage imageNamed:@"notification_hover"];
    
    AccountViewController *accountView = [storyboard instantiateViewControllerWithIdentifier:@"account"];
    accountView.title = @"Account";
    accountView.tabBarItem.image = [UIImage imageNamed:@"user"];
    accountView.tabBarItem.selectedImage = [UIImage imageNamed:@"user_hover"];
    
    UINavigationController *navC1 = [[UINavigationController alloc] initWithRootViewController:searchScreenView];
    UINavigationController *navC2 = [[UINavigationController alloc] initWithRootViewController:datesView];
    UINavigationController *navC3 = [[UINavigationController alloc] initWithRootViewController:messageView];
    UINavigationController *navC4 = [[UINavigationController alloc] initWithRootViewController:notiView];
    UINavigationController *navC5 = [[UINavigationController alloc] initWithRootViewController:accountView];
    
    /**************************************** Key Code ****************************************/
    APPDELEGATE.tabBarC    = [[LCTabBarController alloc] init];
    APPDELEGATE.tabBarC.selectedItemTitleColor = [UIColor purpleColor];
    APPDELEGATE.tabBarC.viewControllers        = @[navC1, navC2, navC3, navC4, navC5];
    [self.navigationController pushViewController:APPDELEGATE.tabBarC animated:NO];
}

- (void)dateEndThenPaymentScreen:(NSNotification*) noti {
    
    NSDictionary *responseObject = noti.userInfo;
    NSString *requestTypeStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateType"]];
    NSString *dateIDValueStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"dateId"]];
    PaymentDateCompletedViewController *dateDetailsView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentDateCompleted"];
    dateDetailsView.isFromLoginView = NO;
    dateDetailsView.self.dateIdStr = dateIDValueStr;
    dateDetailsView.self.dateTypeStr = requestTypeStr;
    [self.navigationController pushViewController:dateDetailsView animated:YES];
    
}


-(void)updateMessages {
    
    //http://ondemandapiqa.flexsin.in/API/Account/GetMessagebyUser?CustomerID=Cu001debf&ContractorID=Cr00c7344&UserType=1&DateId=Date182483&message_id=81377
    NSString *urlstr=[NSString stringWithFormat:@"%@?CustomerID=%@&ContractorID=%@&UserType=%@&DateId=%@&message_id=%@",APIGetMessagebyUser,userIdStr,self.recipientIdStr,@"1",sharedInstance.dateIdStr,@"0"];
    NSString *encoded = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [ServerRequest AFNetworkPostRequestUrlForAddNewApi:encoded withParams:nil CallBack:^(id responseObject, NSError *error) {
        NSLog(@"Response is --%@",responseObject);
        if ([[responseObject objectForKey:@"StatusCode"] intValue] ==1) {
            
            sharedInstance.isFromMessageDetails = YES;
            if ([[[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"] isKindOfClass:[NSArray class]]) {
                
                NSArray  *messagedataConversationArray = [[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"];
                //NSArray *messageData =  [[responseObject objectForKey:@"result"]objectForKey:@"MessageBYUser"];
                sharedInstance.messagessDataMArray = [messagedataConversationArray copy];
                sharedInstance.dateEndMessageDisableStr = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"DateStatus"]];
                
                if([firstMessageStr isEqualToString:@"firstmessageCallStr"]) {
                    firstMessageStr = @"";
                    newUpdateMessageStr = [NSString stringWithFormat:@"%lu",(unsigned long)[messagedataConversationArray count]];
                    [self scrollToBottomAnimated:YES];
                    JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
                    
                    if (!copyMessage) {
                        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
                                                          displayName:kJSQDemoAvatarDisplayNameJobs
                                                                 text:@"First received!"];
                    }
                    
                    [self.demoData.messages removeAllObjects];
                    for (int i =0; i<[messagedataConversationArray count]; i++) {
                        
                        NSString *senderIdStr = [NSString stringWithFormat:@"%@",[[messagedataConversationArray objectAtIndex:i]objectForKey:@"SenderID"] ];
                        NSString *messageStr = [NSString stringWithFormat:@"%@",[[messagedataConversationArray objectAtIndex:i]objectForKey:@"MessageText"]];
                        NSString *userNameStr = [NSString stringWithFormat:@"%@",[[messagedataConversationArray objectAtIndex:i]objectForKey:@"UserName"]];
                        JSQMessage *newMessage = nil;
                        newMessage = [JSQMessage messageWithSenderId:senderIdStr
                                                         displayName:userNameStr
                                                                text:messageStr];
                        [self.demoData.messages addObject:newMessage];
                        [self finishReceivingMessageAnimated:NO];
                    }
                }
                else {
                    
                    
                    NSString *messageCountstrr = [NSString stringWithFormat:@"%lu",(unsigned long)[messagedataConversationArray count]];
                    if ([newUpdateMessageStr isEqualToString:messageCountstrr]) {
                        
                    }
                    else {
                        
                        newUpdateMessageStr = messageCountstrr;
                        [self scrollToBottomAnimated:YES];
                        JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
                        if (!copyMessage) {
                            copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
                                                              displayName:kJSQDemoAvatarDisplayNameJobs
                                                                     text:@"First received!"];
                        }
                        
                        [self.demoData.messages removeAllObjects];
                        for (int i =0; i<[messagedataConversationArray count]; i++) {
                            NSString *senderIdStr = [NSString stringWithFormat:@"%@",[[messagedataConversationArray objectAtIndex:i]objectForKey:@"SenderID"] ];
                            NSString *messageStr = [NSString stringWithFormat:@"%@",[[messagedataConversationArray objectAtIndex:i]objectForKey:@"MessageText"] ];
                            NSString *userNameStr = [NSString stringWithFormat:@"%@",[[messagedataConversationArray objectAtIndex:i]objectForKey:@"UserName"]];
                            NSString *imageUrlStr = [NSString stringWithFormat:@"%@",[[messagedataConversationArray objectAtIndex:i]objectForKey:@"Url"]];
                            JSQMessage *newMessage = nil;
                            newMessage = [JSQMessage messageWithSenderId:senderIdStr
                                                             displayName:userNameStr
                                                                    text:messageStr
                                                                     url:imageUrlStr];
                            [self.demoData.messages addObject:newMessage];
                            [self finishReceivingMessageAnimated:NO];
                        }
                    }
                }
            }
        } else {
            
            NSLog(@"Response error %@",error);
        }
        
    }];
}

#pragma mark - Custom menu actions for cells

- (void)didReceiveMenuWillShowNotification:(NSNotification *)notification
{
    UIMenuController *menu = [notification object];
    menu.menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];
}

#pragma mark - Testing

- (void)pushMainViewController
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *nc = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:nc.topViewController animated:YES];
}

  #pragma mark - Actions

- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    self.showTypingIndicator = !self.showTypingIndicator;
    
    /**
     *  Scroll to actually view the indicator
     */
    [self scrollToBottomAnimated:YES];
    
    /**
     *  Copy last sent message, this will be the new "received" message
     */
    JSQMessage *copyMessage = [[self.demoData.messages lastObject] copy];
    
    if (!copyMessage) {
        copyMessage = [JSQMessage messageWithSenderId:kJSQDemoAvatarIdJobs
                                          displayName:kJSQDemoAvatarDisplayNameJobs
                                                 text:@"First received!"];
    }
    
    /**
     *  Allow typing indicator to show
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *userIds = [[self.demoData.users allKeys] mutableCopy];
        [userIds removeObject:self.senderId];
        NSString *randomUserId = userIds[arc4random_uniform((int)[userIds count])];
        
        JSQMessage *newMessage = nil;
        id<JSQMessageMediaData> newMediaData = nil;
        id newMediaAttachmentCopy = nil;
        
        if (copyMessage.isMediaMessage) {
            id<JSQMessageMediaData> copyMediaData = copyMessage.media;
            
            if ([copyMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                JSQPhotoMediaItem *photoItemCopy = [((JSQPhotoMediaItem *)copyMediaData) copy];
                photoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [UIImage imageWithCGImage:photoItemCopy.image.CGImage];
                photoItemCopy.image = nil;
                newMediaData = photoItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                JSQLocationMediaItem *locationItemCopy = [((JSQLocationMediaItem *)copyMediaData) copy];
                locationItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [locationItemCopy.location copy];
                locationItemCopy.location = nil;
                newMediaData = locationItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                JSQVideoMediaItem *videoItemCopy = [((JSQVideoMediaItem *)copyMediaData) copy];
                videoItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [videoItemCopy.fileURL copy];
                videoItemCopy.fileURL = nil;
                videoItemCopy.isReadyToPlay = NO;
                
                newMediaData = videoItemCopy;
            }
            else if ([copyMediaData isKindOfClass:[JSQAudioMediaItem class]]) {
                JSQAudioMediaItem *audioItemCopy = [((JSQAudioMediaItem *)copyMediaData) copy];
                audioItemCopy.appliesMediaViewMaskAsOutgoing = NO;
                newMediaAttachmentCopy = [audioItemCopy.audioData copy];
                
                /**
                 *  Reset audio item to simulate "downloading" the audio
                 */
                audioItemCopy.audioData = nil;
                
                newMediaData = audioItemCopy;
            }
            else {
                NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
            }
            
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:self.demoData.users[randomUserId]
                                                   media:newMediaData];
        }
        else {
            newMessage = [JSQMessage messageWithSenderId:randomUserId
                                             displayName:self.demoData.users[randomUserId]
                                                    text:copyMessage.text];
        }
        [self.demoData.messages addObject:newMessage];
        [self finishReceivingMessageAnimated:YES];
        if (newMessage.isMediaMessage) {
            /**
             *  Simulate "downloading" media
             */
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                /**
                 *  Media is "finished downloading", re-display visible cells
                 *
                 *  If media cell is not visible, the next time it is dequeued the view controller will display its new attachment data
                 *
                 *  Reload the specific item, or simply call `reloadData`
                 */
                
                if ([newMediaData isKindOfClass:[JSQPhotoMediaItem class]]) {
                    ((JSQPhotoMediaItem *)newMediaData).image = newMediaAttachmentCopy;
                    [self.collectionView reloadData];
                }
                else if ([newMediaData isKindOfClass:[JSQLocationMediaItem class]]) {
                    [((JSQLocationMediaItem *)newMediaData)setLocation:newMediaAttachmentCopy withCompletionHandler:^{
                        [self.collectionView reloadData];
                    }];
                }
                else if ([newMediaData isKindOfClass:[JSQVideoMediaItem class]]) {
                    ((JSQVideoMediaItem *)newMediaData).fileURL = newMediaAttachmentCopy;
                    ((JSQVideoMediaItem *)newMediaData).isReadyToPlay = YES;
                    [self.collectionView reloadData];
                }
                else if ([newMediaData isKindOfClass:[JSQAudioMediaItem class]]) {
                    ((JSQAudioMediaItem *)newMediaData).audioData = newMediaAttachmentCopy;
                    [self.collectionView reloadData];
                }
                else {
                    NSLog(@"%s error: unrecognized media item", __PRETTY_FUNCTION__);
                }
            });
        }
    });
}

- (void)closePressed:(UIBarButtonItem *)sender {
    
    [self.delegateModal didDismissJSQDemoViewController:self];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    // [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    sharedInstance.isFromMessageDetails = NO;
    [self.demoData.messages addObject:message];
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    [self.inputToolbar.contentView.textView resignFirstResponder];
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Media messages", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Send photo", nil), NSLocalizedString(@"Send location", nil), NSLocalizedString(@"Send video", nil), NSLocalizedString(@"Send audio", nil), nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        [self.inputToolbar.contentView.textView becomeFirstResponder];
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self.demoData addPhotoMediaMessage];
            break;
            
        case 1:
        {
            __weak UICollectionView *weakView = self.collectionView;
            
            [self.demoData addLocationMediaMessageCompletion:^{
                [weakView reloadData];
            }];
        }
            break;
            
        case 2:
            [self.demoData addVideoMediaMessage];
            break;
            
        case 3:
            [self.demoData addAudioMediaMessage];
            break;
    }
    [self finishSendingMessageAnimated:YES];
}



#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    NSString *appUserIdStr = sharedInstance.userId;
    return appUserIdStr;
}

- (NSString *)senderDisplayName {
    return kJSQDemoAvatarDisplayNameSquires;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.demoData.messages objectAtIndex:indexPath.item];
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didDeleteMessageAtIndexPath:(NSIndexPath *)indexPath
{
    [self.demoData.messages removeObjectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.demoData.outgoingBubbleImageData;
    }
    
    return self.demoData.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    //  /*
    if ([message.senderId isEqualToString:self.senderId]) {
        if (![NSUserDefaults outgoingAvatarSetting]) {
            return nil;
        }
    }
    else {
        if (![NSUserDefaults incomingAvatarSetting]) {
            return nil;
        }
    }
    return [self.demoData.avatars objectForKey:message.senderId];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *returnString = [[NSAttributedString alloc] initWithString:@""];
    return returnString;
}


-(NSAttributedString *)changeDateInParticularFormateWithStringForDate :(NSDate *)string
{
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
    NSAttributedString *dateRepresentation = [self setDateStatusWithDate:string];
    return dateRepresentation;
}

-(NSAttributedString *)setDateStatusWithDate:(NSDate *)ValueDate
{
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"EEE,yyyy-MM-dd"];
    NSInteger dayDiff = (int)[ValueDate timeIntervalSinceNow] / (60*60*24);
    NSAttributedString *dateStatus;
    if (dayDiff == 0) {
        NSLog(@"Today");
        dateStatus = [[NSAttributedString alloc] initWithString:@"Today"];
    }
    else if (dayDiff == -1) {
        NSLog(@"Yesterday");
        dateStatus =[[NSAttributedString alloc] initWithString:@"Yesterday"];
    }
    else if(dayDiff > -7 && dayDiff < -1) {
        NSLog(@"This week");
        dateStatus = (NSAttributedString *) [dateFormatter1 stringFromDate:ValueDate];
    }
    else if(dayDiff > -14 && dayDiff <= -7) {
        dateStatus = (NSAttributedString *)[dateFormatter1 stringFromDate:ValueDate];
        NSLog(@"Last week");
    }
    else if(dayDiff >= -60 && dayDiff <= -30) {
        NSLog(@"Last month");
        dateStatus =(NSAttributedString *) [dateFormatter1 stringFromDate:ValueDate];
    }
    else {
        dateStatus = (NSAttributedString *)[dateFormatter1 stringFromDate:ValueDate];
        NSLog(@"A long time ago");
    }
    return dateStatus;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.demoData.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /** Don't specify attributes to use the defaults. */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    if (sharedInstance.isFromMessageDetails) {
        NSAttributedString *messTime;
        NSAttributedString *messageTime;
        NSMutableDictionary *message = [sharedInstance.messagessDataMArray objectAtIndex:indexPath.item];
        messTime = [message valueForKey:@"postDate"];
        NSString *requestTimeStr = [NSString stringWithFormat:@"%@", messTime];
        NSString *requestDate = [self convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        messageTime = [self changeDateInParticularFormateWithStringForDate:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
        return messageTime;
    }
    else
        return nil;
    return nil;
}

#pragma mark: Change Date in Particular Formate
-(NSMutableAttributedString *)changeDateInParticularFormateWithStringForDate :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm aaa"];
    NSMutableAttributedString *dateRepresentation = (NSMutableAttributedString *)[dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
}

#pragma mark:- Change UTC time Current Local Time

- (NSString *) convertUTCTimeToLocalTime:(NSString *)dateString WithFormate:(NSString *)formate{
    
    NSString *formateValue = [NSString stringWithFormat:@"%@", formate];
    //formate = @"yyyy-MM-dd'T'HH:mm:ss"
    [dateFormatter setDateFormat:formateValue];
    NSTimeZone *gmtTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    //Log: gmtTimeZone - GMT (GMT) offset 0
    
    [dateFormatter setTimeZone:gmtTimeZone];
    NSDate *dateFromString = [dateFormatter dateFromString:dateString];
    //Log: dateFromString - 2016-03-08 06:00:00 +0000
    
    [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
    NSTimeZone * sourceTimeZone = [NSTimeZone defaultTimeZone];
    //Log: sourceTimeZone - America/New_York (EDT) offset -14400 (Daylight)
    
    // Add daylight time
    BOOL isDayLightSavingTime = [sourceTimeZone isDaylightSavingTimeForDate:dateFromString];
    if (isDayLightSavingTime) {
    }
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sourceTimeZone];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:dateFromString];
    return dateRepresentation;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.demoData.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    cell.avatarImageView.layer.cornerRadius=cell.avatarImageView.frame.size.width/2;
    cell.avatarImageView.layer.masksToBounds=YES;
    if (self.demoData.messages.count)
    {
        
        JSQMessage *msg = [self.demoData.messages objectAtIndex:indexPath.item];
        if (sharedInstance.isFromMessageDetails) {
            NSAttributedString *messTime;
            //OneToOneMessageViewController.isFromMessageDetails = YES;
            NSString *messageTime;
            NSMutableDictionary *message = [sharedInstance.messagessDataMArray objectAtIndex:indexPath.item];
            NSLog(@"[self.demoData.messages objectAtIndex:indexPath.item] ==== %@ ", [self.demoData.messages objectAtIndex:indexPath.item]);
            
            messTime = [message valueForKey:@"postDate"];
            //isReadContractor,isReadCustomer
            NSString *requestTimeStr = [NSString stringWithFormat:@"%@", messTime];
            NSString *requestDate = [self convertUTCTimeToLocalTime:requestTimeStr WithFormate:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            messageTime = [self changeDateInParticularFormateWithString:requestDate WithFormate:@"yyyy-MM-dd HH:mm:ss"];
            NSString *newString;
            NSLog(@"[self.demoData.messages  ==== %@ ", self.demoData.messages);
            
            if (!msg.isMediaMessage) {
                
                if ([msg.senderId isEqualToString:self.senderId]) {
                    cell.textView.textColor = [UIColor blackColor];
                    NSString *isCustumerRead = [NSString stringWithFormat:@"%@",[message valueForKey:@"isReadContractor"]];
                    if ([isCustumerRead isEqualToString:@"True"]) {
                        newString = [NSString stringWithFormat:@"Read %@",messageTime];
                        [cell.cellBottomLabel setText:newString];
                    }
                    else
                    {
                        [cell.cellBottomLabel setText:messageTime];
                    }
                    cell.avatarImageView.image = [UIImage imageNamed:@"security_thief_danger_hacker_virus_cyber_crime_intruder-128.png"];
                    if (sharedInstance.userImageUrlStr == (id)[NSNull null] || sharedInstance.userImageUrlStr.length == 0 ) {
                        sharedInstance.userImageUrlStr = @"";
                    }
                    if(sharedInstance.userImageUrlStr.length !=0){
                        NSURL *imgUrl =[NSURL URLWithString:sharedInstance.userImageUrlStr];
                        [ cell.avatarImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"anonymouse.png"]];
                        
                    }
                    else
                    {
                        cell.avatarImageView.image=[UIImage imageNamed:@"anonymouse.png"];
                    }
                    // sharedInstance.isFromMessageDetails = NO;
                    
                }
                else {
                    
                    cell.textView.textColor = [UIColor whiteColor];
                    
                    NSString *isCustumerRead = [NSString stringWithFormat:@"%@",[message valueForKey:@"isReadContractor"]];
                    if ([isCustumerRead isEqualToString:@"True"]) {
                        newString = [NSString stringWithFormat:@"%@",messageTime];
                        [cell.cellBottomLabel setText:newString];
                    }
                    else{
                        [cell.cellBottomLabel setText:messageTime];
                    }
                    //cell.avatarImageView.image = [UIImage imageNamed:@"check_green.png"];
                    NSString *strOfImage ;
                    NSMutableArray *arrayOfImage = sharedInstance.messagessDataMArray;
                    if (arrayOfImage.count) {
                        NSDictionary *dictOfArray = [arrayOfImage objectAtIndex:indexPath.row];
                        strOfImage = [dictOfArray valueForKey:@"Url"];
                        
                    }
                    if (self.userImageUrlStr == (id)[NSNull null] || self.userImageUrlStr.length == 0 ) {
                        self.userImageUrlStr = @"";
                    }
                    if(strOfImage.length !=0){
                        NSURL *imgUrl =[NSURL URLWithString:strOfImage];
                        [ cell.avatarImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"anonymouse.png"]];
                    }
                    else {
                        
                        cell.avatarImageView.image=[UIImage imageNamed:@"anonymouse.png"];
                    }
                }
                cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
            }
        }
        else
        {
            NSLog(@"[self.demoData.messages  ==== %@ ", self.demoData.messages);
            if (!msg.isMediaMessage) {
                
                if ([msg.senderId isEqualToString:self.senderId]) {
                    cell.textView.textColor = [UIColor blackColor];
                    
                    cell.avatarImageView.image = [UIImage imageNamed:@"security_thief_danger_hacker_virus_cyber_crime_intruder-128.png"];
                    if (sharedInstance.userImageUrlStr == (id)[NSNull null] || sharedInstance.userImageUrlStr.length == 0 ) {
                        sharedInstance.userImageUrlStr = @"";
                    }
                    if(sharedInstance.userImageUrlStr.length !=0){
                        
                        NSURL *imgUrl =[NSURL URLWithString:sharedInstance.userImageUrlStr];
                        [ cell.avatarImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"anonymouse.png"]];
                        
                    }
                    else {
                        cell.avatarImageView.image=[UIImage imageNamed:@"anonymouse.png"];
                    }
                }
                else {
                    
                    cell.textView.textColor = [UIColor whiteColor];
                    //cell.avatarImageView.image = [UIImage imageNamed:@"check_green.png"];
                    NSString *strOfImage ;
                    NSMutableArray *arrayOfImage = sharedInstance.messagessDataMArray;
                    if (arrayOfImage.count) {
                        NSDictionary *dictOfArray = [arrayOfImage objectAtIndex:indexPath.row];
                        strOfImage = [dictOfArray valueForKey:@"Url"];
                        
                    }
                    if (self.userImageUrlStr == (id)[NSNull null] || self.userImageUrlStr.length == 0 ) {
                        self.userImageUrlStr = @"";
                    }
                    if(strOfImage.length !=0){
                        NSURL *imgUrl =[NSURL URLWithString:strOfImage];
                        [ cell.avatarImageView sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"anonymouse.png"]];
                    }
                    else
                    {
                        cell.avatarImageView.image=[UIImage imageNamed:@"anonymouse.png"];
                    }
                }
                cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                                      NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
                //sharedInstance.isFromMessageDetails = YES;
            }
        }
    }
    return cell;
}

#pragma mark - UICollectionView Delegate

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }
    
    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }
    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Action", nil)
                                message:nil
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(@"OK", nil)
                      otherButtonTitles:nil]
     show];
}

#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.item == 0) {
        return 10.0f;
    }
    else{
        return 0.0f;
        
    }
    return 0.0f;
    
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    //    JSQMessage *currentMessage = [self.demoData.messages objectAtIndex:indexPath.item];
    //    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
    //        return 0.0f;
    //    }
    //
    //    if (indexPath.item - 1 > 0) {
    //        JSQMessage *previousMessage = [self.demoData.messages objectAtIndex:indexPath.item - 1];
    //        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
    //            return 0.0f;
    //        }
    //    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

#pragma mark - JSQMessagesComposerTextViewPasteDelegate methods


- (BOOL)composerTextView:(JSQMessagesComposerTextView *)textView shouldPasteWithSender:(id)sender {
    if ([UIPasteboard generalPasteboard].image) {
        // If there's an image in the pasteboard, construct a media item with that image and `send` it.
        JSQPhotoMediaItem *item = [[JSQPhotoMediaItem alloc] initWithImage:[UIPasteboard generalPasteboard].image];
        JSQMessage *message = [[JSQMessage alloc] initWithSenderId:self.senderId
                                                 senderDisplayName:self.senderDisplayName
                                                              date:[NSDate date]
                                                             media:item];
        [self.demoData.messages addObject:message];
        [self finishSendingMessage];
        return NO;
    }
    return YES;
}


#pragma mark: Change Date in Particular Formate
-(NSString *)changeDateInParticularFormateWithString :(NSString *)string WithFormate:(NSString *)formate{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formate];
    NSDate *formatedDate = [date dateFromString:string];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"hh:mm aaa"];
    NSString *dateRepresentation = [dateFormatter1 stringFromDate:formatedDate];
    return dateRepresentation;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
