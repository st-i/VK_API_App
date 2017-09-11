//
//  ServerManage.h
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccessToken.h"
#import "Group.h"

@class User;

@interface ServerManager : NSObject

@property (strong, nonatomic, readonly) User* currentUser;

+ (ServerManager*) sharedManager;

- (void) authorizeUser:(AccessToken*) token;

- (void) getSubscriptionsOfUser:(NSString*) userID
                         offset:(NSInteger) offset
                          count:(NSInteger) count
                      onSuccess:(void(^)(NSArray *subscriptions, NSString *amount)) success
                      onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFollowersOfUser:(NSString*) userID
                     offset:(NSInteger) offset
                      count:(NSInteger) count
                  onSuccess:(void(^)(NSArray *followers, NSString *amount)) success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(User* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) sendMessage:(NSString*) text
           onSuccess:(void(^)(id result)) success
           onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getGroup:(NSString*) groupID
        onSuccess:(void(^)(Group* group)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getWallOfGroup:(NSString*) groupID
                 offset:(NSInteger) offset
                  count:(NSInteger) count
              onSuccess:(void(^)(NSArray *wallPosts)) success
              onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;

- (void) postText:(NSString*) text
      onGroupWall:(NSString*) groupID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure;


@end
