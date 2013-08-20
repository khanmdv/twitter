//
//  TweetCell.m
//  twitter
//
//  Created by Timothy Lee on 8/6/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TweetCell.h"
#import <QuartzCore/QuartzCore.h>

#define kInsetValue 10.0

@implementation TweetCell

@synthesize rtImg, rtLabel, userImg, userFullNameLabel, userNameLabel, tweetTextView, timeLabel;
@synthesize rtContainerView, tweetContainerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void) enableRetweetHeader : (BOOL) enable{
    self.rtContainerView.hidden = !enable;
    
    if (enable) {
        // Shift down the tweet container
        self.rtContainerView.frame = CGRectMake(10, 10, 300, 20);
        self.tweetContainerView.frame = CGRectMake(10, 30, 300, 60);
    } else {
        // Shift up the tweet container
        self.rtContainerView.frame = CGRectMake(10, 10, 300, 0);
        self.tweetContainerView.frame = CGRectMake(10, 10, 300, 60);
    }
}

-(void) resizeTweetViewWithDiff : (float) diff
{
    CGRect tweetViewContainerRect = self.tweetContainerView.frame;
    CGRect tweetViewRect = self.tweetTextView.frame;
    tweetViewRect.size.height += diff;
    tweetViewContainerRect.size.height += diff;
    
    self.tweetContainerView.frame = tweetViewContainerRect;
    self.tweetTextView.frame = tweetViewRect;
}

@end
