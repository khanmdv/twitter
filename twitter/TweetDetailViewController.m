//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Mohtashim Khan on 8/19/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "TwitterClient.h"
#import "ComposeTweetModalViewController.h"
#import "Util.h"

@interface TweetDetailViewController ()

@end

@implementation TweetDetailViewController

@synthesize tweet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 5.0;
    
    if (self.tweet){
        self.userFullName.text = tweet.userFullName;
        self.userName.text = [NSString stringWithFormat:@"@%@", tweet.userName];
        self.tweetView.text = tweet.text;
        self.userImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tweet.userImg]]];
        
        self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
        self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
        
        self.dateLabel.text = [Util formatDateForDisplay:tweet.time
                                             inputFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"
                                            outputFormat:@"mm/dd/yy hh:mm" andOffset:0];
        if (tweet.retweeted){
            self.retweetedByContainer.hidden = NO;
            self.retweetedByLabel.text = [NSString stringWithFormat:@"%@ Retweeted", tweet.retweetedBy];
        }
        
        if (tweet.favoritedByMe){
            [self.favoriteBtn setImage:[UIImage imageNamed:@"favorited.png"] forState:UIControlStateNormal];
        }
        
        if (tweet.retweetedByMe){
            [self.rtBtn setImage:[UIImage imageNamed:@"retweet-blue.png"] forState:UIControlStateNormal];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendRetweet:(id)sender {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [[TwitterClient instance] reTweet:tweet.tweetId success:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.spinner stopAnimating];
        [self.rtBtn setImage:[UIImage imageNamed:@"retweet-blue.png"] forState:UIControlStateNormal];
        tweet.retweetedByMe = YES;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.spinner stopAnimating];
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't send the retweet, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (IBAction)favoriteTweet:(id)sender {
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    
    TwitterFavoriteState state = tweet.favoritedByMe ? TwitterFavoriteStateDestroy : TwitterFavoriteStateCreate;
    
    [[TwitterClient instance] favoriteTweet:tweet.tweetId withState:state success:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.spinner stopAnimating];
        
        if (tweet.favoritedByMe){
            [self.favoriteBtn setImage:[UIImage imageNamed:@"favorites.png"] forState:UIControlStateNormal];
            tweet.favoritedByMe = NO;
        } else {
            [self.favoriteBtn setImage:[UIImage imageNamed:@"favorited.png"] forState:UIControlStateNormal];
            tweet.favoritedByMe = YES;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.spinner stopAnimating];
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't favorite the tweet, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (IBAction)sendReply:(id)sender {
    NSString * tweetStr = [NSString stringWithFormat:@"%@ ", tweet.userName];
    ComposeTweetModalViewController * composeTweetVC = [[ComposeTweetModalViewController alloc] init];
    composeTweetVC.replyTo = tweetStr;
    [self presentViewController:composeTweetVC animated:YES completion:nil];
}
@end
