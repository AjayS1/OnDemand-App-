//
//  Define.h
//

#ifndef Define_h
#define Define_h

#define NSLog if(1) NSLog
//if you dont want log set 1 as 0.

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define BaseUrl @"www.google.com"
#define BaseServerUrl @"http://www.ondemandapi.flexsin.in/API/"

//#define NewBaseServerUrl @"http://ondemandapinew.flexsin.in/API/"
//#define NewBaseQAServerUrl @"http://ondemandapinew.flexsin.in/API/"
//#define SignalRBaseUrl @"http://ondemandapiqa.flexsin.in/signalr/hubs"
//
//#define NewBaseServerUrl @"http://ondemandapiqa.flexsin.in/API/"
//#define NewBaseQAServerUrl @"http://ondemandapiqa.flexsin.in/API/"

//Development base URls
//#define SignalRBaseUrl @"http://doumeesApi.flexsin.in/signalr/hubs"
//#define NewBaseServerUrl @"http://doumeesApi.flexsin.in/API/"
//#define NewBaseQAServerUrl @"http://doumeesApi.flexsin.in/API/"

//Staging base URls
#define SignalRBaseUrl @"https://api.doumees.com/signalr/hubs"
#define NewBaseServerUrl @"https://api.doumees.com/API/"
#define NewBaseQAServerUrl @"https://api.doumees.com/API/"


//api.doumees.com

 #define AppName @"AppName"
#define APIForgotPassword @"http://ondemandapinew.flexsin.in/ForgetPassword/Index"
#define APIAccountLogin @"Account/AccountLoginNew"
#define APIContractorSearch @"Contractor/ContractorSearch"
#define APIRequestNow @"Customer/SendDateRequest"
#define APIAddCreditCard @"Account/AddCreditCard"
#define APIReserveRequest @"Customer/ReserveRequest"
#define APIFavouriteUserList @"Account/ListFavourite"
#define APIAlertList @"Account/ListFavourite"
#define APIAccountUserInfo @"Account/UserInfo"
#define APIAccountContactUs @"Account/Contactus"

#define APIAccountProfileInfo @"Account/UserProfileInfo"
#define APIAccountSignout @"Account/AccountSignOut"
#define APIUserHeightConversion @"Account/ChangeProfile"
#define APIUserAttribute @"Account/GetUserAttributeData"
#define APIGetPushnotificationSettings @"Account/ListNotification"
#define APIUpdatePushnotificationSettings @"Account/UpdateMobileNotification"
#define APIEmailNotificationSettings @"Account/ListNotification"
#define APIUpdateEmailNotificationSettings @"Account/UpdateEmailNotification"
#define APIChangeEmail @"Account/ChangeEmail"
#define APIEmailCodeVerify @"Account/VerifyEmail"
#define APIUpdatePassword @"Account/ChangePassword"
#define APIUserAccountClosed @"Account/AccountClose"
#define APIUpdateMobileNumber @"Account/ChangeMobile"
#define APIVerifyMobileNumber @"Account/VerifyMobile"
#define APIGetVerifyUserInfo @"Account/GetVerifiedItem"
#define APIGetUserListPhoto @"Account/ListUserPictures"
#define APIGetPrivacyTermsCondition @"Account/GetPageData"
#define APIGetGenderInterest @"Account/GetPageData"
#define APIUpdateGenderInterest @"Account/ChangeProfile"
#define APIDeleteFavourite @"Account/ChangeProfile"
#define APISendInvitation @"Customer/SendInvitation"
#define APIUpdateProfileData @"Account/GetMasterData"
#define APIUpdateProfileDataForSearch @"Account/GetMasterHeight"
#define APIChangeProfileData @"Account/ChangeProfile"
#define APIAddBanckAccountDetail @"Account/AddBankDetail"
#define APIDateList @"Account/DateList"
#define APIDateDetails @"Account/PastDateDetail"
#define APIGetAllUserMessageList @"Account/GetAllMessage"
#define APIGetMessagebyUser @"Account/GetMessagebyUser"
#define APISendMessage @"Account/SendMessage"
#define APIGetListNotification @"Account/ListNotification"
#define APIGetBucketDetail @"Account/GetBucketDetail"
#define APIGetPaymentMethodList @"Account/ListUserPaymentMethod"
#define APIGetPaymentMethodVerifiedList @"Account/ListUserVerifiedPaymentMethod"
#define APPayPaymentMethodVerified @"Account/PayNowCustomer"
#define APIChargeBackAmount @"Customer/ChargeBackEmail"
#define APIRequestToEndDateByCustomer @"Customer/RequestToEndDate"

