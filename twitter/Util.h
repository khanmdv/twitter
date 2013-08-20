//
//  Util.h
//  twitter
//
//  Created by Mohtashim Khan on 8/20/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(float) heightForString : (NSString*) str withFontSize:(float) fontSize andWidth :(float) width;

+(NSString*) formatDateForDisplay : (NSString*)date inputFormat: (NSString*)inputFormat outputFormat : (NSString*)outputFormat andOffset: (int)offset;

@end
