//
//  User1.h
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "ServerObject.h"

@interface User : ServerObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSURL* smallImageURL;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* bigUrlString;
@property (strong, nonatomic) NSString *userID;

@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *online;
@property (strong, nonatomic) NSString *followers;
@property (strong, nonatomic) NSString *subscriptions;
@property (strong, nonatomic) NSString *hasAPhone;
@property (strong, nonatomic) NSString *availableAudios;

@end
