//
//  Util.m
//  twitter
//
//  Created by Mohtashim Khan on 8/20/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "Util.h"

@implementation Util

+(float) heightForString : (NSString*) str withFontSize:(float) fontSize andWidth :(float) width{
    CGSize size = CGSizeMake(width, 0.0);
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIFont systemFontOfSize:fontSize], NSFontAttributeName,
                                [NSParagraphStyle defaultParagraphStyle], NSParagraphStyleAttributeName,
                                nil];
    CGRect boundingRect = [str boundingRectWithSize:size
                                            options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil];
    
    return boundingRect.size.height;
}

+(NSString*) formatDateForDisplay : (NSString*)dateStr inputFormat: (NSString*)inputFormat outputFormat : (NSString*)outputFormat andOffset: (int)offset{
    NSString * result;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:inputFormat];
    NSDate *now = [[NSDate alloc] init];
    NSDate *date  = [formatter dateFromString:dateStr];
    
    NSTimeInterval timeInMillis = now.timeIntervalSinceNow - date.timeIntervalSinceNow;
    
    NSLog(@"%@, %f", dateStr, timeInMillis);
    
    if (outputFormat == nil){
        if (timeInMillis < 1000){
            result = @"Now";
        } else if (timeInMillis/1000 < 60){ // Seconds
            result = [NSString stringWithFormat:@"%ds", (int)(timeInMillis/1000)];
        } else if (timeInMillis/1000 >= 60){
            result = [NSString stringWithFormat:@"%dm", (int)(timeInMillis/60000)];
        } else if (timeInMillis/60000 < 60){
            result = [NSString stringWithFormat:@"%dh", (int)(timeInMillis/3600000)];
        } else{
            result = @"Long";
        }
    } else {
        [formatter setDateFormat:outputFormat];
        result = [formatter stringFromDate:date];
    }
    
    return result;
}

@end
