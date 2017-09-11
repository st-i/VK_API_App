//
//  Group.h
//  VK_API_App
//
//  Created by iStef on 09.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerObject.h"


@interface Group : ServerObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *photoURL;

@end
