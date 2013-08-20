//
//  ComposeTweetModalViewController.m
//  twitter
//
//  Created by Mohtashim Khan on 8/19/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "ComposeTweetModalViewController.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
#import "TwitterClient.h"

#define kPlaceholderText    @"What's happening?"

@interface ComposeTweetModalViewController ()

@end

@implementation ComposeTweetModalViewController

@synthesize replyTo;

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
    
    if (self.replyTo == nil){
        self.tweetTextView.text = kPlaceholderText;
        self.tweetTextView.textColor = [UIColor lightGrayColor];
    } else{
        self.tweetTextView.text = [NSString stringWithFormat:@"@%@", self.replyTo];
    }
    
    if ([User currentUser]){
        User *user = [User currentUser];
        self.userFullName.text = [user objectForKey:@"name"];
        self.userName.text = [NSString stringWithFormat:@"@%@", [user objectForKey:@"screen_name"]];
        self.userImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[user objectForKey:@"profile_image_url"]]]];
        
        
    }
    
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 5.0;
    self.sendTweetButton.enabled = NO;
    
    [self.tweetTextView becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelComposeTweet:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.sendTweetButton.enabled = YES;
    NSString* text = textView.text;
    int len = 140 - text.length;
    self.numCharLabel.text = [NSString stringWithFormat:@"%d", len];
    
    if (len == 140) {
        textView.text = kPlaceholderText;
        textView.textColor = [UIColor lightGrayColor];
        return;
    };
    
    NSString *placeholderText = [text substringFromIndex:1];
    
    if ([placeholderText isEqualToString:kPlaceholderText]){
        textView.text = [text substringToIndex:1];
        textView.textColor = [UIColor blackColor];
        self.sendTweetButton.enabled = NO;
    }
    
    if (len < 0){
        textView.text = [text substringToIndex:140];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:kPlaceholderText] ){
        NSLog(@"did");
        textView.selectedRange = NSMakeRange(0, 0);
    }
}

- (IBAction)sendTweet:(id)sender {
    NSString* tweet = self.tweetTextView.text;
    
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    [[TwitterClient instance] sendTweet:tweet success:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.spinner stopAnimating];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self.spinner stopAnimating];
        [[[UIAlertView alloc] initWithTitle:@"Oops!" message:@"Couldn't send the tweet, please try again!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}
@end