//
#define APISearchContractorProfile @"Contractor/SearchContractorProfile"
#define APIGetContractorAvailableTimeSlot @"Contractor/GetAvailableTime"
#define APIDeleteUserPhoto @"Account/DeleteUserPicture"
#define APISetPrimaryPhoto @"Account/UserPicturePrimary"
#define APIUploadPhoto @"ImgaeUploader/Post"
#define APIDeleteFavouriteUser @"Account/DeleteFromFavourite"
#define APIAddFavouriteUser @"Account/AddFavourite"
#define APIGetDateDetails @"Account/GetDateDetail"
#define APIDateDetailsPast @"Account/PastDateDetail"

#define APIDateIssueList @"Account/GetMasterData"
#define APIDeclineDate @"Customer/DeclineDate"
#define APICheckDateRequestAcceptOrNot @"Customer/AutoDeclineDate"
#define APIGetPaymentCopnfirmationCode @"Contractor/GetPaymentCopnfirmationCode"
#define  APISendSignalRRequest   @"Customer/signalrDateRequest"

#define APIDateCancel @"Contractor/CanceleDate"
#define APIGetCancelFee @"Account/GetCancellationFee"
#define APICancelDate @"Customer/CanceleDate"
#define APICancelDateWithPayment @"Contractor/CanceleDate"

#define APIPastDueDate @"Customer/PastDueDate"

#define APIDeleteMessage @"Account/DeletMessage"

#define APIAddContractorInAlertList @"Customer/AddAlert"
#define APIContractorAlertList @"Customer/ListAlert"
#define APIContractorDeleteFormAlertList @"Customer/DeleteFromAlert"
#define APITabBarMessageCountApiCall @"Account/GetMessageDateCounter"

#define APIReadNotificationApiCall @"Account/ReadNotification"
#define APIDeleteNotificationApiCall @"Account/ListNotificationDeletebyNotificationID"

#define APIVerifyCreditCardApiCall @"Account/VerifyCard"
#define APIPaynowCreditCardVerify @"Customer/VerifyCreditDelinePayment"
#define APIDeletePaymentMethodApiCall @"Account/DeletePaymentMethod"
#define APISetPrimaryPaymentMethodApiCall @"Account/PaymentMethodPrimary"

#define APIGetRewardApiCall @"Customer/GetReward"
#define APIReportContractorApiCall @"Account/ReportUser"
#define APIUserLocationUpdateApiCall @"Account/UpdateUserLocation"

#define APIDateCompletedSubmitIssueApiCall @"Account/SubmitIssue"
#define APIBankAccountVerificationApiCall @"Account/VerifiedBankDetail"
#define APISubmitPaymentAfterDateCompltedApiCall @"Customer/SubmitConfirmationCode"
#define APISubmitPaymentAfterDateCompleted @"Customer/DatePayment"

#define APIDonotReceiveCodeApiCall @"Customer/DontReceivePaymentConfirmationCode"
#define APIBackgroundVerificationApiCall @"account/CheckR"

#define APISubmitDateRateApiCall @"Account/RateDate"

#define APIListNotificationDetailByTypeCall @"Account/ListNotificationDetailByType"

#define APIPastDuePaymentCall @"Account/MadePayment"
#define APIPayNowPaymentCall @"Customer/AddCreditCardwithPayment"

#define APIGetBackgroutLogoutDeviceIdCall @"Account/GetBackgroutLogoutDeviceID"

#define APIAddCustomLocationCall @"Customer/AddCustomLocation"
#define APIGetCustomLocationCall @"Customer/ListCustomLocation"
#define APIGetCountryCall @"Account/GetCountryStateCity"

#define APIDeleteCustomLocationCall @"Customer/DeleteCustomLocation"
#define APIAddPromoCodeCall @"Customer/EntrePromoCode"


//http://ondemandapinew.flexsin.in/API/Customer/DeleteCustomLocation?userID=Cu009fe53&locationID=2
//--2. TextField Section--*****************************************************
#define KTextFieldPlaceholderColor    [UIColor grayColor]
#define KLightFontStyle           @"Helvetica-Light"
#define KBoldFontStyle            @"Helvetica-Semibold"
#define KMediumFontStyle          @"Helvetica-Regular"


//  Signout http://ondemandapi.flexsin.in/API/Account/AccountSignOut?userID=Cr0056dbb&deviceID=Sys001
//  Update Push Notification Settings http://ondemandapi.flexsin.in/API/Account/UpdateMobileNotification
//  Update Email Notification Settings http://ondemandapi.flexsin.in/API/Account/UpdateEmailNotification
//  Get Email Settinngs http://ondemandapi.flexsin.in/API/Account/ListNotification?userID=Cu009fe53&NotificationType=listEmailNotification

