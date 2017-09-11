//
//  WallPostCell.m
//  VK_API_App
//
//  Created by iStef on 09.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "WallPostCell.h"

@implementation WallPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/*+ (CGFloat) heightForText:(NSString*) text
{
    UIFont* font = [UIFont systemFontOfSize:17.f];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowBlurRadius = 0.5;
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraph setAlignment:NSTextAlignmentLeft];
    
    NSDictionary* attributes =
    [NSDictionary dictionaryWithObjectsAndKeys:
     font, NSFontAttributeName,
     paragraph, NSParagraphStyleAttributeName,
     shadow, NSShadowAttributeName, nil];
    
    
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(, CGFLOAT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:attributes
                                          context:nil];
    
    return CGRectGetHeight(rect) + 2 * offset;
}*/

@end
