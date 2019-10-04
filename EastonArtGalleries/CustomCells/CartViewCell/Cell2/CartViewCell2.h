//
//  CartViewCell2.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 29/06/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewCell2 : UITableViewCell

@property (strong, nonatomic) IBOutlet UIView *viContainerCell;
@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;
@property (strong, nonatomic) IBOutlet UILabel *lblOrderTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceWithAllTaxes;

@end
