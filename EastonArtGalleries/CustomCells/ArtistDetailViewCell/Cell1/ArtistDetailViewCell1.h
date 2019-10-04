//
//  ArtistDetailViewCell1.h
//  EastonArtGalleries
//
//  Created by Sandeep Kumar on 30/05/16.
//  Copyright © 2016 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistDetailViewCell1 : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblSeparatorLine;
@property (strong, nonatomic) IBOutlet UIView *viContainerGallery;
@property (strong, nonatomic) IBOutlet ZFRippleButton *btnVirtualGallery;

@end
