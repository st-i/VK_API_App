//
//  Group.m
//  VK_API_App
//
//  Created by iStef on 09.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "Group.h"

@implementation Group

-(id)initWithServerResponse:(NSDictionary *)responseObject
{
    self = [super initWithServerResponse:responseObject];
    
    if (self) {
        self.name = [responseObject objectForKey:@"name"];
        
        NSString* urlString = [responseObject objectForKey:@"photo_100"];
        
        if (urlString) {
            self.photoURL = [NSURL URLWithString:urlString];
        }
    }
    return self;
}

@end
