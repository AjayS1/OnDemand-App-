//
//  Define.h
//

#ifndef Define_h
#define Define_h
#define NSLog if(1) NSLog

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define BaseUrl @"www.google.com"
#define BaseServerUrl @"http://www.ondemandapi.flexsin.in/API/"

//#define NewBaseServerUrl @"http://ondemandapinew.flexsin.in/API/"
//#define NewBaseQAServerUrl @"http://ondemandapinew.flexsin.in/API/"

//#define NewBaseQAServerUrl @"http://ondemandapiqa.flexsin.in/API/"
//#define NewBaseServerUrl @"http://ondemandapiqa.flexsin.in/API/"
//#define SignalRBaseUrl @"http://ondemandapiqa.flexsin.in/signalr/hubs"
//http://doumeesApi.flexsin.in

//Development Base url
//#define NewBaseQAServerUrl @"http://doumeesApi.flexsin.in/API/"
//#define NewBaseServerUrl     @"http://doumeesApi.flexsin.in/API/"
//#define SignalRBaseUrl          @"http://doumeesApi.flexsin.in/signalr/hubs"

//Client Staging Base Url
#define NewBaseQAServerUrl @"https://api.doumees.com/API/"
#define NewBaseServerUrl     @"https://api.doumees.com/API/"
#define SignalRBaseUrl          @"https://api.doumees.com/signalr/hubs"

#define AppName                  @"AppName"
#define APIAccountLogin        @"Account/AccountLoginNew"
#define APIContractorSearch  @"Contractor/ContractorSearch"
#define APIFavouriteUserList  @"Account/ListFavourite"
#define APIBlockUserList        @"Account/ListBlock"
#define APIAlertList               @"Account/ListFavourite"
#define APIAccountUserInfo   @"Account/UserInfo"
#define APIGetCurrentTimeZone  @"Account/UserGettimeZone"
#define APIAccountProfileInfo      @"Account/UserProfileInfo"
#define APIAccountSignout          @"Account/AccountSignOut"
#define APIUserHeightConversion @"Account/ChangeProfile"
#define APIUserAttribute              @"Account/GetUserAttributeData"
#define APIGetPushnotificationSettings       @"Account/ListNotification"
#define APIUpdatePushnotificationSettings  @"Account/UpdateMobileNotification"
#define APIEmailNotificationSettings           @"Account/ListNotification"
#define APIUpdateEmailNotificationSettings @"Account/UpdateEmailNotification"
#define APIAddCreditCard                          @"Account/AddCreditCard"
#define APIPaynowCreditCardVerify             @"Customer/VerifyCreditDelinePayment"
#define APIVerifyCreditCardApiCall              @"Account/VerifyCard"

#define APIChangeEmail             @"Account/ChangeEmail"
#define APIEmailCodeVerify         @"Account/VerifyEmail"
#define APIUpdatePassword         @"Account/ChangePassword"
#define APIUserAccountClosed      @"Account/AccountClose"
#define APIUpdateMobileNumber  @"Account/ChangeMobile"
#define APIVerifyMobileNumber    @"Account/VerifyMobile"
#define APIGetVerifyUserInfo       @"Account/GetVerifiedItem"
#define APIGetUserListPhoto        @"Account/ListUserPictures"
#define APIGetPrivacyTermsCondition @"Account/GetPageData"
#define APIGetGenderInterest      @"Account/GetPageData"
#define APIUpdateGenderInterest @"Account/ChangeProfile"
#define APIDeleteFavourite           @"Account/ChangeProfile"
#define APISendInvitation             @"Customer/SendInvitation"
#define APIUpdateProfileData        @"Account/GetMasterData"

#define APIUpdateProfileDataForSearch                  @"Account/GetMasterHeight"
#define APIChangeProfileData                                @"Account/ChangeProfile"
#define APIAddBankAccountDetail                          @"Account/AddBankDetail"
#define APIAddBankAccountDetailForNonSufficient   @"Contractor/AddBankWithPayment"

