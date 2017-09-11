//
//  ServerManage.m
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "ServerManager.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "AccessToken.h"

#import "User.h"
#import "Post.h"
#import "Group.h"

@interface ServerManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) AccessToken* accessToken;
@property (strong, nonatomic) NSString *userID;

@end


@implementation ServerManager

+ (ServerManager*) sharedManager {
    
    static ServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    return self;
}

-(void)getSubscriptionsOfUser:(NSString *)userID
                       offset:(NSInteger)offset
                        count:(NSInteger)count
                    onSuccess:(void (^)(NSArray *, NSString *))success
                    onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,                 @"user_id",
     @(offset),              @"offset",
     @(count),               @"count",
     self.accessToken.token, @"access_token",
     @1,                     @"extended",
     @"5.68",                @"v", nil];
    
    [self.sessionManager GET:@"users.getSubscriptions"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSLog(@"SUBS: %@", responseObject);
                         
                         NSDictionary *response = [responseObject objectForKey:@"response"];
                         NSNumber *amount = [response objectForKey:@"count"];
                         NSString *subAmount = amount.stringValue;
                         
                         NSMutableArray *subs = [NSMutableArray array];
                         
                         NSArray *items = [response objectForKey:@"items"];
                         for (NSDictionary *dict in items) {
                             NSString *type = [dict objectForKey:@"type"];
                             if ([type isEqualToString:@"page"]) {
                                 Group *group = [[Group alloc] initWithServerResponse:dict];
                                 [subs addObject:group];
                             }else{
                                 User *user = [[User alloc] initWithServerResponse:dict];
                                 [subs addObject:user];
                             }
                         }
                         
                         if (success) {
                             success(subs, subAmount);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                     }];
    
}

-(void)getFollowersOfUser:(NSString *)userID
                   offset:(NSInteger)offset
                    count:(NSInteger)count
                onSuccess:(void (^)(NSArray *, NSString *))success
                onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,                 @"user_id",
     @(offset),              @"offset",
     @(count),               @"count",
     @"photo_50, photo_100", @"fileds",
     self.accessToken.token, @"access_token",
     @"nom",                 @"name_case",
     @1,                     @"extended",
     @"5.68",                @"v",
     nil];
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //NSLog(@"FOLLOWERS: %@", responseObject);
                         
                         NSDictionary *response = [responseObject objectForKey:@"response"];
                         NSNumber *amount = [response objectForKey:@"count"];
                         NSString *subAmount = amount.stringValue;
                         
                         NSMutableArray *followers = [NSMutableArray array];
                         
                         NSArray *items = [response objectForKey:@"items"];
                         
                         [followers addObjectsFromArray:items];
                         
                         if (success) {
                             success(followers, subAmount);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                     }];
}

-(void)sendMessage:(NSString *)text
         onSuccess:(void (^)(id))success
         onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.accessToken.userID,   @"user_id",
     text,                      @"message",
     self.accessToken.token,    @"access_token",
     @"5.68",                   @"v", nil];
    
    [self.sessionManager POST:@"messages.send"
                   parameters:parameters
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //NSLog(@"JSON: %@", responseObject);
                         
                         if (success) {
                             success(responseObject);
                         }
                     }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                     }];
}

-(void)getWallOfGroup:(NSString *)groupID
               offset:(NSInteger)offset
                count:(NSInteger)count
            onSuccess:(void (^)(NSArray *))success
            onFailure:(void (^)(NSError *, NSInteger))failure
{
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,                @"owner_id",
     @(offset),              @"offset",
     @(count),               @"count",
     @"all",                 @"filter",
     self.accessToken.token, @"access_token",
     @"5.68",                @"v", nil];
    
    [self.sessionManager GET:@"wall.get"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         //NSLog(@"WALL: %@", responseObject);
                         
                         NSDictionary *dictsArray = [responseObject objectForKey:@"response"];
                         NSArray *items = [dictsArray objectForKey:@"items"];
                         NSMutableArray *posts = [NSMutableArray array];
                         
                         for (NSDictionary *dict in items) {
                             Post *post = [[Post alloc] initWithServerResponse:dict];
                             [posts addObject:post];
                         }
                         
                         if (success) {
                             success(posts);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             NSLog(@"Error: %@. Status: %ld",
                                   error.localizedDescription, task.taskIdentifier);
                         }
                     }];
}

