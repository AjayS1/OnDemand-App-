
#import <UIKit/UIKit.h>

@interface WallTableViewCell : UITableViewCell {
    
    IBOutlet UIImageView *userImageView;
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *dateLbl;
    IBOutlet UILabel *addressLbl;
    IBOutlet UILabel *statusAcceptedLbl;
    IBOutlet UILabel *notificationCountLbl;
}

@property (strong, nonatomic) IBOutlet UIImageView *userImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (strong, nonatomic) IBOutlet UILabel *addressLbl;
@property (strong, nonatomic) IBOutlet UILabel *statusAcceptedLbl;
@property (strong, nonatomic) IBOutlet UILabel *notificationCountLbl;
@property (strong, nonatomic) IBOutlet UILabel *dontHaveMessageLbl;
@property (strong, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (strong, nonatomic) IBOutlet UILabel *cancelFeeLbl;
@property (strong, nonatomic) IBOutlet UILabel *cancelMessageLbl;
@property (strong, nonatomic) IBOutlet UILabel *seperatorLbl;
@property (strong, nonatomic) IBOutlet UIImageView *dateValueImageView;

@end
