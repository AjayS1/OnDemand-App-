//
//  AppDelegate.m
//  Customer
//
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingletonClass : NSObject
+(SingletonClass*)sharedInstance;

@property (nonatomic,strong) NSString *imagePopupCondition;
@property (nonatomic,strong) NSString *recipientIdStr;
@property (nonatomic,strong) NSString *userNameStr;
@property (nonatomic,strong) NSString *userImageUrlStr;
@property (nonatomic,strong) NSString *dateIdStr;
@property (nonatomic,strong) NSString *recipientNameStr;
@property (nonatomic,strong) NSString *currentAddressStr;
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *ipAddressStr;
@property (nonatomic,strong) NSString *deviceToken;
@property (nonatomic,strong) NSString *dateEndMessageDisableStr;
@property (nonatomic,strong) NSString *checkPushNotificationOnDemandStr;
@property (nonatomic,strong) NSString *firstNameStr;
@property (nonatomic,strong) NSString *lastNameStr;
@property (nonatomic,strong) NSString *refreshApiCallOrNotStr;
@property (nonatomic,strong) NSString *cityValueStr;
@property (nonatomic,strong) NSString *countryValueStr;
@property (nonatomic,strong) NSString *stateValueStr;
@property (nonatomic,strong) NSString *zipValueStr;
@property (nonatomic,strong) NSString *appVersionNumber;
@property (nonatomic,strong) NSString *BuildValueStr;
@property (nonatomic,strong) NSString *isDuePaymentValueStr;
@property (nonatomic,assign) BOOL isFromCaneclDateByContractor;
@property (nonatomic,assign) BOOL isEmailVerifiedAlreadyOrNot;
@property (nonatomic,assign) BOOL isFromReportSubmit;

@property (nonatomic,strong) NSString *cancelReasonIdValue;

@property (nonatomic,strong) NSString *requestTypeStr;
@property(nonatomic,strong)NSString *latiValueStr;
@property(nonatomic,strong)NSString *customAddressValue;
@property(nonatomic,strong)NSString *longiValueStr;
@property (nonatomic,strong) NSString *VersionValue;
@property (nonatomic,strong) NSString *districValue;
@property (nonatomic,strong) NSString *interestedGender;
@property (nonatomic,strong) NSString *mobileNumberStr;
@property (nonatomic,strong) NSString *strEventType;
@property(nonatomic,strong)NSString *isPastDuePayment;

@property (nonatomic,strong) NSString *strIsEmailNotification;
@property (nonatomic,strong) NSString *strIsMobileNotification;
@property (nonatomic,strong) NSString *IsEmailNotification;
@property (nonatomic,strong) NSString *IsMobileNotification;
@property (strong, nonatomic) NSMutableArray *onDemandPushNotificationArray;
@property (strong, nonatomic) NSMutableArray *messagessDataMArray;
@property (nonatomic,assign) BOOL strIsSelectedNotification;
@property (nonatomic,strong) NSString *isEditStr;
@property (nonatomic,assign) BOOL strIsFromGetVerified;
@property (nonatomic, strong) NSString *userUploadedPhoto;
@property (nonatomic,assign) BOOL IsCropPhotoDirect;
@property (nonatomic,assign) BOOL IsCancelDateFromOnDemandPush;
@property(assign,nonatomic) BOOL isFromCancelDateRequest;
@property(assign,nonatomic) BOOL isFromDateDetailsDateRequest;
@property(assign,nonatomic) BOOL IsFromDateDetailsOnDemand;
@property(assign,nonatomic) BOOL isUserLogoutManualyy;
@property(assign,nonatomic) BOOL isUserLoginManualyy;
@property(assign,nonatomic) BOOL checkThatUserIsOnline;
@property(assign,nonatomic) BOOL checkThatUserReservationOnline;
@property(assign,nonatomic) BOOL checkSelectedIndex;
@property(assign,nonatomic) BOOL IsPrimaryImage;
@property(strong,nonatomic) NSString *PrimaryImageUrl;

@property (nonatomic,strong) NSString *clientCurrentAddress;


//c
@property (nonatomic,strong) NSString *IsCancellationFeeAllowed;
@property (nonatomic,strong) NSString *cancellationFee;
@property(assign,nonatomic) BOOL isFromMessageDetails;
@property(assign,nonatomic) BOOL isFromMessageCancelDetails;
@property(assign,nonatomic) BOOL checkChateIsActive;

//Card Details
@property(nonatomic,strong)NSString *productID;
@property(nonatomic,strong)NSString *productDescription;
@property(nonatomic,strong)NSString *productQty;
@property(nonatomic,strong)NSString *productPrice;
@property(nonatomic,strong)NSString *productTotal;
@property(nonatomic,strong)NSString *productPriceValue;

@property(nonatomic,strong)NSString *productCardName;
@property(nonatomic,strong)NSString *productTotalPricel;
@property(nonatomic,strong)NSString *strUnitType;

//AccountDetail
@property(nonatomic,strong)NSString *accountNumberStr;
@property(nonatomic,strong)NSString *UniqueIdStr;
@property(nonatomic,strong)NSString *orderNumberStr;
@property(nonatomic,strong)NSString *checkRResultStr;

//Payment Method
@property(nonatomic,strong)NSString *accountNumStr;
@property(nonatomic,strong)NSString *accountType;
@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *paymentAmount;
@property(nonatomic,strong)NSString *addedTime;

@property(nonatomic,strong)NSString *accountPrimary;
@property(nonatomic,strong)NSString *expiryDate;
@property(nonatomic,strong)NSString *accountStatus;
@property(nonatomic,strong)NSString *accountVerificationStatus;


//CustomLocation
@property(nonatomic,strong)NSString *customLatiValueStr;
@property(nonatomic,strong)NSString *customLongiValueStr;
@property(nonatomic,strong)NSString *customStateAbbriviation;
@property(nonatomic,strong)NSString *stateAbbriviation;
@property(nonatomic,strong)NSString *countryCodeStr;
@property(nonatomic,strong)NSString *countryCodeIDStr;
@property(nonatomic,strong)NSString *bankAccountType;

//Cancel Date
@property(nonatomic,strong)NSString *cancelDatevalue;
@property(nonatomic,strong)NSString *cancelDateID;
@property(assign)BOOL isDateCancel;


///GoogleMap Loaction
@property(nonatomic,strong)NSString *meetUpLatitude;
@property(nonatomic,strong)NSString *meetUpLongitude;

+(NSMutableArray *)parseCancelDateDetails: (NSArray *)response;
+(BOOL)emailValidation:(NSString *)email;
+(NSMutableArray *)parseDateForLocation: (NSArray *)response;
+(NSMutableArray *)parseDateForPayment: (NSArray *)response;
+(NSMutableArray *)parseImageArrayForSelection: (NSArray *)response;
+(NSMutableArray *)parseAutocompleteResponse:(NSDictionary*)responseDict andError:(NSError*)error;

@end
