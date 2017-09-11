//
//  PostCel.h
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel* postTextLabel;

+ (CGFloat) heightForText:(NSString*) text;

@end
