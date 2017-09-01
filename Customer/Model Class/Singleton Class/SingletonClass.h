//
//  AppDelegate.m
//  Customer
//
//  Created by Jamshed Ali on 01/06/16.
//  Copyright © 2016 Jamshed Ali. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NullChecker.h"
#import <CoreLocation/CoreLocation.h>
#import "PlaceObj.h"

typedef void(^myCompletion)(BOOL);
@interface SingletonClass : NSObject


@property (nonatomic,strong) NSURLConnection *connection;
+(SingletonClass*)sharedInstance;

@property(nonatomic,strong)NSString *appVersionNumber;
@property(nonatomic,strong)NSString *appCurrentVersionNumber;
@property(assign)BOOL IsSwitchShow;
@property(assign)BOOL IsDistanceFilter;
@property(assign)BOOL IsCropPhotoDirect;
@property (nonatomic,strong) NSString *requestTypeStr;
@property (nonatomic,assign) BOOL isEmailVerifiedAlreadyOrNot;

@property(nonatomic,strong)NSString *imagePopupCondition;
@property(nonatomic,strong)NSString *CancelReasonID;

@property(nonatomic,strong)NSString *imagePhotoIsPrimary;
@property(nonatomic,strong)NSString *tipAmountValue;
@property(nonatomic,strong)NSString *tipAmountPercentage;
@property(nonatomic,strong)NSString *tipAmountWithTotalAmount;
@property(nonatomic,strong)NSString *customAddress;
@property (nonatomic,assign) BOOL isFromCaneclDateByCustomer;

@property(nonatomic,strong)NSString *otherDateType;
@property(nonatomic,strong)NSString *otherDateTypeID;

@property (strong, nonatomic) NSMutableArray *messagessDataMArray;
@property(nonatomic,strong)NSString *recipientIdStr;
@property(nonatomic,strong)NSString *userNameStr;
@property(nonatomic,strong)NSString *userImageUrlStr;
@property(nonatomic,strong)NSString *dateIdStr;
@property(nonatomic,strong)NSString *recipientNameStr;
@property(nonatomic,assign)BOOL isFromReportSubmit;

@property(nonatomic,strong)NSString *deviceToken;
@property(nonatomic,strong)NSString *dateEndMessageDisableStr;
@property(nonatomic,strong)NSString *requestEndDateButton;

@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *firstNameStr;
@property(nonatomic,strong)NSString *lastNameStr;
@property(nonatomic,strong)NSString *isEditStr;
@property(nonatomic,strong)NSString *interestedGender;
@property(nonatomic,strong)NSString *mobileNumberStr;
@property(nonatomic,strong)NSString *isOnlineFiltering;

@property(nonatomic,strong)NSString *latiValueStr;
@property(nonatomic,strong)NSString *longiValueStr;
@property(nonatomic,strong)NSString *customLattitudeValueStr;
@property(nonatomic,strong)NSString *customLongitudeValueStr;
@property(nonatomic,strong)NSString *requestLattitudeValueStr;
@property(nonatomic,strong)NSString *requestLongtitudeValueStr;

@property(nonatomic,strong)NSString *customLatiValueStr;
@property(nonatomic,strong)NSString *customLongiValueStr;
@property(nonatomic,strong)NSString *refreshApiCallOrNotStr;
@property(nonatomic,strong)NSString *ipAddressStr;
@property(nonatomic,strong)NSString *currentLocationStr;
@property(nonatomic,strong)NSString *strChooseLocationName;
@property(nonatomic,strong)NSString *promoCodeValue;
@property(nonatomic,strong)NSString *strToBeSearch;

@property(assign,nonatomic) BOOL locationShareYesOrNO;
@property(assign,nonatomic) BOOL checkBaseUrl;
@property(assign,nonatomic) BOOL checkLocationStr;
@property(assign,nonatomic) BOOL checkLocationAutoOrGPS;
@property(assign,nonatomic) BOOL switchSelctedForindexPath;
@property(assign,nonatomic) BOOL checkisSearchAllOverTheArea;
@property(assign,nonatomic) BOOL checkisSearchAllOverTheAreaValue;
@property(assign,nonatomic) BOOL heightSliderValue;
@property(assign,nonatomic) BOOL checkChateIsActive;

@property(nonatomic,strong)NSString *cityValueStr;
@property(nonatomic,strong)NSString *countryValueStr;
@property(nonatomic,strong)NSString *countryCodeStr;
@property(nonatomic,strong)NSString *countryCodeIDStr;

@property(nonatomic,strong)NSString *stateValueStr;
@property(nonatomic,strong)NSString *zipValueStr;
@property(nonatomic,strong)NSString *zipCodeValueStr;
@property (nonatomic,strong) PlaceObj *sharedObject;
@property(nonatomic,strong)NSString *districtValueStr;
@property(nonatomic,strong)NSString *locationValueStr;
@property(nonatomic,strong)NSString *currentAddressStr;


