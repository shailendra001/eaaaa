//
//  OrderDetailViewController.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController
{
        NSArray* arrData;
        NSString* baseURL;
}

@property (strong, nonatomic) NSString* orderID;
@property (strong, nonatomic) NSArray* arrData;
@property (strong, nonatomic) NSString* titleString;
@property (strong, nonatomic) NSString* from;
@property (strong, nonatomic) NSString* fromVC;
@property (strong, nonatomic) NSString* baseURL;

@property (strong, nonatomic) IBOutlet UIView *viContainerTitleBar;
@property (strong, nonatomic) IBOutlet UIImageView *imgViTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//

//Review
@property (strong, nonatomic) IBOutlet UIView *viContainerReview;
@property (strong, nonatomic) IBOutlet UIView *viContainerReviewTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblReviewTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtviReview;
@property (strong, nonatomic) IBOutlet EDStarRating *viRating;
@property (strong, nonatomic) IBOutlet UIView *viContainerReviewSubmit;
@property (strong, nonatomic) IBOutlet UILabel *lblReviewSubmit;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnReviewSubmit;
@property (strong, nonatomic) IBOutlet UIView *viContainerReviewClose;
@property (strong, nonatomic) IBOutlet UIImageView *imgReviewClose;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnReviewClose;



//Cancel Order
@property (strong, nonatomic) IBOutlet UIView *viContainerCancelOrder;
@property (strong, nonatomic) IBOutlet UIView *viContainerCancelOrderTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblCancelOrderTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtviCancelOrder;
@property (strong, nonatomic) IBOutlet UIView *viContainerUpload;
@property (strong, nonatomic) IBOutlet UILabel *lblUploadTitle;
@property (strong, nonatomic) IBOutlet UIView *viContainerBrowse;
@property (strong, nonatomic) IBOutlet UILabel *lblBrowse;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnBrowse;
@property (strong, nonatomic) IBOutlet UILabel *lblSelectedFile;

@property (strong, nonatomic) IBOutlet UIView *viContainerCancelOrderSubmit;
@property (strong, nonatomic) IBOutlet UILabel *lblCancelOrderSubmit;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnCancelOrderSubmit;


@property (strong, nonatomic) IBOutlet UIView *viContainerCancelOrderClose;
@property (strong, nonatomic) IBOutlet UIImageView *imgCancelOrderClose;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnCancelOrderClose;

@end
