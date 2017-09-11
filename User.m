//
//  User1.m
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "User.h"

@implementation User

- (id) initWithServerResponse:(NSDictionary*) responseObject
{
    self = [super initWithServerResponse:responseObject];
    if (self) {
        
        self.firstName = [responseObject objectForKey:@"first_name"];
        self.lastName = [responseObject objectForKey:@"last_name"];
        
        NSNumber *userID = [responseObject objectForKey:@"id"];
        self.userID = userID.stringValue;
        
        NSNumber *audio = [responseObject objectForKey:@"can_see_audio"];
        self.availableAudios = [NSString stringWithFormat:@"%@", [audio isEqual:@1] ? @"Yes" : @"No"];
        
        NSDictionary *country = [responseObject objectForKey:@"country"];
        NSString *stringCountry = [country objectForKey:@"title"];
        if (stringCountry.length != 0) {
            self.country = stringCountry;
        }else{
            self.country = @"n/a";
        }
        
        NSNumber *followers = [responseObject objectForKey:@"followers_count"];
        self.followers = followers.stringValue;
        
        NSNumber *mobile = [responseObject objectForKey:@"has_mobile"];
        self.hasAPhone = [NSString stringWithFormat:@"%@", [mobile isEqual:@1] ? @"Yes" : @"No"];
        
        NSNumber *online = [responseObject objectForKey:@"online"];
        self.online = [NSString stringWithFormat:@"%@", [online isEqual:@1] ? @"Yes" : @"No"];
        
        NSNumber *sex = [responseObject objectForKey:@"sex"];
        self.sex = [NSString stringWithFormat:@"%@", [sex isEqual:@1] ? @"Female" : @"Male"];
        
        NSString* smallUrlString = [responseObject objectForKey:@"photo_50"];
        if (smallUrlString) {
            self.smallImageURL = [NSURL URLWithString:smallUrlString];
        }
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        if (urlString) {
            self.imageURL = [NSURL URLWithString:urlString];
        }
        
        NSString* bigUrlString = [responseObject objectForKey:@"photo_max_orig"];
        if (bigUrlString) {
            self.bigUrlString = [NSURL URLWithString:bigUrlString];
        }
    }
    return self;
}


@end
