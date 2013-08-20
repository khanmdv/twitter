//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetCell.h"
#import "ComposeTweetModalViewController.h"
#import "TweetDetailViewController.h"
#import "constants.h"

#define kCellIdentifier @"Cell"
#define kDataAvailable  @"DataAvailable"
#define DELTA(X) X + kTextViewPadding - kTextViewHeight

@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

@property (nonatomic, assign) NSUInteger since_id;
@property (nonatomic, assign) NSUInteger last_tweet_id;

@property (nonatomic, strong) UIView* fetchMoreButtonView;

- (void)onSignOutButton;
- (void)reload;
- (void)composeTweet;

@end

@implementation TimelineVC

@synthesize since_id, last_tweet_id;
@synthesize fetchMoreButtonView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Twitter";
        /*
        self.tweets = [NSMutableArray array];
        
        self.tweets[0] = @{@"text": @"The Times of India is India's most-read English newspaper and the World's largest-selling English newspaper. http://www.yahoo.com",
                           @"retweeted" : @"NO",
                           @"userImg" : @"http://a0.twimg.com/profile_images/378800000305502066/87104f81cf9226166b63c98735bfca58_normal.jpeg",
                           @"userFullName" : @"Times of India",
                           @"userName" : @"timesofindia"};
        
        */
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweet)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Register the NIB file for the tweet cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil]
         forCellReuseIdentifier:kCellIdentifier];
    
    // Add refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    // Add target function for refresh control
    [self.refreshControl addTarget:self
                            action:@selector(getNewTweets)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Tweet* tweet = self.tweets[indexPath.row];
    
    // calculate the delta change in the height due to extra chars of the tweet
    float diff = DELTA(tweet.tweetTextHeight);
    
    //NSLog(@"DIFF -- %f", diff);
    float height = kCellNormalHeight + diff;
    
    // If the tweet is not a retweeted one, subtract the retweet adjustment
    if (!tweet.retweeted){
        height -= kRetweetAdjustment;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.tweets == nil){
        return nil;
    }
    
    if (self.fetchMoreButtonView == nil){
        self.fetchMoreButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        CGRect btnFrame = CGRectMake(96, 7, 129, 30);
        UIButton * fetchMoreButton = [[UIButton alloc] initWithFrame:btnFrame];
        fetchMoreButton.tag = 1000;
        [fetchMoreButton setTitle:@"Load More Tweets" forState:UIControlStateNormal];
        fetchMoreButton.titleLabel.font = [UIFont systemFontOfSize:13.0];
        fetchMoreButton.titleLabel.textColor = [UIColor grayColor];
        
        [fetchMoreButton addTarget:self
                            action:@selector(getOldTweets)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.fetchMoreButtonView addSubview:fetchMoreButton];
        self.fetchMoreButtonView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.2];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.fetchMoreButtonView.hidden = YES;
    }];
    return self.fetchMoreButtonView;
}

-(float) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.tweets == nil){
        return 0.0;
    }else{
        return 44.0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier
                                                            forIndexPath:indexPath];
    // Get the Cell
    TweetCell *tCell = (TweetCell*)cell;
    
    // Get the tweet object
    Tweet *tweet = self.tweets[indexPath.row];
    
    // Set cell data
    tCell.userFullNameLabel.text    = tweet.userFullName;
    tCell.userNameLabel.text        = [NSString stringWithFormat:@"@%@", tweet.userName];
    tCell.tweetTextView.text        = tweet.text;
    tCell.timeLabel.text            = tweet.displayTime;
    tCell.userImg.image             = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tweet.userImg]]];
    tCell.rtLabel.text              = tweet.retweeted ? [NSString stringWithFormat:@"%@ Retweeted", tweet.retweetedBy] : @"";
    
    // Adjust the cell for retweet
    [tCell enableRetweetHeader:tweet.retweeted];
    
    // calculate the delta change in the height due to extra chars of the tweet
    float diff = DELTA(tweet.tweetTextHeight);
    [tCell resizeTweetViewWithDiff:diff];

    // Adjust the Full Name and user name label positions
    [tCell.userFullNameLabel sizeToFit];
    float calculatedWidth = tCell.userFullNameLabel.frame.size.width;
    tCell.userFullNameLabel.frame = CGRectMake(63, 0, calculatedWidth, 20);
    CGRect userNameFrame = tCell.userNameLabel.frame;
    userNameFrame.origin.x = tCell.userFullNameLabel.frame.origin.x + calculatedWidth + kTextViewPadding;
    tCell.userNameLabel.frame = userNameFrame;
    
    // Other effects
    tCell.userImg.layer.masksToBounds = YES;
    tCell.userImg.layer.cornerRadius = 5.0;
    
    // UNCOMMENT BELOW CODE WHILE TESTING WITH DUMMY DATA
    /*
    NSDictionary* tweet = self.tweets[indexPath.row];
    tCell.userFullNameLabel.text = tweet[@"userFullName"];
    tCell.userNameLabel.text = tweet[@"userName"];
    tCell.tweetTextView.text = tweet[@"text"];
    tCell.userImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tweet[@"userImg"]]]];
    [tCell enableRetweetHeader:YES];
    [tCell resizeCellWithDiff:20];
     */
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Tweet * tweet = self.tweets[indexPath.row];
    TweetDetailViewController * tweetDetailsVC = [[TweetDetailViewController alloc] init];
    tweetDetailsVC.tweet = tweet;
    [self.navigationController pushViewController:tweetDetailsVC animated:YES];
}

- (void)scrollViewDidScroll: (UIScrollView*)scrollView {
    // UITableView only moves in one direction, y axis
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;

    // Hide/Show the footer when you reach the bottom of the table
    if ((maximumOffset - currentOffset) <= 10.0) {
        [UIView animateWithDuration:0.5 animations:^{
            self.fetchMoreButtonView.hidden = NO;
        }];
    } else{
        [UIView animateWithDuration:0.5 animations:^{
            self.fetchMoreButtonView.hidden = YES;
        }];
    }
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}


- (void) getNewTweets {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:self.since_id maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        NSArray* newTweets = [Tweet tweetsWithArray:response];
        
        if (newTweets != nil && newTweets.count > 0){
            Tweet* first = newTweets[0];
            self.since_id = first.tweetId;
        }
        
        [self.tweets insertObjects:newTweets
                         atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newTweets.count)]];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
    [self.refreshControl beginRefreshing];
}

- (void) getOldTweets {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:self.last_tweet_id success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        NSArray* oldTweets = [Tweet tweetsWithArray:response];
        
        if (oldTweets != nil && oldTweets.count > 0){
            Tweet* last = [oldTweets lastObject];
            self.last_tweet_id = last.tweetId;
        }
        
        [self.tweets addObjectsFromArray:oldTweets];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        
        if (self.since_id == 0){
            Tweet* first = self.tweets[0];
            self.since_id = first.tweetId;
        }
        
        if (self.last_tweet_id == 0){
            Tweet* last = [self.tweets lastObject];
            self.last_tweet_id = last.tweetId;
        }
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
    [self.refreshControl beginRefreshing];
}

- (void)composeTweet {
    ComposeTweetModalViewController * composeVC = [[ComposeTweetModalViewController alloc] init];
    [self presentViewController:composeVC animated:YES completion:nil];
}


@end