@property(nonatomic,strong)NSString *dateStatusValue;
@property(nonatomic,strong)NSString *addressValueWhileCancelTheDate;
@property(nonatomic,strong)NSString *latValueWhileCancelTheDate;
@property(nonatomic,strong)NSString *longValueWhileCancelTheDate;
@property(nonatomic,strong)NSString *IsCancellationFeeAllowed;
@property(nonatomic,strong)NSString *cancellationFee;

//Build & Version Value
@property(nonatomic,strong)NSString *strBuildValue;
@property(nonatomic,strong)NSString *strVersionValue;
@property(nonatomic,strong)NSString *strUnityTypeValue;
@property(nonatomic,strong)NSString *isPastDuePayment;

// Filter : Location
@property(nonatomic,strong)NSString *CustomZipStr;
@property(nonatomic,strong)NSString *selectedAddressStr;
@property(nonatomic,strong)NSString *customAddressStr;
@property(nonatomic,strong)NSString *selectedAddressLatitudeStr;
@property(nonatomic,strong)NSString *selectedAddressLongitudeStr;
@property(nonatomic,strong)NSString *selectedAddressAutoComplete;
@property(nonatomic,strong)NSString *selectedAddressAutoCompleteValue;
@property(nonatomic,strong)NSString *distanceStr;
@property(nonatomic,strong)NSString *distanceIntegerStr;
@property(nonatomic,strong)NSString *selectedStartAgeStr;
@property(nonatomic,strong)NSString *selectedEndAgeStr;
@property(nonatomic,strong)NSString *selectedStartWeightStr;
@property(nonatomic,strong)NSString *selectedEndWeightStr;
@property(nonatomic,strong)NSString *selectedStartHeightStr;
@property(nonatomic,strong)NSString *selectedStartHeightFoot;
@property(nonatomic,strong)NSString *selectedEndHeightFoot;
@property(nonatomic,strong)NSString *selectedEndHeightStr;
@property(nonatomic,strong)NSString *weightSliderStr;
@property(nonatomic,strong)NSString *heightSliderStr;

@property (nonatomic, strong) CLGeocoder* geocoder;
@property(nonatomic,strong)NSString *strModelTypeName;
@property(nonatomic,strong)NSString *languageSelectedName;
@property(nonatomic,strong)NSDictionary *dictBodyType;
@property(nonatomic,strong)NSDictionary *dictForTypeDataValue;
@property(nonatomic,strong)NSDictionary *dictForEthnicityValue;
@property(nonatomic,strong)NSDictionary *dictForEyeColorValue;
@property(nonatomic,strong)NSDictionary *dictForHairValue;
@property(nonatomic,strong)NSDictionary *dictForEducationValue;
@property(nonatomic,strong)NSDictionary *dictForSmokingValue;
@property(nonatomic,strong)NSDictionary *dictForDrinkingValue;
@property(nonatomic,strong)NSDictionary *dictForLanguageValue;

//Filter Section String Value

@property(nonatomic,strong)NSString *strContractorTypeFilter;
@property(nonatomic,strong)NSString *strContractorBodyTypeFilter;
@property(nonatomic,strong)NSString *strContractorEthencityTypeFilter;
@property(nonatomic,strong)NSString *strContractorEyeColorTypeFilter;
@property(nonatomic,strong)NSString *strContractorHairColorTypeFilter;
@property(nonatomic,strong)NSString *strContractorSmokingTypeFilter;
@property(nonatomic,strong)NSString *strContractorDrinkingTypeFilter;
@property(nonatomic,strong)NSString *strContractorEducationTypeFilter;
@property(nonatomic,strong)NSString *strContractorLanguageTypeFilter;

//Object For PushNotification
@property(nonatomic,strong)NSString *strEventType;
@property(nonatomic,strong)NSString *strIsEmailNotification;
@property(nonatomic,strong)NSString *strIsMobileNotification;
@property(assign,nonatomic) BOOL  strIsSelectedNotification;
@property(nonatomic,strong)NSString *countryID;
@property(nonatomic,strong)NSString *countryName;
@property(nonatomic,strong)NSString *cityID;
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,strong)NSString *cstateID;
@property(nonatomic,strong)NSString *stateName;

//Custom Loctaion
@property(nonatomic,strong)NSString *locationID;
@property(nonatomic,strong)NSString *locationName;
@property(nonatomic,strong)NSString *placeID;
@property(nonatomic,strong)NSString *locationAddress;
@property(strong, nonatomic)NSString *discription;
@property(nonatomic,strong)NSString *meetUpLatitude;
@property(strong, nonatomic)NSString *meetUpLongitude;

//parse data for Filter Type
@property(nonatomic,strong)NSString *filterType;
@property(nonatomic,strong)NSString *filterTypeID;
@property(assign,nonatomic) BOOL checkFilterTypeValue;
@property(assign,nonatomic) BOOL checkUnityType;

