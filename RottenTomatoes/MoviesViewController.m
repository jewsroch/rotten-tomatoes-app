//
//  ViewController.m
//  RottenTomatoes
//
//  Created by Chad Jewsbury on 10/20/15.
//  Copyright © 2015 Chad Jewsbury. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailsViewController.h"
#import "JTProgressHUD.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *movies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.errorView.hidden = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.title = @"Movies";
    
    [self fetchMovies:YES];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
}

- (void)refresh {
    [self fetchMovies:NO];
}

- (void)fetchMovies:(BOOL)showLoading {
    NSString *urlString = @"https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json";

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    NSURLSession *session =
    [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                  delegate: nil
                             delegateQueue: [NSOperationQueue mainQueue]];
    if (showLoading) {
        [JTProgressHUD show];
    }

    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (!error) {
                                                    NSError *jsonError = nil;
                                                    NSDictionary *responseDictionary =
                                                    [NSJSONSerialization JSONObjectWithData:data
                                                                                    options:kNilOptions
                                                                                      error:&jsonError];

                                                    self.movies = responseDictionary[@"movies"];
                                                    [self.tableView reloadData];
                                                    self.errorView.hidden = YES;
                                                    if ([JTProgressHUD isVisible]) {
                                                        [JTProgressHUD hide];
                                                    }
                                                    [self.refreshControl endRefreshing];
                                                } else {
                                                    [self.refreshControl endRefreshing];
                                                    self.errorView.hidden = NO;
                                                    self.errorLabel.text = error.localizedDescription;
                                                    if ([JTProgressHUD isVisible]) {
                                                        [JTProgressHUD hide];
                                                    }
                                                    NSLog(@"An error occurred: %@", error.description);
                                                }
                                            }];

    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.movies.count) {
        return self.movies.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MoviesTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"movieCell"];

    NSNumber *audienceRating = self.movies[indexPath.row][@"ratings"][@"audience_score"];
    NSNumber *criticsRating = self.movies[indexPath.row][@"ratings"][@"critics_score"];
    NSString *audienceStatus = ([audienceRating intValue] >= 60) ? @"fresh" : @"rotten";
    NSString *criticStatus = ([criticsRating intValue] >= 60) ? @"fresh" : @"rotten";
    NSURL *posterUrl = [NSURL URLWithString:self.movies[indexPath.row][@"posters"][@"thumbnail"]];

    cell.titleLabel.text    = self.movies[indexPath.row][@"title"];
    cell.synopsisLabel.text = self.movies[indexPath.row][@"synopsis"];
    cell.ratingLabel.text = self.movies[indexPath.row][@"mpaa_rating"];
    cell.audienceRatingLabel.text = [NSString stringWithFormat: @"%@%%", [audienceRating stringValue]];
    cell.criticsRatingLabel.text = [NSString stringWithFormat: @"%@%%", [criticsRating stringValue]];
    cell.lengthLabel.text = [NSString stringWithFormat:@"%@ min", [self.movies[indexPath.row][@"runtime"] stringValue]];
    [cell.audienceRatingImage setImage:[UIImage imageNamed:audienceStatus]];
    [cell.criticsRatingImage setImage:[UIImage imageNamed:criticStatus]];
    [cell.posterImageView setImageWithURL:posterUrl placeholderImage:[UIImage imageNamed:@"ticket"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.movie = self.movies[indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
