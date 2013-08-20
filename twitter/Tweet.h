//
//  Tweet.h
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : RestObject

// Tweet, Is Retweeted by others
@property (nonatomic, strong, readonly) NSString *text;
@property (nonatomic, assign, readonly) BOOL retweeted;

// User's Image, Full Name, Twitter Handle, time tweeted and actual user
@property (nonatomic, strong, readonly) NSString* userImg;
@property (nonatomic, strong, readonly) NSString* userFullName;
@property (nonatomic, strong, readonly) NSString* userName;
@property (nonatomic, strong, readonly) NSString* time;
@property (nonatomic, strong, readonly) NSString* retweetedBy;

// Retweet count, favorite count
@property (nonatomic, assign, readonly) NSUInteger retweetCount;
@property (nonatomic, assign, readonly) NSUInteger favoriteCount;

// tweet Id
@property (nonatomic, assign, readonly) NSUInteger tweetId;

// Height of the bounding rect of a tweet
// The height is calculated once and stored for faster access
@property (nonatomic, assign, readonly) float tweetTextHeight;

// Local writable properties to assert if a tweet has been marked fav/retweeted
@property (nonatomic, assign) BOOL favoritedByMe;
@property (nonatomic, assign) BOOL retweetedByMe;

// Date in frmat
@property (nonatomic, strong) NSString* displayTime;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array;

@end