//  Update Email		http://ondemandapi.flexsin.in/API/Account/ChangeEmail?userID=Cr0056dbb&Email=gaurav_arya@seologistics.com&userName=saurabh
//  Email Code Verifyhttp://ondemandapi.flexsin.in/API/Account/VerifyEmail?userID=Cr0056dbb&VerificationCode=SxhVW85627712

//  Change Password  http://ondemandapi.flexsin.in/API/Account/ChangePassword?userID=Cr0056dbb&previousPassword=123456&newPassword=123456
//  Account Closed  http://ondemandapi.flexsin.in/API/Account/AccountClose?userID=Cu00bc389&UserBy=Cr0056dbb&userComment=test

//  Update Mobile Number http://ondemandapi.flexsin.in/API/Account/ChangeMobile?userID=Cr0056dbb&MobileNumber=9711954520
//  Verify mobile http://ondemandapi.flexsin.in/API/Account/VerifyMobile?userID=Cr0056dbb&verificationCodeMobile=9942

//  Get User Verified   http://ondemandapi.flexsin.in/API/Account/GetVerifiedItem?userID=Cu009fe53

//  Terms Condition http://ondemandapi.flexsin.in/API/Account/GetPageData?PageName=Terms of Service
//  Privacy Policy http://ondemandapi.flexsin.in/API/Account/GetPageData?PageName=Privacy Policy

//  Account Gender Interest Change  http://ondemandapi.flexsin.in/API/Account/ChangeProfile?userID=Cu009fe53&attributeType=InterestedIn&attributeValue=1

//  Delete Favourite  http://ondemandapi.flexsin.in/API/Account/DeleteFromFavourite?userIDTO=Cr00a827c&userIDFrom=Cr0056dbb

//  Send Invitation http://ondemandapi.flexsin.in/API/Customer/SendInvitation

//  Date List http://ondemandapi.flexsin.in/API/Account/DateList?userID=Cu009fe53

//  Date Details  http://ondemandapi.flexsin.in/API/Account/PastDateDetail?userID=Cu009fe53&userType=1&DateID=Date7&DateType=1

//  Get All Message User Listing  http://ondemandapi.flexsin.in/API/Account/GetAllMessage?CustomerID=Cu009fe53&ContractorID=Cu00e2618&UserType=1

//  Get All Message by User Send http://ondemandapi.flexsin.in/API/Account/GetMessagebyUser?CustomerID=Cu009fe53&ContractorID=Cu00e2618&UserType=1

//  Send One to One Message  http://ondemandapi.flexsin.in/API/Account/SendMessage?CustomerID=Cu009fe53&ContractorID=Cu00e2618&Message=test&UserType=1

//  Get Notification List http://ondemandapi.flexsin.in/API/Account/ListNotification?userID=Cu009fe53

//  Get Payment Method List  http://ondemandapi.flexsin.in/api/account/ListUserPaymentMethod?userID=Cu0055c6f1

//  Get Contractor Available Time Slot http://ondemandapi.flexsin.in/API/Contractor/GetAvailableTime?userID=Cu00e2618&dateTime=2016-07-13 16:29:43.290

//  Delete User photo http://ondemandapi.flexsin.in/API/Account/DeleteUserPicture

//  Set Primary Photo http://ondemandapi.flexsin.in/API/Account/UserPicturePrimary?userID=Cu009fe53&picID=3&isPrimary


// Upload Photo http://ondemandapp.flexsin.in/api/ImgaeUploader/Post	UserID,isPrimary, PicName

//  Delete Favourite User  http://ondemandapi.flexsin.in/API/Account/DeleteFromFavourite?userIDTO=Cr00a827c&userIDFrom=Cr0056dbb

//  Add Favourite User http://ondemandapi.flexsin.in/API/Account/AddFavourite?userIDTO=Cu005c6f2&userIDFrom=Cr0056dbb


//  Get Date Details http://ondemandapi.flexsin.in/API/Account/GetDateDetail?userType=1&DateID=Date17&DateType=1
//  Forgot Password  http://ondemandapp.flexsin.in/ForgetPassword/Index

//  Date Issue List "http://ondemandapi.flexsin.in/API/Account/GetMasterData?AttributeName=MasterReasonForDeclinesContractorEnd";

//  Decline Date http://ondemandapi.flexsin.in/api/Customer/DeclineDate?userID=Cr00a827c&DateID=Date17

