//
//  AddArtViewCell1.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 16/07/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddArtViewCell1 : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorVirticalLine;
@property (strong, nonatomic) IBOutlet UIView *viContainerLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnLeft;

@property (strong, nonatomic) IBOutlet UIView *viContainerRight;
@property (strong, nonatomic) IBOutlet UILabel *lblRight;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnRight;

@end
