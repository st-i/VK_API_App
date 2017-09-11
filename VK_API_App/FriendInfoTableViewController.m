//
//  FriendInfoTableViewController.m
//  VK_API_App
//
//  Created by iStef on 09.09.17.
//  Copyright © 2017 Stefanov. All rights reserved.
//

#import "FriendInfoTableViewController.h"
#import "ServerManager.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UserPhotoTableViewCell.h"
#import "FollowersTVC.h"
#import "SubscriptionsTVC.h"

@interface FriendInfoTableViewController ()

@property (strong, nonatomic) User *user;

@end

@implementation FriendInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"User Info";
    
    [self getInfoAboutFriend];
    [self getSubscriptionsOfUser];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //[self getInfoAboutFriend];
}

-(void)getInfoAboutFriend
{
    [[ServerManager sharedManager] getUser:self.friendID
                                 onSuccess:^(User *user) {
                                     self.user = user;
                                     [self.tableView reloadData];
    }
                                 onFailure:^(NSError *error, NSInteger statusCode) {
                                     NSLog(@"NO!!");
    }];
}

-(void)getSubscriptionsOfUser
{
    [[ServerManager sharedManager] getSubscriptionsOfUser:self.friendID
                                                   offset:0
                                                    count:5
                                                onSuccess:^(NSArray *subscriptions, NSString *amount) {
                                                    self.user.subscriptions = amount;
                                                    [self.tableView reloadData];
    }
                                                onFailure:^(NSError *error, NSInteger statusCode) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        UserPhotoTableViewCell *photoCell = (UserPhotoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        
        if (!photoCell) {
            NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"UserPhoto" owner:self options:nil];
            photoCell = [nibArray objectAtIndex:0];
        }
        
        NSURLRequest* request = [NSURLRequest requestWithURL:self.user.bigUrlString];
        
        __weak UserPhotoTableViewCell* weakCell = photoCell;
        
        photoCell.userPhoto.image = nil;
        
        [photoCell.userPhoto
         setImageWithURLRequest:request
         placeholderImage:nil
         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
             weakCell.userPhoto.image = image;
             [weakCell layoutSubviews];
         }
         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
             
         }];
        
        photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return photoCell;
        
    }else{
        static NSString *infoCell = @"infoCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCell];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:infoCell];
        }
        
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"First Name";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.firstName;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 2:
                cell.textLabel.text = @"Last Name";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.lastName;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 3:
                cell.textLabel.text = @"Sex";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.sex;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 4:
                cell.textLabel.text = @"Country";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.country;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 5:
                cell.textLabel.text = @"Online";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.online;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 6:
                cell.textLabel.text = @"Followers";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.followers;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                break;
            case 7:
                cell.textLabel.text = @"Subscriptions";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.subscriptions;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleDefault;
                break;
            case 8:
                cell.textLabel.text = @"Use A Phone";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.hasAPhone;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
            case 9:
                cell.textLabel.text = @"Others Can See Audio";
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.detailTextLabel.text = self.user.availableAudios;
                cell.detailTextLabel.textColor = [UIColor blackColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                break;
                
            default:
                break;
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 6) {
        FollowersTVC *followers = [[FollowersTVC alloc] init];
        followers.friendID = self.friendID;
        [self.navigationController pushViewController:followers animated:YES];
    }else if (indexPath.row == 7) {
        SubscriptionsTVC *subs = [[SubscriptionsTVC alloc] init];
        subs.friendID = self.friendID;
        [self.navigationController pushViewController:subs animated:YES];
    }
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 200;
    }else{
        return 44.f;
    }
}

@end