-(void)authorizeUser:(AccessToken *)token
{
    self.accessToken = token;
    self.userID = token.userID;
}

- (void) getUser:(NSString*) userID
       onSuccess:(void(^)(User* user)) success
       onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* params =
    [NSDictionary dictionaryWithObjectsAndKeys:
     userID,        @"user_ids",
     @"photo_50, photo_100, photo_max_orig, sex, country, followers_count, online, has_mobile, can_see_audio", @"fields",
     @"nom",        @"name_case",
     self.accessToken.token, @"access_token",
     @"5.68",        @"v", nil];
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         //NSLog(@"USER: %@", responseObject);
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         NSDictionary *userData = [dictsArray objectAtIndex:0];
                         
                         User* user = [[User alloc] initWithServerResponse:userData];
                         if (success) {
                             success(user);
                         }else {
                             NSLog(@"Error");
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                     }];
}

-(void)getGroup:(NSString *)groupID
      onSuccess:(void (^)(Group *))success
      onFailure:(void (^)(NSError *, NSInteger))failure
{
    NSString *newGroupID = [groupID substringFromIndex:1];
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     newGroupID,                @"group_id",
     @"photo_100",               @"fields",
     self.accessToken.token,    @"access_token",
     @"5.68",                   @"v", nil];
    
    [self.sessionManager GET:@"groups.getById"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         //NSLog(@"GROUP: %@", responseObject);
                         NSArray* dictsArray = [responseObject objectForKey:@"response"];
                         
                         if ([dictsArray count] > 0) {
                             Group* group = [[Group alloc] initWithServerResponse:[dictsArray firstObject]];
                             if (success) {
                                 success(group);
                             }
                         } else {
                             NSLog(@"Error");
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                     }];
}


- (void) getFriendsWithOffset:(NSInteger) offset
                        count:(NSInteger) count
                    onSuccess:(void(^)(NSArray* friends)) success
                    onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     self.userID,   @"user_id",
     self.accessToken.token, @"access_token",
     @"name",       @"order",
     @(count),      @"count",
     @(offset),     @"offset",
     @"photo_100, photo_50",   @"fields",
     @"nom",        @"name_case",
     @"5.68", @"v", nil];
    
    [self.sessionManager GET:@"friends.get"
                  parameters:parameters
                    progress:^(NSProgress * _Nonnull downloadProgress) {
                    }
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         //NSLog(@"JSON: %@", responseObject);
                         
                         NSDictionary* commonResponse = [responseObject objectForKey:@"response"];
                         NSArray *dictsArray = [commonResponse objectForKey:@"items"];
                         
                         NSMutableArray* objectsArray = [NSMutableArray array];
                         
                         for (NSDictionary* dict in dictsArray) {
                             User* user = [[User alloc] initWithServerResponse:dict];
                             [objectsArray addObject:user];
                         }
                         
                         if (success) {
                             success(objectsArray);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@. Status: %ld",
                               error.localizedDescription, task.taskIdentifier);
                     }];
}


- (void) postText:(NSString*) text
      onGroupWall:(NSString*) groupID
        onSuccess:(void(^)(id result)) success
        onFailure:(void(^)(NSError* error, NSInteger statusCode)) failure {
    
    if (![groupID hasPrefix:@"-"]) {
        groupID = [@"-" stringByAppendingString:groupID];
    }
    
    NSDictionary* parameters =
    [NSDictionary dictionaryWithObjectsAndKeys:
     groupID,       @"owner_id",
     text,          @"message",
     self.accessToken.token, @"access_token", nil];
    
    [self.sessionManager POST:@"wall.post"
                   parameters:parameters
                     progress:^(NSProgress * _Nonnull uploadProgress) {
                     }
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          //NSLog(@"JSON: %@", responseObject);
                          
                          if (success) {
                              success(responseObject);
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@. Status: %ld",
                                error.localizedDescription, task.taskIdentifier);
                      }];
}

@end
