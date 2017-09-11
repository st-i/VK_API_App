//
//  FollowersTVC.m
//  VK_API_App
//
//  Created by iStef on 10.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "FollowersTVC.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"


@interface FollowersTVC ()

@property (strong, nonatomic) NSMutableArray* followersArray;
@property (strong, nonatomic) NSString *followersAmount;

@end

@implementation FollowersTVC

static NSInteger followersInRequest = 30;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.followersArray = [NSMutableArray array];
    
    self.navigationItem.title = @"Followers";
    
    [self getFollowers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)getFollowers
{
    [[ServerManager sharedManager]
     getFollowersOfUser:self.friendID
     offset:self.followersArray.count
     count:followersInRequest
     onSuccess:^(NSArray *followers, NSString *amount) {
    
         self.followersAmount = amount;
         
         for (NSNumber *userID in followers) {

            [[ServerManager sharedManager] getUser:userID.stringValue
            onSuccess:^(User *user) {
            [self.followersArray addObject:user];
            [self.tableView reloadData];

        }
    onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"Error: %@. Status: %ld",
        error.localizedDescription, statusCode);
    }];
    }
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
    return self.followersArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row == [self.followersArray count]) {
        
        if (self.followersArray.count == self.followersAmount.integerValue) {
            cell.textLabel.text = [NSString stringWithFormat:@"Amount Of Followers: %@", self.followersAmount];
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
        
        User* follower = [self.followersArray objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", follower.firstName, follower.lastName];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSURLRequest* request = [NSURLRequest requestWithURL:follower.imageURL];
        
        __weak UITableViewCell* weakCell = cell;
        
        cell.imageView.image = nil;
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
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == [self.followersArray count]) {
        [self getFollowers];
    }
}

@end
