//
//  MoviesTableViewCell.h
//  RottenTomatoes
//
//  Created by Chad Jewsbury on 10/20/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;
@property (weak, nonatomic) IBOutlet UILabel *lengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *criticsRatingImage;
@property (weak, nonatomic) IBOutlet UIImageView *audienceRatingImage;
@property (weak, nonatomic) IBOutlet UILabel *audienceRatingLabel;
@property (weak, nonatomic) IBOutlet UILabel *criticsRatingLabel;

@end
