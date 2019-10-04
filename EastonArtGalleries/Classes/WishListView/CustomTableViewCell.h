//
//  CustomTableViewCell.h
//  EastonArtGalleries
//
//  Created by Shailendra on 03/10/19.
//  Copyright © 2019 infoicon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView* customImg;
@property(nonatomic,weak)IBOutlet UILabel* lblTitle;


@end

NS_ASSUME_NONNULL_END
