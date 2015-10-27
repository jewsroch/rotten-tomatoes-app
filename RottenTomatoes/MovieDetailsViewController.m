//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Chad Jewsbury on 10/21/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *movieImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *synopsisScrollView;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Get / Build Image Urls
    NSString *urlThumbnail = self.movie[@"posters"][@"thumbnail"];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"http://resizing.flixster.com/.*/.*/.*.cloudfront.net/"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSString *urlOriginalString = [regex stringByReplacingMatchesInString:urlThumbnail
                                                       options:0
                                                         range:NSMakeRange(0, [urlThumbnail length])
                                                  withTemplate:@"http://content6.flixster.com/$1"];
    
    NSURL *urlOriginal = [NSURL URLWithString:urlOriginalString];
    
    // Load thumbnail first (with default if no connection).
    [self.movieImageView setImageWithURL:[NSURL URLWithString:urlThumbnail]
                        placeholderImage:[UIImage imageNamed:@"ticket_large"]];

    // Load high-res once loaded
    [self.movieImageView setImageWithURL:urlOriginal];
    
    // Set Labels
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"synopsis"];
    self.synopsisLabel.numberOfLines = 0;
    [self.synopsisLabel sizeToFit];

    // Get Frame height
    CGFloat frameMaxHeight = self.synopsisScrollView.frame.size.height;
    
    // Update size and position of info frame
    CGRect aFrame = self.infoView.frame;
    aFrame.size.height = self.synopsisLabel.frame.size.height + 80;
    CGFloat offset = (aFrame.size.height < 215) ? (frameMaxHeight - aFrame.size.height) : frameMaxHeight - 215;
    aFrame.origin.y = offset;
    self.infoView.frame = aFrame;

    // Update height of scrollView based on size of infoVie and offset.
    self.synopsisScrollView.contentSize = CGSizeMake(self.synopsisScrollView.bounds.size.width,
                                                     self.infoView.frame.size.height + offset);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