#define APIDateList            @"Account/DateList"
#define APIDateDetailsPast @"Account/PastDateDetail"
#define APIGetDateDetails  @"Account/GetDateDetail"
#define APIGetAllUserMessageList     @"Account/GetAllMessage"
#define APIGetMessagebyUser          @"Account/GetMessagebyUser"
#define APISendMessage                  @"Account/SendMessage"
#define APIGetListNotification           @"Account/ListNotification"
#define APIGetListNotificationDetails @"Account/ListNotificationDetailByType"
#define APIReadNotificationApiCall    @"Account/ReadNotification"
#define APIVerifyMobileNumber        @"Account/VerifyMobile"
#define APIDateRequestDetails         @"Contractor/RequestContractorProfileData"
#define APIContractorChangeProfileShownStatus @"Contractor/ContractorChangeProfileShownStatus"
#define APIGetPaymentMethodList    @"Account/ListUserPaymentMethod"
#define APIGetBucketDetail              @"Account/GetBucketDetail"
#define APISetPrimaryAccount          @"Account/PaymentMethodPrimary"
#define APIDeletePaymentAccount    @"Account/DeletePaymentMethod"
#define APIAddBlcokUser @"Account/BlockUser"
#define APIContarctorSchedulingallDay @"Contractor/ContractorSchedulingAllDay"
#define APIContarctorSchedulingList @"Contractor/ContractorSchedulingList"
#define APIUpdateContarctorSchedulingList @"Contractor/ContractorScheduling"
#define APIDateIssueList @"Account/GetMasterData"
#define APIDateDecline @"Contractor/DeclineDate"
#define APIDateAccept @"Contractor/AcceptDate"
#define APIDateCancel @"Contractor/CanceleDate"
#define APIPayNowPaymentCall @"Customer/AddCreditCardwithPayment"

#define APIDateOnTheWay @"Contractor/OntheWay"
#define APIDeletePaymentMethodApiCall @"Account/DeletePaymentMethod"
#define APIGetCancelFee @"Account/GetCancellationFee"
#define APITryAgainApiCall @"Contractor/TryAgainNonSufficientFund"
#define APISetPrimaryPaymentMethodApiCall @"Account/PaymentMethodPrimary"
#define APIBackgroundVerificationApiCall @"account/CheckR"
#define APIDateDetailsPast @"Account/PastDateDetail"
#define APIGetDateDetails @"Account/GetDateDetail"
#define APISubmitPaymentAfterDateCompltedApiCall @"Customer/SubmitConfirmationCode"
#define APIGetPaymentCopnfirmationCode @"Contractor/GetPaymentCopnfirmationCode"
#define APISubmitPaymentReceivedYesOrNo @"Contractor/IsPaymentReceived"
#define APISubmitDateRateApiCall @"Account/RateDate"
#define APIDateCompletedSubmitIssueApiCall @"Account/SubmitIssue"
#define APIDateConfirmedArrived @"Contractor/ConfirmedArrived"
#define APIStartDate                                    @"Contractor/StartDate"
#define APIEndDate                                    @"Contractor/EndDate"
#define APIDeleteUserPhoto                         @"Account/DeleteUserPicture"
#define APISetPrimaryPhoto                         @"Account/UserPicturePrimary"
#define APIUploadPhoto                               @"ImgaeUploader/Post"
#define APITabBarMessageCountApiCall         @"Account/GetMessageDateCounter"
#define APIUserLocationUpdateApiCall           @"Account/UpdateUserLocation"
#define APIBankAccountVerificationApiCall     @"Account/VerifiedBankDetail"
#define APIPrefernceData                             @"Contractor/GetPrefrencesItem"
#define APIPrefernceChangeProfileData         @"Account/ChangeProfile"
#define APIPrefernceChangeLocationData      @"Account/ChangeCurrentLocation"
#define APIPrefernceUpdatepayment             @"Contractor/UpdatePaymentMethod"
#define APIPrefernceGetpayment                  @"Contractor/GetPaymentMethod"
#define APIPrefernceGetDistance                  @"Account/GetMasterData"
#define APIReportUser                                 @"Account/ReportUser"
#define APIListNotificationDetailByTypeCall    @"Account/ListNotificationDetailByType"
#define APIDeleteNotificationApiCall              @"Account/ListNotificationDeletebyNotificationID"
#define APIUnBlockUser                                @"Account/UnBlockUser"
#define APIGetBackgroutLogoutDeviceIdCall  @"Account/GetBackgroutLogoutDeviceID"
#define APIDeleteMessage                            @"Account/DeletMessage"

//--2. TextField Section--*****************************************************
#define KTextFieldPlaceholderColor    [UIColor grayColor]
#define KLightFontStyle           @"Helvetica-Light"
#define KBoldFontStyle            @"Helvetica-Semibold"
#define KMediumFontStyle          @"Helvetica-Regular"


#endif /* Define_h */