//Card Details
@property(nonatomic,strong)NSString *productID;
@property(nonatomic,strong)NSString *productDescription;
@property(nonatomic,strong)NSString *productQty;
@property(nonatomic,strong)NSString *productPrice;
@property(nonatomic,strong)NSString *productTotal;
@property(nonatomic,strong)NSString *productPriceValue;
@property(nonatomic,strong)NSString *productTotalValue;
@property(nonatomic,strong)NSString *productCardName;
@property(nonatomic,strong)NSString *productTotalPricel;
//AccountDetail
@property(nonatomic,strong)NSString *accountNumberStr;
@property(nonatomic,strong)NSString *UniqueIdStr;
@property(nonatomic,strong)NSString *orderNumberStr;
@property(nonatomic,strong)NSString *checkRResultStr;
//Payment Method
@property(nonatomic,strong)NSString *accountNumStr;
@property(nonatomic,strong)NSString *accountType;
@property(nonatomic,strong)NSString *bankAccountID;

@property(nonatomic,strong)NSString *bankName;
@property(nonatomic,strong)NSString *paymentAmount;
@property(nonatomic,strong)NSString *accountPrimary;
@property(nonatomic,strong)NSString *expiryDate;
@property(nonatomic,strong)NSString *accountStatus;
@property(nonatomic,strong)NSString *accountVerifyStatus;
@property(nonatomic,strong)NSString *VerifyId;
//Date List
@property(nonatomic,strong)NSString *dateID;
@property(nonatomic,strong)NSString *dateStatusType;
@property(nonatomic,strong)NSString *dateType;
@property(nonatomic,strong)NSString *dateLocation;

@property(nonatomic,strong)NSString *dateName;
@property(nonatomic,strong)NSString *datePicture;
@property(nonatomic,strong)NSString *dateRequestTime;
@property(nonatomic,strong)NSString *dateReserveTime;
@property(nonatomic,strong)NSString *statusTypeOfDate;
@property(nonatomic,strong)NSString *dateRequestType;
@property(nonatomic,strong)NSString *isContractorRead;
@property(nonatomic,strong)NSString *isCustomerRead;
@property(nonatomic,strong)NSString *upComingDateListStatusCode;
@property(nonatomic,strong)NSString *upComingDateListHistoryStatusCode;
@property(nonatomic,strong)NSString *pendingDateListStatusCode;
@property(nonatomic,strong)NSString *progressDateListStatusCode;
@property(nonatomic,strong)NSString *meetUpLocationLattitude;
@property(nonatomic,strong)NSString *meetUpLocationLongtitude;

//Cancel Date
@property(nonatomic,strong)NSString *cancelDatevalue;
@property(nonatomic,strong)NSString *cancelDateID;
@property(assign) BOOL isDateCancel;

//Custome Location
@property(nonatomic,strong)NSString *customLocationValue;
@property(nonatomic,strong)NSString *customeCountryValue;
@property(nonatomic,strong)NSString *customeAddressValue;
@property(nonatomic,strong)NSString *customeCityValue;
@property(nonatomic,strong)NSString *customeStateValue;
@property(nonatomic,strong)NSString *customeZipCodeValue;
@property(nonatomic,strong)NSMutableArray *placeDetailsArray;

@property(assign,nonatomic) BOOL isFromMessageDetails;
@property(assign,nonatomic) BOOL isFromCancelDateRequest;
@property(assign,nonatomic) BOOL isUserLogoutManualyy;
@property(assign,nonatomic) BOOL isUserLoginManualyy;


+(NSMutableArray *)parseAutocompleteResponse:(NSDictionary*)responseDict andError:(NSError*)error;
+(NSMutableArray *)parselocationFromCustomData: (NSArray *)response;
+(NSMutableArray *)parseCancelDateDetails: (NSArray *)response;
+(NSMutableArray *)getSearchInfoFromDict:(id)array;
+(NSMutableArray *)parselocationFromGoogleData: (NSArray *)response;
+(NSString *)getAddressFromLatLon:(double)pdblLatitude withLongitude:(double)pdblLongitude;
+(NSMutableArray *)parselocationData: (NSArray *)response;
+(NSMutableArray *)parseDateForLocation: (NSArray *)response;
+(NSMutableArray *)parseDateForFilterType: (NSArray *)response;
+(NSMutableArray *)parseDateForPayment: (NSArray *)response;
+(NSMutableArray *)parseDateForDateArray: (NSArray *)response;
+(NSMutableArray *)parselocationFromCustomCountry: (NSArray *)response;
-(void)callSearchService:(NSString*)placeName;
-(void)callGetDetailForPlaceID:(NSString*)pladeID;
+(PlaceObj *)parsePlaceDetailResponse:(NSDictionary*)responseDict andError:(NSError*)error;
+(BOOL)emailValidation:(NSString *)email;
+(NSMutableArray *)parseDateForPaymentVerified: (NSArray *)response;
@end
