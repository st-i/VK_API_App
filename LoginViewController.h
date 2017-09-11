//
//  LoginViewControlle.h
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccessToken;

typedef void(^LoginCompletionBlock)(AccessToken* token);

@interface LoginViewController : UIViewController


- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock;

@end
