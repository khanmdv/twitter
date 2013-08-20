//
//  Tweet.m
//  twitter
//
//  Created by Timothy Lee on 8/5/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Tweet.h"
#import "Util.h"
#import "constants.h"

@implementation Tweet

@synthesize tweetTextHeight=_tweetTextHeight;
@synthesize retweetedByMe=_retweetedByMe, favoritedByMe=_favoritedByMe;
@synthesize displayTime=_displayTime;

-(NSUInteger) tweetId{
    return [[self.data valueOrNilForKeyPath:@"id"] integerValue];
}

-(NSString*) time{
    return [self.data valueOrNilForKeyPath:@"created_at"];
}

- (NSString *)text {
    return [self.data valueOrNilForKeyPath:@"text"];
}

- (NSUInteger)retweetCount {
    return  [[self.data valueOrNilForKeyPath:@"retweet_count"] integerValue];
}

- (NSUInteger)favoriteCount {
    return  [[self.data valueOrNilForKeyPath:@"favourites_count"] integerValue];
}

- (BOOL)retweeted {
    return  [self.data valueOrNilForKeyPath:@"retweeted_status"] != nil;
}

- (NSString *)retweetedBy {
    if (self.retweeted){
        return [self.data valueOrNilForKeyPath:@"user.name"];
    } else {
        return @"";
    }
}

- (NSString *)userImg {
    if (self.retweeted){
        return [self.data valueOrNilForKeyPath:@"retweeted_status.user.profile_image_url"];
    } else {
        return [self.data valueOrNilForKeyPath:@"user.profile_image_url"];
    }
}

- (NSString *)userFullName {
    if (self.retweeted){
        return [self.data valueOrNilForKeyPath:@"retweeted_status.user.name"];
    }else{
        return [self.data valueOrNilForKeyPath:@"user.name"];
    }
}

- (NSString *)userName {
    if (self.retweeted){
        return [self.data valueOrNilForKeyPath:@"retweeted_status.user.screen_name"];
    }else{
        return [self.data valueOrNilForKeyPath:@"user.screen_name"];
    }
}

// Calculate height of the string bound by the tweet container
- (float) tweetTextHeight{
    if (_tweetTextHeight == 0.0 && self.text != nil){
        _tweetTextHeight = [Util heightForString:self.text withFontSize:13 andWidth:TWEET_CONTAINER_WIDTH];
    }
    return _tweetTextHeight;
}

- (NSString*) displayTime{
    if (_displayTime == nil){
        _displayTime = [Util formatDateForDisplay:self.time
                                      inputFormat:@"EEE MMM dd HH:mm:ss ZZZ yyyy"
                                     outputFormat:nil
                                        andOffset:[[self.data valueOrNilForKeyPath:@"utc_offset"] integerValue]];
    }
    return _displayTime;
}

-(BOOL) retweetedByMe{
    return [[self.data valueOrNilForKeyPath:@"retweeted"] boolValue] || _retweetedByMe;
}

-(BOOL) favoritedByMe{
    return [[self.data valueOrNilForKeyPath:@"favorited"] boolValue] || _favoritedByMe;
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [[NSMutableArray alloc] initWithCapacity:array.count];
    for (NSDictionary *params in array) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:params]];
    }
    return tweets;
}

@end
