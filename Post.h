//
//  Post1.h
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "ServerObject.h"

@interface Post : ServerObject

@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString *date;
@property (assign, nonatomic) NSInteger likes;
@property (assign, nonatomic) NSInteger comments;
@property (strong, nonatomic) NSString *ownerID;

@property (strong, nonatomic) NSURL *ownerPhoto;
@property (strong, nonatomic) NSString *ownerFullName;

@end
