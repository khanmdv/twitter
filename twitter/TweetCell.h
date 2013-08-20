//
//  TweetCell.h
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetCell : UITableViewCell

// RT
@property (weak, nonatomic) IBOutlet UIImageView* rtImg;
@property (weak, nonatomic) IBOutlet UILabel* rtLabel;

// Tweet
@property (weak, nonatomic) IBOutlet  UIImageView* userImg;
@property (weak, nonatomic) IBOutlet  UILabel* userFullNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel* userNameLabel;
@property (weak, nonatomic) IBOutlet  UILabel* timeLabel;
@property (weak, nonatomic) IBOutlet  UITextView* tweetTextView;

// Container Views
@property (weak, nonatomic) IBOutlet  UIView* rtContainerView;
@property (weak, nonatomic) IBOutlet  UIView* tweetContainerView;

-(void) resizeTweetViewWithDiff : (float) diff;
-(void) enableRetweetHeader : (BOOL) enable;

@end