//  Check Date Request Accept Or Not  http://ondemandapi.flexsin.in/API/Customer/AutoDeclineDate?userID=Cu0020c42&DateID=Date197922

//  Add Contractor in Alert List http://ondemandapi.flexsin.in/API/Customer/AddAlert?CustomerID=Cu009fe53&ContractorID=Cr00a827c

//  Contractor Alert List Url :http://ondemandapi.flexsin.in/API/Customer/ListAlert?CustomerID=Cu009fe53


//  Contractor Delete Form Alert List  Url: http://ondemandapi.flexsin.in/API/Customer/DeleteFromAlert?CustomerID=Cu009fe53&ContractorID=Cr0070b79

//  Tab Bar Message Count Api Call http://ondemandapi.flexsin.in/API/Account/GetMessageDateCounter?UserID=Cr00a90a0&userType=1


//  Read Notfication Api Call http://ondemandapi.flexsin.in/API/Account/ReadNotification?userID=Cu009fe53&TypeID=1&MaxID=30

//  Delete Notification  http://ondemandapi.flexsin.in/API/Account/ListNotificationDeletebyNotificationID?userID=Cu009fe53&TypeID=1&ID=23

//  Verify Credit Card http://ondemandapi.flexsin.in/api/Account/VerifyCard?userID=Cu00f2746&cardNumber=4242424242424242&authenticationAmount=51&VerifyID=cus_8gUoiCEqk7qDdg

//  Delete Payment Method http://ondemandapi.flexsin.in/api/account/DeletePaymentMethod?userID=Cu0056532&Number=4242424242424242&Type=credit/Bank

//  Set Primary Method http://ondemandapi.flexsin.in/api/account/PaymentMethodPrimary?userID=Cu0056532&Number=4242424242424242&Type=Bank/Credit

//  Get Reward API Call http://ondemandapi.flexsin.in/API/Customer/GetReward?userID=Cu0020c42

//  Report Contractor http://ondemandapi.flexsin.in/api/Account/ReportUser?CustomerID=Cu009fe53&ContractorID=Cr009ffc5&DateID=&Description=fake picture&Type=1

// User Location Update http://ondemandapi.flexsin.in/API/Account/UpdateUserLocation?userID=Cu005c6f2&latitude=28.648781&longitude=77.315540

// After Date Completed Submit Issue http://ondemandapi.flexsin.in/API/Account/SubmitIssue?userID=Cu009fe53&DateID=Date3&IssueID=1&Notes=test&usertype=2

//  Bank Account Verification Api Call url: ondemandapi.flexsin.in/api/account/VerifiedBankDetail?userID=123&accountNumber=000111111116&amount1=1.00&amount2=1.00

//  Submit Pamyment On Click Date List url : http://ondemandapi.flexsin.in/api/Customer/SubmitConfirmationCode?customerID=Cu009fe53&DateID=Date7&confirmationCode=3769

//  Don't Receive the Code url: http://ondemandapi.flexsin.in/api/Customer/DontReceivePaymentConfirmationCode?customerID=Cu009fe53&DateID=Date7&description=test

// Background Verification Api Call  url : ondemandapi.flexsin.in/api/account/CheckR?userID=Cu00e2618&firstName=Michal&lastName=Jack&SocialSecurityNumber=111-11-2001&AccountNumber=424242424242424211&AccountType=2&VerfyID=cus_8gpwrlbeBS4NTI&PostalCode=90401

// Submit Date Rating  http://ondemandapi.flexsin.in/API/Account/RateDate?DateID=Date197922&Rating=1.5&Comment=test&usertype=1

//  List Notification API Call http://ondemandapi.flexsin.in/API/Account/ListNotificationDetailByType?userID=Cu009fe53&TypeID=1

//  Date Cancel    http://ondemandapi.flexsin.in/api/Customer/CanceleDate?userID=Cr00a827c&DateID=Date4&ReasonID=1

//  Past Due Date http://ondemandapi.flexsin.in/API/Customer/PastDueDate?customerID=Cu0020c42

//  Past Due Payment  http://ondemandapi.flexsin.in/api/Account/MadePayment

//  Delete Message http://ondemandapi.flexsin.in/API/Account/DeletMessage?CustomerID=""&ContractorID=""&UserType=1

// Check User Already Login in the App // http://ondemandapi.flexsin.in/API/Account/GetBackgroutLogoutDeviceID?UserID=Cr009ffc5

// Add Custom http://ondemandapinew.flexsin.in/API/Customer/AddCustomLocation

#endif /* Define_h */
