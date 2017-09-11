//
//  Post1.m
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Post.h"

@implementation Post

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        self.text = [responseObject objectForKey:@"text"];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        
        NSTimeInterval timeInterval = [[responseObject objectForKey:@"date"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = @"dd.MM.yyyy hh:mm";
        
        self.date = [df stringFromDate:date];
        
        NSDictionary *commentsDict = [responseObject objectForKey:@"comments"];
        NSNumber *comments = [commentsDict objectForKey:@"count"];
        self.comments = comments.integerValue;
        
        NSDictionary *likesDict = [responseObject objectForKey:@"likes"];
        NSNumber *likes = [likesDict objectForKey:@"count"];
        self.likes = likes.integerValue;
        
        self.ownerID = [responseObject objectForKey:@"from_id"];
    }
    return self;
}

@end
