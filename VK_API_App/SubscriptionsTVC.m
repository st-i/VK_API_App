//
//  SubscriptionsTVC.m
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "SubscriptionsTVC.h"

#import "ServerManager.h"
#import "User.h"
#import "Group.h"
#import "UIImageView+AFNetworking.h"

@interface SubscriptionsTVC ()

@property (strong, nonatomic) NSMutableArray* subscriptionsArray;
@property (strong, nonatomic) NSString *subscriptionsAmount;

@end

@implementation SubscriptionsTVC

static NSInteger subscriptionsInRequest = 30;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.subscriptionsArray = [NSMutableArray array];
    
    self.navigationItem.title = @"Subscriptions";
    
    [self getSubscritpions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)getSubscritpions
{
    [[ServerManager sharedManager]
     getSubscriptionsOfUser:self.friendID
     
     offset:self.subscriptionsArray.count
     count:subscriptionsInRequest
     onSuccess:^(NSArray *subscriptions, NSString *amount) {
         [self.subscriptionsArray addObjectsFromArray:subscriptions];
         self.subscriptionsAmount = amount;
         NSMutableArray* newPaths = [NSMutableArray array];
         for (int i = (int)[self.subscriptionsArray count] - (int)[subscriptions count]; i < [self.subscriptionsArray count]; i++) {
             [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
         }
         
         [self.tableView beginUpdates];
         [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
         [self.tableView endUpdates];

    }
     onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"NO!");
     }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subscriptionsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.subscriptionsArray count]) {
        
        if (self.subscriptionsArray.count == self.subscriptionsAmount.integerValue) {
            cell.textLabel.text = [NSString stringWithFormat:@"Amount Of Subscriptions: %@", self.subscriptionsAmount];
            cell.textLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.image = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            cell.textLabel.text = @"Load more...";
            cell.textLabel.textColor = [UIColor blueColor];
            cell.imageView.image = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
        
    } else {
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imageView.image = nil;
        __weak UITableViewCell* weakCell = cell;
        cell.textLabel.textColor = [UIColor blackColor];
        
        id subscription = [self.subscriptionsArray objectAtIndex:indexPath.row];
        
        if ([subscription isKindOfClass:[Group class]]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [(Group *)subscription name]];
            NSURLRequest* request = [NSURLRequest requestWithURL:[(Group *)subscription photoURL]];
            
            [cell.imageView
             setImageWithURLRequest:request
             placeholderImage:nil
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                 weakCell.imageView.image = image;
                 weakCell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
                 [weakCell.imageView setClipsToBounds:YES];
                 [weakCell layoutSubviews];
             }
             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             }];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [(User *)subscription firstName], [(User *)subscription lastName]];
            NSURLRequest* request = [NSURLRequest requestWithURL:[(User *)subscription imageURL]];
            
            [cell.imageView
             setImageWithURLRequest:request
             placeholderImage:nil
             success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                 weakCell.imageView.image = image;
                 weakCell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
                 [weakCell.imageView setClipsToBounds:YES];
                 [weakCell layoutSubviews];
             }
             failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             }];
        }
        
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.subscriptionsArray count]) {
        [self getSubscritpions];
    }
}

@end
