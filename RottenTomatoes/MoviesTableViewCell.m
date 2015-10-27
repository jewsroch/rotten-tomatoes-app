//
//  MoviesTableViewCell.m
//  RottenTomatoes
//
//  Created by Chad Jewsbury on 10/20/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "MoviesTableViewCell.h"

@implementation MoviesTableViewCell

- (void)awakeFromNib {
    // set selection color
    UIView *myBackView = [[UIView alloc] initWithFrame:self.frame];
    myBackView.backgroundColor = [UIColor colorWithRed:0.25 green:0.42 blue:0.27 alpha:1.0];
    self.selectedBackgroundView = myBackView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor colorWithRed:0.25 green:0.42 blue:0.27 alpha:1.0];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}
@end
