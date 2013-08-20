//
//  ComposeTweetModalViewController.h
//  twitter
//
//  Created by Mohtashim Khan on 8/19/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposeTweetModalViewController : UIViewController <UITextViewDelegate>

- (IBAction)cancelComposeTweet:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendTweetButton;

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userFullName;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *numCharLabel;

@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

// Actions
- (IBAction)sendTweet:(id)sender;

@property (strong, nonatomic) NSString *replyTo;

@end
