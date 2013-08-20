//
//  TweetDetailViewController.h
//  twitter
//
//  Created by Mohtashim Khan on 8/19/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@interface TweetDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userFullName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UITextView *tweetView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UIView *retweetedByContainer;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *rtBtn;

- (IBAction)sendRetweet:(id)sender;
- (IBAction)favoriteTweet:(id)sender;
- (IBAction)sendReply:(id)sender;

@property (nonatomic, strong) Tweet * tweet;

@end
