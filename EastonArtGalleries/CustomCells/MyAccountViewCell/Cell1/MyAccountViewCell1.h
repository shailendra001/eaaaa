//
//  MyAccountViewCell1.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 14/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewCell1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *viContainerImage;
@property (strong, nonatomic) IBOutlet UIImageView *img;

@property (strong, nonatomic) IBOutlet UILabel *lblWalletAmount;
@property (strong, nonatomic) IBOutlet UIView *viContainerAddMoney;
@property (strong, nonatomic) IBOutlet UILabel *lblAddMoney;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnAddMoneyToWallet;

@end